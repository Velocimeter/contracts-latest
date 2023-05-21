// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";


contract KillGauge is Script { 
address constant public USDPlus = 0x42463F6c194047cfA6dAd84e31a4dF694856fbf9;
address constant public VoterAddy = 0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389;


    function run() external {
        uint256 govPrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(govPrivateKey);

        _isAlive(USDPlus) ;
        _killGauges(USDPlus);


        vm.stopBroadcast();
    }

    function _killGauges(address _gauge) private {
        Voter voter = Voter(VoterAddy);
        if (voter.isAlive(_gauge) == true){
            voter.killGauge(_gauge);
            }
    }

    function _isAlive(address _gauge) private view {
        Voter voter = Voter(VoterAddy);
          bool alive = voter.isAlive(_gauge);
          console2.log(_gauge, "is alive?", alive);
        }
}



