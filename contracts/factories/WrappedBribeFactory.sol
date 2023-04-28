// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {WrappedBribe} from 'contracts/WrappedBribe.sol';

contract WrappedBribeFactory {
    address public immutable team;
    address public voter;
    mapping(address => address) public oldBribeToNew;
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

    function setVoter(address _voter) external {
        require(voter == address(0), "Already initialized");
        voter = _voter;
        emit VoterSet(msg.sender, _voter);
    }
}
