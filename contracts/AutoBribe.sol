// SPDX-License-Identifier: MIT

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Context.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "contracts/interfaces/ITurnstile.sol";
import "contracts/interfaces/IERC20.sol";
import "contracts/WrappedBribe.sol";

pragma solidity 0.8.13;

// the purpose of this contract is to allow the projects to deposit bribes that will bribe their pools for a period of time
// they will need to set up a public keeper, anyone can send the bribes
// bribes are divided evenly into the amount of weeks designated when they deposit
// each new deposit will NOT make a bribe immediately!
// calling the bribe function is public and is rewarded with a share of the bribe token
// !!!!!!!!!!!this contract handles multiple bribe tokens, and a single bribe contract!!!!!!!!!

contract AutoBribe is Ownable {
    address public constant TURNSTILE =
        0xEcf044C5B4b867CFda001101c617eCd347095B44;
    address public immutable wBribe;

    address public project;
    bool public depositSealed;
    bool public initialized;
    uint256 public nextWeek;
    address[] public bribeTokens;
    mapping(address => bool) public bribeTokensDeposited;
    mapping(address => uint256) public bribeTokenToWeeksLeft;

    event Deposited(
        address indexed _bribeToken,
        uint256 _amount,
        uint256 _weeks
    );
    event Bribed(uint256 indexed _timestamp, address _briber);
    event EmptiedOut(uint256 indexed _timestamp, address project);
    event Sealed(uint256 indexed _timestamp);
    event UnSealed(uint256 indexed _timestamp);

    constructor(address _wBribe, address _team, uint256 _csrNftId) {
        wBribe = _wBribe;
        nextWeek = block.timestamp;
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
        _safeTransferFrom(_bribeToken, msg.sender, address(this), _amount);
        uint256 allowance = IERC20(_bribeToken).allowance(
            address(this),
            wBribe
        );
        _safeApprove(_bribeToken, wBribe, allowance + _amount);
        if (!bribeTokensDeposited[_bribeToken]) {
            bribeTokensDeposited[_bribeToken] = true;
            bribeTokens.push(_bribeToken);
        }
        bribeTokenToWeeksLeft[_bribeToken] += _weeks;

        emit Deposited(_bribeToken, _amount, _weeks);
    }

    function bribe() public {
        require(block.timestamp >= nextWeek, "already bribed this week");
        uint256 length = bribeTokens.length;
        address _bribeToken;
        for (uint256 i = 0; i < length; ) {
            _bribeToken = bribeTokens[i];
            uint256 weeksLeft = bribeTokenToWeeksLeft[_bribeToken];
            uint256 bribeAmount = balance(_bribeToken) / weeksLeft;
            uint256 gasReward = bribeAmount / 200;
            _safeTransfer(_bribeToken, msg.sender, gasReward);
            WrappedBribe(wBribe).notifyRewardAmount(
                _bribeToken,
                bribeAmount - gasReward
            );
            bribeTokenToWeeksLeft[_bribeToken] = weeksLeft - 1;
            unchecked {
                ++i;
            }
        }
        nextWeek = nextWeek + 604800;
        emit Bribed(nextWeek, msg.sender);
    }

    function balance(address _bribeToken) public view returns (uint) {
        return IERC20(_bribeToken).balanceOf(address(this));
    }

    //####Admin Functions#####
    function emptyOut() public {
        require(msg.sender == project, "only project can empty out");
        require(!depositSealed, "deposit is sealed");
        uint256 length = bribeTokens.length;
        uint256 amount;

        for (uint256 i = 0; i < length; ) {
            address bribeToken = bribeTokens[i];
            amount = balance(bribeToken);
            bribeTokenToWeeksLeft[bribeToken] = 0;
            _safeTransfer(bribeToken, msg.sender, amount);

            unchecked {
                ++i;
            }
        }

        emit EmptiedOut(block.timestamp, project);
    }

    //Allows project to seal the vault making it not possible for them to withdraw their tokens
    function seal() public {
        require(msg.sender == project, "only project can seal");
        depositSealed = true;

        emit Sealed(block.timestamp);
    }

    //Allows Velocimeter to re allow project to withdraw their tokens
    function unSeal() public onlyOwner {
        depositSealed = false;

        emit UnSealed(block.timestamp);
    }

    function setProject(address _newWallet) public {
        require(
            msg.sender == project || (msg.sender == owner() && !initialized),
            "only project / team can only set once"
        );
        if (!initialized) {
            initialized = true;
        }
        project = _newWallet;
    }

    function inCaseTokensGetStuck(address _token) external onlyOwner {
        require(!bribeTokensDeposited[_token], "!bribeToken");
        uint256 amount = IERC20(_token).balanceOf(address(this));
        _safeTransfer(_token, msg.sender, amount);
    }

    function _safeTransfer(address token, address to, uint256 value) internal {
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

    function _safeApprove(address token, address spender, uint value) internal {
        require(token.code.length > 0);
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.approve.selector, spender, value)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }
}
