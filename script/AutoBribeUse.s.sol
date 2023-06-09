// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IFlow} from "contracts/interfaces/IFlow.sol";
import {IAutoBribe} from "contracts/interfaces/IAutoBribe.sol";
import {AutoBribe} from "contracts/AutoBribe.sol";
import {IERC20} from "contracts/interfaces/IERC20.sol";
import "forge-std/console2.sol";


contract AutoBribeUse is Script {
    // POVP Autobribes
    address private constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
    address private constant BLOTR = 0xFf0BAF077e8035A3dA0dD2abeCECFbd98d8E63bE;
    address private constant oBLOTR = 0x9f9A1Aa08910867F38359F4287865c4A1162C202;

    address private constant underFlow_Flow_Autobribe = 0xd855dbBB8ca20B6dF9459EEA613D7645c8F8ad93;
    address private constant sCANTO_wCANTO_Autobribe_FLOW = 0xb53350884016E9b398F9F43c4B1C62d87D809DA7;
    address private constant sCANTO_FLOW_Autobribe_FLOW = 0x01790Da7Df49e620694ff2f10382C01D6ef33179;

    // 3rd Party Projects
    address private constant Eth_Cre8r_Test = 0x0CD1b0fAB074727D7504c9Dc23f131598cFE5427;
    // not on FE yet
    address private constant Cizza_wCanto_Autobribe = 0x8dCf1a8086e700eAB31936af234b2D1212F257dB; //likely ignored
    address private constant agg_wcanto_autoBribe = 0x27f5C96dC4fE8E4538E838BaE762B5d168BbE46b;
    address private constant agg_sCanto_autoBirbe = 0xF435B0d94663E25605eD26Eb067070eF362cf8c9;

    //sCanto MSIG Autobribes
    address private constant sCANTO_FLOW_Autobribe = 0x7C57707fd607132128EEEFa93a087659EdD5BbE3;
    address private constant sCANTO_wCANTO_Autobribe = 0x99a564Cb07A31A08Be98670f63DBc5554f0Ee7fE;
    address private constant sCANTO_BLOTR_Autobribe = 0xfA3Be1bBEe6A2c30FcB790c3F53094f57AE2F104;

    //Voter
    address private constant POVP = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;


    
    

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("VOTE_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // SET THESE TO RUN THE FLOW BRIBES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        address[] memory autoBribes = new address[](3);

            autoBribes[0] = sCANTO_wCANTO_Autobribe_FLOW;
            autoBribes[1] = sCANTO_FLOW_Autobribe_FLOW;
            autoBribes[2] = underFlow_Flow_Autobribe;


        
        // emptyOutAll(autoBribes);
        // emptyOutSome(3, autoBribes);

        depositFlowBribes(autoBribes);
        depositoBlotr(autoBribes);        
        reClockAll(autoBribes);
        bribe(autoBribes);


        vm.stopBroadcast();
    }

    function emptyOutSome(uint _length, address[] memory _autoBribes) private {
            uint256 length = _length;

            for (uint256 i = 0; i < length;) {
                address autoBribeNow = _autoBribes[i];

                uint256 balanceBefore = IAutoBribe(autoBribeNow).balance(FLOW);
                console2.log("balanceBefore", balanceBefore);
                IAutoBribe(_autoBribes[i]).emptyOut();
                uint256 balance = IAutoBribe(autoBribeNow).balance(FLOW);
                console2.log("balance", balance);

                ++i;
            }
    }
    function emptyOutAll(address[] memory _autoBribes) private {
            uint256 length = _autoBribes.length;

            for (uint256 i = 0; i < length;) {
                address autoBribeNow = _autoBribes[i];

                uint256 balanceBefore = IAutoBribe(autoBribeNow).balance(FLOW);
                console2.log("balanceBefore", balanceBefore);
                IAutoBribe(_autoBribes[i]).emptyOut();
                uint256 balance = IAutoBribe(autoBribeNow).balance(FLOW);
                console2.log("balance", balance);

                ++i;
            }
    }

    function depositFlowBribes(address[] memory _autoBribes) private {
            uint256 length = _autoBribes.length;
            uint256 flowBal = IERC20(FLOW).balanceOf(POVP);
            if(flowBal >= 300_000 * 1e18) {
                uint256 split = flowBal / 3;   
                uint256 _weeks = 4;           

                for (uint256 i = 0; i < length;) {
                    address autoBribeNow = _autoBribes[i];
                    IFlow(FLOW).approve(autoBribeNow, split);            
                    IAutoBribe(autoBribeNow).deposit(FLOW, split, _weeks);

                    ++i;

                }
            }
    }
    function depositoBlotr(address[] memory _autoBribes) private {
        uint256 length = _autoBribes.length;
        uint256 balBlotr = IERC20(oBLOTR).balanceOf(POVP);
        if(balBlotr >=120_000 * 1e18) {
            uint256 split = balBlotr / 3;
            uint256 _weeks = 4;

            for (uint256 i = 0; i < length;) {
                    address autoBribeNow = _autoBribes[i];
                    IERC20(oBLOTR).approve(autoBribeNow, split);            
                    IAutoBribe(autoBribeNow).deposit(oBLOTR, split, _weeks);

                    ++i;
            }
        }
    }


    function bribe(address[] memory _autoBribes) private {

            uint256 length = _autoBribes.length;            

            for (uint256 i = 0; i < length;) {
                address autoBribeNow = _autoBribes[i];
                if(block.timestamp >= IAutoBribe(autoBribeNow).nextWeek()) {
                    IAutoBribe(autoBribeNow).bribe();
                }

                ++i;

            }
    }

    function reClockAll(address[] memory _autoBribes) private {

            uint256 length = _autoBribes.length;            

            for (uint256 i = 0; i < length;) {
                address autoBribeNow = _autoBribes[i];
                    IAutoBribe(autoBribeNow).reclockBribeToNow();
                
                ++i;

            }
    }

}


// old AutoBribe Contracts
    // address private constant Flow_wCanto_Test = 0xb066870D748a6Caf901eAE881DC96C2a9B004179;
    // address private constant wCanto_Colin_Test = 0x0BF10Dd051856FFf28Df0b033108C7513c3E637e;
    // address private constant Usdc_Flow_AutoBribe = 0x4bC90701a5f3e72A5Fe2686C62Da24B20ca1cfB6;
    // address private constant WCanto_Flow_Autobribe = 0x1fc94f96fdd3Fc51E39575161BD6ed920c03fFA0;
    // address private constant Note_Flow_AutoBribe = 0x5318FfE879e6027fD009beA6837E21F40EEf3903;
    // address private constant Eth_Flow_AutoBribe = 0xb091b7816112d870609Ca1c6E64bD140c189BA34;
    // address private constant WCanto_Flow_Autobribe = 0x1fc94f96fdd3Fc51E39575161BD6ed920c03fFA0;
    // address private constant Note_Flow_AutoBribe = 0x5318FfE879e6027fD009beA6837E21F40EEf3903;
    // address private constant Eth_Flow_AutoBribe = 0xb091b7816112d870609Ca1c6E64bD140c189BA34;