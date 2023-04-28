// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";

import {Flow} from "../contracts/Flow.sol";
import {WrappedBribeFactory} from "../contracts/factories/WrappedBribeFactory.sol";

contract DeployWrappedBribeFactory is Script {
    // token addresses
    address private constant TEAM_MULTI_SIG =
        0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51;
    address private constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029; // TODO
    address private constant VOTER = 0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        uint256 csrNftId = Flow(FLOW).csrNftId();
        // Wrapped external bribe factory
        WrappedBribeFactory wrappedBribeFactory = new WrappedBribeFactory(
            TEAM_MULTI_SIG,
            VOTER,
            csrNftId
        );

        vm.stopBroadcast();
    }
}
