// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "contracts/interfaces/IBribeFactory.sol";
import 'contracts/ExternalBribe.sol';
import 'contracts/interfaces/ITurnstile.sol';

contract BribeFactory is IBribeFactory {
    address public constant turnstile = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    address public last_external_bribe;
    uint256 public immutable csrNftId;

    constructor(uint256 _csrNftId) {
        ITurnstile(turnstile).assign(_csrNftId);
        csrNftId = _csrNftId;
    }

    function createExternalBribe(address[] memory allowedRewards) external returns (address) {
        last_external_bribe = address(new ExternalBribe(msg.sender, allowedRewards, csrNftId));
        return last_external_bribe;
    }
}
