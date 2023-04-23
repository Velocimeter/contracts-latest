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

        uint256 nftA = 50;
        uint256 nftB = 71;
        uint256 nftC = 73;
        // uint256 nftD = 76;
        // uint256 nftE = 79;
        // uint256 nftF = 81;
        // uint256 nftG = 84;
        // uint256 nftH = 84;
        // uint256 nftI = 84;

        bool vA = votingEscrow.voted(nftA);
        bool vB = votingEscrow.voted(nftB);
        bool vC = votingEscrow.voted(nftC);
        // bool vD = votingEscrow.voted(nftD);
        // bool vE = votingEscrow.voted(nftE);
        // bool vF = votingEscrow.voted(nftF);
        // bool vG = votingEscrow.voted(nftG);
        // bool vH = votingEscrow.voted(nftH);
        // bool vI = votingEscrow.voted(nftI);

        uint amtA = votingEscrow.balanceOfNFT(nftA)/ 1e18;
        uint amtB = votingEscrow.balanceOfNFT(nftB)/ 1e18;
        uint amtC = votingEscrow.balanceOfNFT(nftC)/ 1e18;
        // uint amtD = votingEscrow.balanceOfNFT(nftD);
        // uint amtE = votingEscrow.balanceOfNFT(nftE);
        // uint amtF = votingEscrow.balanceOfNFT(nftF);
        // uint amtG = votingEscrow.balanceOfNFT(nftG);


        console2.log("tkn", nftA, vA);
        console2.log('locked amount', amtA);
        console2.log("tkn", nftB, vB);
        console2.log('locked amount', amtB);
        console2.log("tkn", nftC, vC);
        console2.log('locked amount', amtC);
        // console2.log("tkn", nftC, vC);
        // console2.log("tkn", nftD, vD);
        // console2.log("tkn", nftE, vE);
        // console2.log("tkn", nftF, vF);
        // console2.log("tkn", nftG, vG);
        // console2.log("tkn", nftH, vH);
        // console2.log("tkn", nftI, vI);

    

        }
    }

// 