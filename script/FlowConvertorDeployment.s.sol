// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";
import {IFlow} from "../contracts/interfaces/IFlow.sol";
import {FlowConvertor} from "../contracts/FlowConvertor.sol";

contract FlowConvertorDeployment is Script {
    address private constant TEAM_MULTI_SIG = 0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51;
    // TODO: Fill the address
    address private constant FLOW = 0x78e489523291581205Ea3fA16a69689EcA79757A;
    uint256 private constant FIFTY_MILLION = 50e24; // 50e24 == 50e6 (50m) ** 1e18 (decimals)

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        FlowConvertor flowConvertor = new FlowConvertor({_v1: 0x2Baec546a92cA3469f71b7A091f7dF61e5569889, _v2: FLOW});

        flowConvertor.transferOwnership(TEAM_MULTI_SIG);

        IFlow(FLOW).transfer(address(flowConvertor), FIFTY_MILLION);

        vm.stopBroadcast();
    }
}
