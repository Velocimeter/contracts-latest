// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import 'openzeppelin-contracts/contracts/utils/math/Math.sol';
import 'contracts/ExternalBribe.sol';
import 'contracts/interfaces/IERC20.sol';
import 'contracts/interfaces/IGauge.sol';
import 'contracts/interfaces/IVoter.sol';
import 'contracts/interfaces/IVotingEscrow.sol';

// Bribes pay out rewards for a given pool based on the votes that were received from the user (goes hand in hand with Voter.vote())
contract WrappedBribe {
    address public immutable voter;
    address public immutable _ve;
    ExternalBribe public underlying_bribe;

    uint internal constant DURATION = 7 days; // rewards are released over the voting period
    uint internal constant MAX_REWARD_TOKENS = 16;

    mapping(address => mapping(uint => uint)) public tokenRewardsPerEpoch;
    mapping(address => uint) public periodFinish;
    mapping(address => uint) public lastUpdated;
    mapping(address => mapping(uint => uint)) public lastEarn;

    address[] public rewards;
    mapping(address => bool) public isReward;
    mapping(address => uint) public tokenRewardBalance;

    /// @notice A checkpoint for marking balance
    struct RewardCheckpoint {
        uint timestamp;
        uint balance;
    }

    event NotifyReward(address indexed from, address indexed reward, uint epoch, uint amount);
    event ClaimRewards(address indexed from, address indexed reward, uint amount);
    event HandleLeftOverRewards(address indexed reward, uint originalEpoch, uint updatedEpoch, uint amount);

    constructor(address _voter, address _old_bribe) {
        voter = _voter;
        _ve = IVoter(_voter)._ve();
        underlying_bribe = ExternalBribe(_old_bribe);

        for (uint i; i < underlying_bribe.rewardsListLength(); i++) {
            address underlying_reward = underlying_bribe.rewards(i);
            if (underlying_reward != address(0)) {
                isReward[underlying_reward] = true;
                rewards.push(underlying_reward);
            }
        }
    }

    // simple re-entrancy check
    uint internal _unlocked = 1;
    modifier lock() {
        require(_unlocked == 1);
        _unlocked = 2;
        _;
        _unlocked = 1;
    }

    function _bribeStart(uint timestamp) internal pure returns (uint) {
        return timestamp - (timestamp % (7 days));
    }

    function getEpochStart(uint timestamp) public pure returns (uint) {
        uint bribeStart = _bribeStart(timestamp);
        uint bribeEnd = bribeStart + DURATION;
        return timestamp < bribeEnd ? bribeStart : bribeStart + 7 days;
    }

    function rewardsListLength() external view returns (uint) {
        return rewards.length;
    }

    // returns the last time the reward was modified or periodFinish if the reward has ended
    function lastTimeRewardApplicable(address token) public view returns (uint) {
        return Math.min(block.timestamp, periodFinish[token]);
    }

    // allows a user to claim rewards for a given token
    function getReward(uint tokenId, address[] memory tokens) external lock  {
        require(IVotingEscrow(_ve).isApprovedOrOwner(msg.sender, tokenId));

        uint256 balanceBefore;

        for (uint i = 0; i < tokens.length; i++) {
            uint _reward = earned(tokens[i], tokenId);
            lastEarn[tokens[i]][tokenId] = block.timestamp;
            if (_reward > 0) {
                balanceBefore = IERC20(tokens[i]).balanceOf(address(this));
                _safeTransfer(tokens[i], msg.sender, _reward);
                tokenRewardBalance[tokens[i]] -= balanceBefore - IERC20(tokens[i]).balanceOf(address(this));
            }

            emit ClaimRewards(msg.sender, tokens[i], _reward);
        }
    }

    // used by Voter to allow batched reward claims
    function getRewardForOwner(uint tokenId, address[] memory tokens) external lock  {
        require(msg.sender == voter);
        address _owner = IVotingEscrow(_ve).ownerOf(tokenId);

        uint256 balanceBefore;

        for (uint i = 0; i < tokens.length; i++) {
            uint _reward = earned(tokens[i], tokenId);
            lastEarn[tokens[i]][tokenId] = block.timestamp;
            if (_reward > 0) {
                balanceBefore = IERC20(tokens[i]).balanceOf(address(this));
                _safeTransfer(tokens[i], _owner, _reward);
                tokenRewardBalance[tokens[i]] -= balanceBefore - IERC20(tokens[i]).balanceOf(address(this));
            }

            emit ClaimRewards(_owner, tokens[i], _reward);
        }
    }

    function earned(address token, uint tokenId) public view returns (uint) {
        if (underlying_bribe.numCheckpoints(tokenId) == 0) {
            return 0;
        }

        uint reward = 0;
        uint _ts = 0;
        uint _bal = 0;
        uint _supply = 1;
        uint _index = 0;
        uint _currTs = _bribeStart(lastEarn[token][tokenId]); // take epoch last claimed in as starting point

        _index = underlying_bribe.getPriorBalanceIndex(tokenId, _currTs);
        (_ts, _bal) = underlying_bribe.checkpoints(tokenId,_index);
        // accounts for case where lastEarn is before first checkpoint
        _currTs = Math.max(_currTs, _bribeStart(_ts)); 

        // get epochs between current epoch and first checkpoint in same epoch as last claim
        uint numEpochs = (_bribeStart(block.timestamp) - _currTs) / DURATION;

        if (numEpochs > 0) {
            for (uint256 i = 0; i < numEpochs; i++) {
                // get index of last checkpoint in this epoch
                _index = underlying_bribe.getPriorBalanceIndex(tokenId, _currTs + DURATION); 
                // get checkpoint in this epoch
                (_ts, _bal) = underlying_bribe.checkpoints(tokenId,_index);
                // get supply of last checkpoint in this epoch
                (, _supply) = underlying_bribe.supplyCheckpoints(underlying_bribe.getPriorSupplyIndex(_currTs + DURATION));
                if (_supply != 0) {
                    reward += _bal * tokenRewardsPerEpoch[token][_currTs] / _supply;
                }
                _currTs += DURATION;
            }
        }

        return reward;
    }

    function left(address token) external view returns (uint) {
        uint adjustedTstamp = getEpochStart(block.timestamp);
        return tokenRewardsPerEpoch[token][adjustedTstamp];
    }

    function notifyRewardAmount(address token, uint amount) external lock {
        require(amount > 0);
        if (!isReward[token]) {
          require(IVoter(voter).isWhitelisted(token), "bribe tokens must be whitelisted");
          require(rewards.length < MAX_REWARD_TOKENS, "too many rewards tokens");
        }
        // bribes kick in at the start of next bribe period
        uint adjustedTstamp = getEpochStart(block.timestamp);
        uint epochRewards = tokenRewardsPerEpoch[token][adjustedTstamp];

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        _safeTransferFrom(token, msg.sender, address(this), amount);
        uint256 balanceAfter = IERC20(token).balanceOf(address(this));

        amount = balanceAfter - balanceBefore;
        
        tokenRewardsPerEpoch[token][adjustedTstamp] = epochRewards + amount;
        tokenRewardBalance[token] += amount;

        periodFinish[token] = adjustedTstamp + DURATION;

        if (!isReward[token]) {
            isReward[token] = true;
            rewards.push(token);
        }

        emit NotifyReward(msg.sender, token, adjustedTstamp, amount);
    }

    function updateRewardAmount(address[] memory tokens) external lock {
        uint256 length = tokens.length;
        uint256 adjustedTstamp = getEpochStart(block.timestamp);

        uint256 rewardBalance;
        uint256 difference;

        for (uint256 i = 0; i < length;) {
            rewardBalance = tokenRewardBalance[tokens[i]];
            difference = IERC20(tokens[i]).balanceOf(address(this)) - rewardBalance;

            if (difference != 0) {
                tokenRewardsPerEpoch[tokens[i]][adjustedTstamp] += difference;
                tokenRewardBalance[tokens[i]] = rewardBalance + difference;

                periodFinish[tokens[i]] = adjustedTstamp + DURATION;
                lastUpdated[tokens[i]] = block.timetstamp;

                emit NotifyReward(msg.sender, tokens[i], adjustedTstamp, difference);
            }

            unchecked {
                ++i;
            }
        }
    }

    // This is an external function that can only be called by teams to handle unclaimed rewards due to zero vote
    function handleLeftOverRewards(uint epochTimestamp, address[] memory tokens) external {
        require(msg.sender == IVotingEscrow(_ve).team(), "only team");

        // require that supply of that epoch to be ZERO
        uint epochStart = getEpochStart(epochTimestamp);
        (uint _ts, uint _supply) = underlying_bribe.supplyCheckpoints(underlying_bribe.getPriorSupplyIndex(epochStart + DURATION));
        if (epochStart + DURATION > _bribeStart(_ts)) {
            require(_supply == 0, "this epoch has votes");
        }

        // do sth like notifyRewardAmount
        uint length = tokens.length;
        for (uint i = 0; i < length;) {
            // check bribe amount 
            uint previousEpochRewards = tokenRewardsPerEpoch[tokens[i]][epochStart];
            require(previousEpochRewards != 0, "no bribes for this epoch");

            // get timestamp of current epoch
            uint adjustedTstamp = getEpochStart(block.timestamp);

            // get notified reward of current epoch
            uint currentEpochRewards = tokenRewardsPerEpoch[tokens[i]][adjustedTstamp];

            // add previous unclaimed rewards to current epoch
            tokenRewardsPerEpoch[tokens[i]][adjustedTstamp] = currentEpochRewards + previousEpochRewards;

            // remove token rewards from previous epoch
            tokenRewardsPerEpoch[tokens[i]][epochStart] = 0;

            // amend period finish
            periodFinish[tokens[i]] = adjustedTstamp + DURATION;

            emit HandleLeftOverRewards(tokens[i], epochStart, adjustedTstamp, previousEpochRewards);

            unchecked {
                ++i;
            }
        }
    }

    function swapOutRewardToken(uint i, address oldToken, address newToken) external {
        require(msg.sender == IVotingEscrow(_ve).team(), 'only team');
        require(rewards[i] == oldToken);
        isReward[oldToken] = false;
        isReward[newToken] = true;
        rewards[i] = newToken;
    }

    function _safeTransfer(address token, address to, uint256 value) internal {
        require(token.code.length > 0);
        (bool success, bytes memory data) =
        token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }

    function _safeTransferFrom(address token, address from, address to, uint256 value) internal {
        require(token.code.length > 0);
        (bool success, bytes memory data) =
        token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }
}
