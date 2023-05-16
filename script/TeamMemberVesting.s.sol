// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";

import {FlowVestor} from "../contracts/FlowVestor.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract TeamMemberVesting is Script {
    address private constant TEAM_MULTI_SIG = 0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51;
    // TODO: reset DEPLOYER_EOA
    address private constant DEPLOYER_EOA = 0xD93142ED5B85FcA4550153088750005759CE8318;
    // team member addresses
    address private constant T0RB1K = 0x0b776552c1Aef1Dc33005DD25AcDA22493b6615d;
    address private constant MOTTO = 0x78e801136F77805239A7F533521A7a5570F572C8;
    address private constant COOLIE = 0x03B88DacB7c21B54cEfEcC297D981E5b721A9dF1;

    // TODO: Fill the address
    address private constant FLOW = 0x78e489523291581205Ea3fA16a69689EcA79757A;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        FlowVestor flowVestor = new FlowVestor(FLOW);

        IERC20(FLOW).approve(address(flowVestor), 4_500_000e18);
        flowVestor.vestFor(T0RB1K, 2_000_000e18);
        flowVestor.vestFor(MOTTO, 2_000_000e18);
        flowVestor.vestFor(COOLIE, 500_000e18);

        flowVestor.transferOwnership(TEAM_MULTI_SIG);

        uint256 looseTokens = IERC20(FLOW).balanceOf(DEPLOYER_EOA);
        IERC20(FLOW).transfer(TEAM_MULTI_SIG, looseTokens);

        vm.stopBroadcast();
    }
}
