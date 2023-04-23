// SPDX-License-Identifier: MIT
//  forge script scripts/earnedBribe.s.sol:earnedBribe --rpc-url https://mainnode.plexnode.org:8545 -vvv
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {WrappedExternalBribe} from "../contracts/WrappedExternalBribe.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


//Token addresses
address constant flow = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant wCanto = 0x826551890Dc65655a0Aceca109aB11AbDbD7a07B;
address constant note = 0x4e71A2E537B7f9D9413D3991D37958c0b5e1e503;
address constant multiBTC = 0x80A16016cC4A2E6a2CACA8a4a498b1699fF0f844;
address constant bnb = 0xFb7F77faaA3b69ef4C15d6305C79AD92B387C89F;


// wExBribe addresses
address constant wCanto_MultiBTC_exBribe = 0xcC7d2390e8014e94120088778E5D17AF865C3856;
address constant note_wCanto_exBribe = 0x1c3b3E7E7E05B4Da3Be1C0bEe5b773b1Bb35abf1;
address constant bnb_wCant0_exBribe = 0xfb7502e28815E7Ad0f6f7f12DB7c65cF5312483c;


contract earnedBribe is Script { 
      address private wBribe = bnb_wCant0_exBribe;
      address private tkn1 = bnb;
      address private tkn2 = wCanto;
      uint256 private nftID = 4;


    function run() external {
        uint256 PrivateKey = vm.envUint("ASSETEOA_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);
        WrappedExternalBribe wExBribe = WrappedExternalBribe(wBribe);
        
        uint balTkn1 = IERC20(tkn1).balanceOf(wBribe);
        uint balTkn2 = IERC20(tkn2).balanceOf(wBribe);
        uint balFlow = IERC20(flow).balanceOf(wBribe);       
        uint earnedAmt1 = wExBribe.earned(tkn1, nftID);
        uint earnedAmt2 = wExBribe.earned(tkn2, nftID);
        uint earnedFlow = wExBribe.earned(flow, nftID);

        console2.log('tkn1 balance', balTkn1);
        console2.log('tkn1 earned', earnedAmt1);
        console2.log('tkn2 balance', balTkn2);
        console2.log('tkn2 earned', earnedAmt2);
        console2.log('flow balance', balFlow);
        console2.log('flow earned', earnedFlow);

        if(balTkn1 < earnedAmt1){
            uint need1 = earnedAmt1 - balTkn1;
            console2.log("send", need1, "token1");
        }
        if(balTkn2 < earnedAmt2){
            uint need2 = earnedAmt2 - balTkn2;
            console2.log("send", need2, "token2");
        }
        if(balFlow < earnedFlow){
            uint needFlow = earnedFlow - balFlow;
            console2.log("send", needFlow, "Flow tokens");
        }



        vm.stopBroadcast();
    }

}


// note    400
// wcanto  1220
