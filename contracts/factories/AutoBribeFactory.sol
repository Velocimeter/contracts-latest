// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AutoBribe} from "contracts/AutoBribe.sol";

contract AutoBribeFactory {
    address public immutable team;
    address public immutable wBribeFactory;

    constructor(address _team, address _wBribeFactory) {
        team = _team;
        wBribeFactory = _wBribeFactory;
    }

    function createAutoBribe(
        address wbribe
    ) external returns (address auto_bribe) {
        require(wbribe != address(0), "Wrapped bribe not yet created");
        auto_bribe = address(new AutoBribe(wbribe, team));
    }
}
