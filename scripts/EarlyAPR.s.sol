// SPDX-License-Identifier: MIT
//forge script scripts/EarlyAPR.s.sol:EarlyAPR --rpc-url https://canto.slingshot.finance	-vvv
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Gauge} from "../contracts/Gauge.sol";
import {Flow} from "../contracts/Flow.sol";
import {Voter} from "../contracts/Voter.sol";


contract EarlyAPR is Script { 
    address private constant FLOWWCANTO = 0x09b303fe939bec703a7c81087de0ECA0042b0339;
    address private constant D = 0x53f3B51FD7F327E1Ec4E6eAa3A049149cB2acaD2;
    address private constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;

    function run() external {
        uint256 govPrivateKey = vm.envUint("GOV_PRIVATE_KEY");
        vm.startBroadcast(govPrivateKey);

        Gauge gauge = Gauge(FLOWWCANTO);
        Flow flow = Flow(FLOW);
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);        

        uint256 bal = flow.balanceOf(D);
        console2.log (bal);

        bool white = voter.isWhitelisted(FLOW);
        console2.log (white);

        address voterAddy = gauge.voter();
        console2.log (voterAddy);

        flow.approve(FLOWWCANTO, 2**256-1);

        gauge.notifyRewardAmount(FLOW, bal);

        uint256 GBal = flow.balanceOf(FLOWWCANTO);
        console2.log(GBal);

        vm.stopBroadcast();
    }


}
