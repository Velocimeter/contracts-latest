// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";


contract KillGauges is Script { 
address constant sAMM_cINU_WCANTO	 = 0xA56ff60766b8DC6B6a005512EA83866BF67b964B;
address constant sAMM_FLOW_USDT	 = 0xAa4D0616d4F15DA210d64E52a92e1e16b05c5e13;
address constant vAMM_NOTE_USDC	 = 0x771665Ec0b9C4F0F4660C5d222800853cD3dD856;
address constant vAMM_USDC_USDT	 = 0xd1528570CA004B7A9BDbb07804d10d91e2E30Ec7;


    function run() external {
        uint256 govPrivateKey = vm.envUint("GOV_PRIVATE_KEY");
        vm.startBroadcast(govPrivateKey);

_isAlive(sAMM_cINU_WCANTO	) ;
_isAlive(sAMM_FLOW_USDT	) ;
_isAlive(vAMM_NOTE_USDC	) ;
_isAlive(vAMM_USDC_USDT	) ;


        vm.stopBroadcast();
    }

    function _killGauges(address _gauge) private {
        Voter voter = Voter(0xC5B58aE761a77fF16d548dE9b42933c8FBfe4c33);
        if (voter.isAlive(_gauge) == true){
            voter.killGauge(_gauge);
            }
    }

    function _isAlive(address _gauge) private view {
        Voter voter = Voter(0xC5B58aE761a77fF16d548dE9b42933c8FBfe4c33);
          bool alive = voter.isAlive(_gauge);
          console2.log(_gauge, "is alive?", alive);
        }
}



