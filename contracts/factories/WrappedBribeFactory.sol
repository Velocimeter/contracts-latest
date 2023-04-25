// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AutoBribe} from 'contracts/AutoBribe.sol';
import {WrappedBribe} from 'contracts/WrappedBribe.sol';

contract WrappedBribeFactory {
    address public immutable team;
    address public voter;
    mapping(address => address) public oldBribeToNew;
    mapping(address => address) public oldBribeToAutoBribe;
    address public last_bribe;

    event VoterSet(address indexed setter, address indexed voter);

    constructor(address _team) {
        team = _team;
    }

    function createBribe(address existing_bribe) external returns (address) {
        require(
            oldBribeToNew[existing_bribe] == address(0),
            "Wrapped bribe already created"
        );
        last_bribe = address(new WrappedBribe(voter, existing_bribe));
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
        auto_bribe = address(new AutoBribe(wBribe, team));
        oldBribeToAutoBribe[existing_bribe] = auto_bribe;
    }

    function setVoter(address _voter) external {
        require(voter == address(0), "Already initialized");
        voter = _voter;
        emit VoterSet(msg.sender, _voter);
    }
}
