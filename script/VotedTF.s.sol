// SPDX-License-Identifier: MIT

// forge script scripts/VotedTF.s.sol:VotedTF --rpc-url https://mainnode.plexnode.org:8545 -vvv
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";



contract VotedTF is Script {
    function run() external view {
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        uint256 nftA = 905;


        bool vA = votingEscrow.voted(nftA);
        uint amtA = votingEscrow.balanceOfNFT(nftA)/ 1e18;
        address owner = votingEscrow.ownerOf(nftA);


        console2.log("tkn", nftA, vA);
        console2.log("owner", owner);
        console2.log('locked amount', amtA);


    

        }
    }

// 