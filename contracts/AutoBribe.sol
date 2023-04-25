// SPDX-License-Identifier: MIT

import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Context.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import 'contracts/interfaces/ITurnstile.sol';
import {WrappedBribe} from 'contracts/WrappedBribe.sol';

pragma solidity 0.8.13;

// the purpose of this contract is to allow the projects to deposit bribes that will bribe their pools for a period of time
// they will need to know the appropriate wrappedExternalBribe contract address
// they will need to set up a public keeper, anyone can send the bribes
// bribes are divided evenly into the amount of weeks designated when they deposit
// each new deposit, will check for additional bribe tokens that may have been sent to the contract by accident
// each new deposit will make a bribe immediately!
// calling the bribe function is public and is rewarded with a share of the bribe token
// !!!!!!!!!!!this contract only handles a single bribe token, and a single bribe contract!!!!!!!!!

contract AutoBribe is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public constant TURNSTILE = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    address public immutable wBribe;

    address public project;
    uint256 public nextWeek;
    address[] public bribeTokens;
    mapping(address => bool) bribeTokensDeposited;
    mapping(address => uint256) bribeTokenToWeeksLeft;

    constructor(address _wBribe, address _team, uint256 _csrNftId) {
        wBribe = _wBribe;
        _transferOwnership(_team);
        ITurnstile(TURNSTILE).assign(_csrNftId);
    }

    //####USER FUNCTIONS#####

    function depositAll(
        address[] memory _bribeTokens,
        uint256 _weeks
    ) external {
        uint256 length = _bribeTokens.length;
        for (uint256 i = 0; i < length; ) {
            address bribeToken = _bribeTokens[i];
            deposit(
                bribeToken,
                IERC20(bribeToken).balanceOf(msg.sender),
                _weeks
            );
            unchecked {
                ++i;
            }
        }
    }

    function deposit(
        address _bribeToken,
        uint256 _amount,
        uint256 _weeks
    ) public {
        require(msg.sender == project, "only the project can bribe");
        require(_amount > 0, "Why are you depositing 0 tokens?");
        require(_weeks > 0, "You have to put at least 1 week");
        IERC20(_bribeToken).safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!bribeTokensDeposited[_bribeToken]) {
            bribeTokensDeposited[_bribeToken] = true;
            bribeTokens.push(_bribeToken);
        }
        bribeTokenToWeeksLeft[_bribeToken] = _weeks;
    }

    function bribe() public {
        uint256 length = bribeTokens.length;
        address _bribeToken;
        for (uint256 i = 0; i < length; ) {
            if (block.timestamp >= nextWeek) {
                _bribeToken = bribeTokens[i];
                uint256 weeksLeft = bribeTokenToWeeksLeft[_bribeToken];
                uint256 bribeAmount = balance(_bribeToken) / weeksLeft;
                uint256 gasReward = bribeAmount / 10000;
                IERC20(_bribeToken).safeTransferFrom(
                    address(this),
                    msg.sender,
                    gasReward
                );
                WrappedBribe(wBribe).notifyRewardAmount(_bribeToken, bribeAmount - gasReward);
                bribeTokenToWeeksLeft[_bribeToken] = weeksLeft - 1;
            }
            unchecked {
                ++i;
            }
        }

        nextWeek = nextWeek + 604800;
    }

    function balance(address _bribeToken) public view returns (uint) {
        return IERC20(_bribeToken).balanceOf(address(this));
    }

    //####Admin Functions#####
    function emptyOut() public {
        require(msg.sender == project);

        uint256 length = bribeTokens.length;
        uint256 amount;

        for (uint256 i = 0; i < length; ) {
            address bribeToken = bribeTokens[i];
            amount = balance(bribeToken);
            bribeTokensDeposited[bribeToken] = false;
            bribeTokenToWeeksLeft[bribeToken] = 0;
            IERC20(bribeToken).safeTransfer(msg.sender, amount);

            unchecked {
                ++i;
            }
        }
    }

    function setProject(address _newWallet) public {
        require(msg.sender == project || msg.sender == owner());
        project = _newWallet;
    }

    function inCaseTokensGetStuck(address _token) external onlyOwner {
        require(!bribeTokensDeposited[_token], "!bribeToken");
        uint256 amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(msg.sender, amount);
    }
}
