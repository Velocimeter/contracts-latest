// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/utils/math/Math.sol";
import "contracts/ExternalBribe.sol";
import "contracts/interfaces/IERC20.sol";
import "contracts/interfaces/IGauge.sol";
import "contracts/interfaces/IVoter.sol";
import "contracts/interfaces/IVotingEscrow.sol";

// Bribes pay out rewards for a given pool based on the votes that were received from the user (goes hand in hand with Voter.vote())
contract WrappedExternalBribe {
    address public immutable voter;
    address public immutable _ve;
    ExternalBribe public underlying_bribe;

    uint256 internal constant DURATION = 7 days; // rewards are released over the voting period
    uint256 internal constant MAX_REWARD_TOKENS = 16;

    uint256 internal constant PRECISION = 10**18;

    mapping(address => mapping(uint256 => uint256)) public tokenRewardsPerEpoch;
    mapping(address => uint256) public periodFinish;
    mapping(address => mapping(uint256 => uint256)) public lastEarn;

    address[] public rewards;
    mapping(address => bool) public isReward;

    /// @notice A checkpoint for marking balance
    struct RewardCheckpoint {
        uint256 timestamp;
        uint256 balance;
    }

    event NotifyReward(
        address indexed from,
        address indexed reward,
        uint256 epoch,
        uint256 amount
    );
    event ClaimRewards(
        address indexed from,
        address indexed reward,
        uint256 amount
    );

    constructor(address _voter, address _old_bribe) {
        voter = _voter;
        _ve = IVoter(_voter)._ve();
        underlying_bribe = ExternalBribe(_old_bribe);

        for (uint256 i; i < underlying_bribe.rewardsListLength(); i++) {
            address underlying_reward = underlying_bribe.rewards(i);
            if (underlying_reward != address(0)) {
                isReward[underlying_reward] = true;
                rewards.push(underlying_reward);
            }
        }
    }

    // simple re-entrancy check
    uint256 internal _unlocked = 1;
    modifier lock() {
        require(_unlocked == 1);
        _unlocked = 2;
        _;
        _unlocked = 1;
    }

    function _bribeStart(uint256 timestamp) internal pure returns (uint256) {
        return timestamp - (timestamp % (7 days));
    }

    function getEpochStart(uint256 timestamp) public pure returns (uint256) {
        uint256 bribeStart = _bribeStart(timestamp);
        uint256 bribeEnd = bribeStart + DURATION;
        return timestamp < bribeEnd ? bribeStart : bribeStart + 7 days;
    }

    function rewardsListLength() external view returns (uint256) {
        return rewards.length;
    }

    // returns the last time the reward was modified or periodFinish if the reward has ended
    function lastTimeRewardApplicable(address token)
        public
        view
        returns (uint256)
    {
        return Math.min(block.timestamp, periodFinish[token]);
    }

    // allows a user to claim rewards for a given token
    function getReward(uint256 tokenId, address[] memory tokens) external lock {
        require(IVotingEscrow(_ve).isApprovedOrOwner(msg.sender, tokenId));
        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 _reward = earned(tokens[i], tokenId);
            lastEarn[tokens[i]][tokenId] = block.timestamp;
            if (_reward > 0) _safeTransfer(tokens[i], msg.sender, _reward);

            emit ClaimRewards(msg.sender, tokens[i], _reward);
        }
    }

    // used by Voter to allow batched reward claims
    function getRewardForOwner(uint256 tokenId, address[] memory tokens)
        external
        lock
    {
        require(msg.sender == voter);
        address _owner = IVotingEscrow(_ve).ownerOf(tokenId);
        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 _reward = earned(tokens[i], tokenId);
            lastEarn[tokens[i]][tokenId] = block.timestamp;
            if (_reward > 0) _safeTransfer(tokens[i], _owner, _reward);

            emit ClaimRewards(_owner, tokens[i], _reward);
        }
    }

    function earned(address token, uint256 tokenId)
        public
        view
        returns (uint256)
    {
        uint256 _startTimestamp = lastEarn[token][tokenId];
        if (underlying_bribe.numCheckpoints(tokenId) == 0) {
            return 0;
        }

        uint256 _startIndex = underlying_bribe.getPriorBalanceIndex(
            tokenId,
            _startTimestamp
        );
        uint256 _endIndex = underlying_bribe.numCheckpoints(tokenId) - 1;

        uint256 reward = 0;
        // you only earn once per epoch (after it's over)
        RewardCheckpoint memory prevRewards;
        prevRewards.timestamp = _bribeStart(_startTimestamp);
        uint256 _prevTs = 0;
        uint256 _prevBal = 0;
        uint256 _prevSupply = 1;

        if (_endIndex > 0) {
            for (uint256 i = _startIndex; i <= _endIndex - 1; i++) {
                (_prevTs, _prevBal) = underlying_bribe.checkpoints(tokenId, i);
                uint256 _nextEpochStart = _bribeStart(_prevTs);
                // check that you've earned it
                // this won't happen until a week has passed
                if (_nextEpochStart > prevRewards.timestamp) {
                    reward += prevRewards.balance;
                }

                prevRewards.timestamp = _nextEpochStart;
                (, _prevSupply) = underlying_bribe.supplyCheckpoints(
                    underlying_bribe.getPriorSupplyIndex(
                        _nextEpochStart + DURATION
                    )
                );
                prevRewards.balance =
                    (_prevBal * tokenRewardsPerEpoch[token][_nextEpochStart]) /
                    _prevSupply;
            }
        }

        (_prevTs, _prevBal) = underlying_bribe.checkpoints(tokenId, _endIndex);
        uint256 _lastEpochStart = _bribeStart(_prevTs);
        uint256 _lastEpochEnd = _lastEpochStart + DURATION;

        if (
            block.timestamp > _lastEpochEnd && _startTimestamp < _lastEpochEnd
        ) {
            (, _prevSupply) = underlying_bribe.supplyCheckpoints(
                underlying_bribe.getPriorSupplyIndex(_lastEpochEnd)
            );
            reward +=
                (_prevBal * tokenRewardsPerEpoch[token][_lastEpochStart]) /
                _prevSupply;
        }

        return reward;
    }

    function left(address token) external view returns (uint256) {
        uint256 adjustedTstamp = getEpochStart(block.timestamp);
        return tokenRewardsPerEpoch[token][adjustedTstamp];
    }

    function notifyRewardAmount(address token, uint256 amount) external lock {
        require(amount > 0);
        if (!isReward[token]) {
            require(
                IVoter(voter).isWhitelisted(token),
                "bribe tokens must be whitelisted"
            );
            require(
                rewards.length < MAX_REWARD_TOKENS,
                "too many rewards tokens"
            );
        }
        // bribes kick in at the start of next bribe period
        uint256 adjustedTstamp = getEpochStart(block.timestamp);
        uint256 epochRewards = tokenRewardsPerEpoch[token][adjustedTstamp];

        _safeTransferFrom(token, msg.sender, address(this), amount);
        tokenRewardsPerEpoch[token][adjustedTstamp] = epochRewards + amount;

        periodFinish[token] = adjustedTstamp + DURATION;

        if (!isReward[token]) {
            isReward[token] = true;
            rewards.push(token);
        }

        emit NotifyReward(msg.sender, token, adjustedTstamp, amount);
    }

    function swapOutRewardToken(
        uint256 i,
        address oldToken,
        address newToken
    ) external {
        require(msg.sender == IVotingEscrow(_ve).team(), "only team");
        require(rewards[i] == oldToken);
        isReward[oldToken] = false;
        isReward[newToken] = true;
        rewards[i] = newToken;
    }

    function _safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        require(token.code.length > 0);
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, value)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }

    function _safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        require(token.code.length > 0);
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(
                IERC20.transferFrom.selector,
                from,
                to,
                value
            )
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }
}
