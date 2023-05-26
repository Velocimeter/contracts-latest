// SPDX-License-Identifier: MIT

//   forge script script/MintBulk.s.sol:MintBulk --rpc-url https://mainnode.plexnode.org:8545 -vvv --broadcast --slow

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {Flow} from "../contracts/Flow.sol";


address constant ser = 0xe5Fae1A033AD8cb1355E8F19811380AfD15B8bBa;
address constant pujimak = 0x3C2d6d7144241F1F1203c29C124585e55B58975E;


uint256 constant FOUR_YEARS = 126_144_000;
uint256 constant MINT_AMOUNT = 400_000 * 1e18;
uint256 constant TotalFLOW = 1_000_000 * 1e18;

contract MintBulk is Script {
    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
        Flow flow = Flow(0xB5b060055F0d1eF5174329913ef861bC3aDdF029);

        flow.approve(0x8E003242406FBa53619769F31606ef2Ed8A65C00, TotalFLOW);
    
        votingEscrow.create_lock_for(MINT_AMOUNT,FOUR_YEARS,pujimak);

        vm.stopBroadcast();
        }
    }


// 