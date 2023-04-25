// SPDX-License-Identifier: MIT


// forge script scripts/CRE8R.s.sol:CRE8R --rpc-url https://canto.slingshot.finance	  -vvv --broadcast

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {Pair} from "../contracts/Pair.sol";
import {IPair} from "../contracts/interfaces/IPair.sol";
import {IBribe} from "../contracts/interfaces/IBribe.sol";
import {IERC20} from 'contracts/interfaces/IERC20.sol';

import {WrappedExternalBribe} from "../contracts/WrappedExternalBribe.sol";
import {Voter} from "../contracts/Voter.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {Gauge} from "../contracts/Gauge.sol";
import {IGauge} from "../contracts/interfaces/IGauge.sol";
import {Flow} from "../contracts/Flow.sol";


address constant flowAddy = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant hotwallet = 0xA67D2c03c3cfe6177a60cAed0a4cfDA7C7a563e0;
address constant cre8rGauge = 0x187ed9851D7ADB5798D9A8e8FF40005d23D68682;
address constant stETHGauge = 0x85ff8B9AD71B667EF44E3A7D1aBeC3fE55d30831;
uint256 constant tknID = 83;


contract CRE8R is Script {
      uint256[] ONEHUNDRED = [10000];
      address[] private cre8rPair = [0x237F9c6d2BBeAcc91049710ac47e3eAc83cDC55c];
      VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
      Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
      Flow flow = Flow(flowAddy);
      address[] private toVote = [flowAddy];
      address[] private rewards = [flowAddy];

    function run() external {
        uint256 govPrivateKey = vm.envUint("CRE8R_PRIVATE_KEY");
        vm.startBroadcast(govPrivateKey);

        getRewards();
        getRebase();
        increaseLock();
        increaseTime();
        vote();

        vm.stopBroadcast();

        }       

    function getRewards() private {        
        IGauge(cre8rGauge).getReward(hotwallet, rewards);
        IGauge(stETHGauge).getReward(hotwallet, rewards);
    }
    function getRebase() private {
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);
        uint256 claimable = rewardsDistributor.claimable(tknID);
        if (claimable > 50000 * 1e18){
          rewardsDistributor.claim(tknID);
        }
    }
    function increaseLock() private{
      uint256 flowBalance = flow.balanceOf(hotwallet);
      votingEscrow.increase_amount(tknID, flowBalance);
    }
    function increaseTime() private {
      votingEscrow.increase_unlock_time(tknID, 126272312);
    }
    function vote() private {
      voter.vote(tknID, cre8rPair, ONEHUNDRED);
    }


}





