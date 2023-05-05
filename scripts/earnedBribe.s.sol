// SPDX-License-Identifier: MIT
//  forge script scripts/earnedBribe.s.sol:earnedBribe --rpc-url https://mainnode.plexnode.org:8545 -vvv
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {WrappedExternalBribe} from "../contracts/WrappedExternalBribe.sol";
import {Voter} from "../contracts/Voter.sol";
import {Pair} from "../contracts/Pair.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


//Token addresses
address constant flow = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant wCanto = 0x826551890Dc65655a0Aceca109aB11AbDbD7a07B;

address constant note = 0x4e71A2E537B7f9D9413D3991D37958c0b5e1e503;
address constant busd = 0x381Ea7A7EE6a1e2982e01E7b6837f775a1a4B07F;
address constant usdt = 0xd567B3d7B8FE3C79a1AD8dA978812cfC4Fa05e75;

address constant bnb = 0xFb7F77faaA3b69ef4C15d6305C79AD92B387C89F;
address constant cre8r = 0xc9BAA8cfdDe8E328787E29b4B078abf2DaDc2055;
address constant eth = 0x5FD55A1B9FC24967C4dB09C513C3BA0DFa7FF687;
address constant multiBTC = 0x80A16016cC4A2E6a2CACA8a4a498b1699fF0f844;
address constant wBTC = 0x08638a74A8134c747Dce29B57472cc2B57F35653;
address constant somm = 0xFA3C22C069B9556A4B2f7EcE1Ee3B467909f4864;
address constant yfx = 0x8901cB2e82CC95c01e42206F8d1F417FE53e7Af0;
address constant cbonk = 0x38D11B40D2173009aDB245b869e90525950aE345;
address constant stAtom = 0x4A2a90D444DbB7163B5861b772f882BbA394Ca67;


// wExBribe addresses
address constant multiBTC_wCanto = 0xcC7d2390e8014e94120088778E5D17AF865C3856;
address constant multiBTC_USDT = 0x83e43617590f9e5Be2905Acce16ACC413dcBA2eb;
address constant note_wCanto = 0x1c3b3E7E7E05B4Da3Be1C0bEe5b773b1Bb35abf1;
address constant wCanto_bnb = 0xfb7502e28815E7Ad0f6f7f12DB7c65cF5312483c;
address constant wBTC_multiBTC = 0x2786D43eA95c004beFec476404b36e25d4f8329f;
address constant wCanto_Flow = 0x1aF8bAD14e87798f6B7D1f2a928Dcf650b1E2827;
address constant busd_note = 0x34bb935a50CfDD2F9AcF9fE0Ed71275e05E41314;
address constant wCanto_somm = 0x90Cd1d0F111c688C5FE89e7f3F8216F13f7Bbb3E;
address constant cre8r_eth = 0xf81568C88b8dCD42764c31437f918eBBB705F067;
address constant flow_somm = 0x7d82cf9EA31cF0B96b9a38671D3aE90076A9f5E0;
address constant note_yfx = 0x5b2DB4398f579c53Ca04d1430DDC5f58100ae49d;
address constant cBonk_wCanto = 0x02BbB7a476f186a0f46cF12eb43E0a5D40294c5e;
address constant stAtom_wCanto = 0xAAcaB82657C7f10d66aE4E66CC86FA5fB3Dce9eb;
address constant stAtom_wCanto2 = 0xddbdF41d909dFeF25414A424F6d70e6cFdF0d8b0;



contract earnedBribe is Script { 
      address private wBribe = stAtom_wCanto;
      address private tkn1 = stAtom;
      address private tkn2 = wCanto;
      uint256 private nftID = 76;


    function run() external view {

        WrappedExternalBribe wExBribe = WrappedExternalBribe(wBribe);
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        // address pool = voter.poolVote(nftID, 0);
        // Pair pair = Pair(pool);
        // string memory pairSymbol = pair.symbol();        
        // console2.log(pairSymbol);

        
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




    }



}


// note    520
// wcanto  1220+530+33
// wbtc 0.00389324
// somm 307