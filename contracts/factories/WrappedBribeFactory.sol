// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {WrappedBribe} from 'contracts/WrappedBribe.sol';
import 'contracts/interfaces/ITurnstile.sol';

contract WrappedBribeFactory {
    address public constant TURNSTILE = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    uint256 public immutable csrNftId;
    address public immutable voter;
    mapping(address => address) public oldBribeToNew;
    address public last_bribe;

    constructor(address _voter, uint256 _csrNftId) {
        voter = _voter;
        ITurnstile(TURNSTILE).assign(_csrNftId);
        csrNftId = _csrNftId;
    }

    function createBribe(address existing_bribe) external returns (address) {
        require(
            oldBribeToNew[existing_bribe] == address(0),
            "Wrapped bribe already created"
        );
        last_bribe = address(new WrappedBribe(voter, existing_bribe, csrNftId));
        oldBribeToNew[existing_bribe] = last_bribe;
        return last_bribe;
    }
}
