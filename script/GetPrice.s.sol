// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {IPair} from "../contracts/interfaces/IPair.sol";

address constant pairAddy = 0x44724F2A542D9b7653923D87F17712b113FEB448;
address constant sCANTO = 0x9F823D534954Fc119E31257b3dDBa0Db9E2Ff4ed;
address constant BLOTR = 0xFf0BAF077e8035A3dA0dD2abeCECFbd98d8E63bE;

contract GetPrice is Script {
    function run() external view {

        uint amtOut = IPair(pairAddy).getAmountOut(100000, BLOTR);
        uint [] memory amtsOut = IPair(pairAddy).prices(BLOTR, 100000, 4);
            uint amtsOut0 = amtsOut[0]; 
            uint amtsOut1 = amtsOut[1] ;
            uint amtsOut2 = amtsOut[2] ;
            uint amtsOut3 = amtsOut[3] ;

        console2.log("static amount of sCanto", amtOut);
        console2.log("TWAP0", amtsOut0);
        console2.log("TWAP1", amtsOut1);
        console2.log("TWAP2", amtsOut2);
        console2.log("TWAP3", amtsOut3);




    }
}


