// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";




contract Distro is Script { 


    function run() external {
        uint256 PrivateKey = vm.envUint("ASSETEOA_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        voter.distribute();


        vm.stopBroadcast();
    }

}
