// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AutoBribe} from 'contracts/AutoBribe.sol';
import {WrappedBribe} from 'contracts/WrappedBribe.sol';
import 'contracts/interfaces/ITurnstile.sol';

contract WrappedBribeFactory {
    address public constant TURNSTILE = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    uint256 public immutable csrNftId;
    address public immutable voter;
    address public immutable team;
    mapping(address => address) public oldBribeToNew;
    mapping(address => address) public oldBribeToAutoBribe;
    address public last_bribe;

    constructor(address _team, address _voter, uint256 _csrNftId) {
        team = _team;
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

    function createAutoBribe(address existing_bribe) external returns (address auto_bribe) {
        address wBribe = oldBribeToNew[existing_bribe];
        require(
            oldBribeToNew[existing_bribe] != address(0),
            "Wrapped bribe not yet created"
        );
        require(
            oldBribeToAutoBribe[existing_bribe] == address(0),
            "Auto bribe already created"
        );
        auto_bribe = address(new AutoBribe(wBribe, team, csrNftId));
        oldBribeToAutoBribe[existing_bribe] = auto_bribe;
    }
}
