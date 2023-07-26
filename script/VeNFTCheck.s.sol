// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";

contract VeNFTCheck is Script {

    uint256 constant public THREE_YEARS = 94608000;
    mapping(uint => address) owner;
    mapping(uint => address) check;
    uint256 size;
    uint256 mSigSize;




    function makeOwners() internal {

        owner[	37	] = 	0xF6ec240620aD5288028ad1F96D8725db0c838B90	;
        owner[	43	] = 	0x4F09B919d969b58A96E8BD7673f12372D09395E8	;
        owner[	44	] = 	0xD204E3dC1937d3a30fc6F20ABc48AC5506C94D1E	;
        owner[	45	] = 	0xfF2AD84b31f046dECC8A4F627c7cf81fe61FF54b	;
        owner[	46	] = 	0xa31d50414535263A9b217C7A517253Db0E9e8519	;
        owner[	57	] = 	0x53a5dD07127739e5038cE81eff24ec503A6CC479	;
        owner[	72	] = 	0xF0e4e74Ce34738826477b9280776fc797506fE13	;
        owner[	77	] = 	0xC5C821dE580A01f5979F3223cb2A34a8832eF3A4	;
        owner[	78	] = 	0x5BD97307A40DfBFDBAEf4B3d997ADB816F2dadCC	;
        owner[	82	] = 	0xCAfc58De1E6A071790eFbB6B83b35397023E1544	;
        owner[	83	] = 	0xA67D2c03c3cfe6177a60cAed0a4cfDA7C7a563e0	;
        owner[	92	] = 	0xC6493626be58Dc647A5103970Da5BcF9F7FdbFd2	;
        owner[	71	] = 	0xAA3736052423f768D224E38771F6D08802a6a3De	;
        owner[	100	] = 	0xF09d213EE8a8B159C884b276b86E08E26B3bfF75	;
        owner[	76	] = 	0xa7f37a4699dD344440341134e9f94a4E7BA83110	;
        owner[	79	] = 	0xa7f37a4699dD344440341134e9f94a4E7BA83110	;
        owner[	81	] = 	0xa7f37a4699dD344440341134e9f94a4E7BA83110	;
    }  

    function makeChecks() internal {
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
        
        check[1 ] = votingEscrow.ownerOf(	37	);
        check[2 ] = votingEscrow.ownerOf(	43	);
        check[3 ] = votingEscrow.ownerOf(	44	);
        check[4 ] = votingEscrow.ownerOf(	45	);
        check[5 ] = votingEscrow.ownerOf(	46	);
        check[6 ] = votingEscrow.ownerOf(	57	);
        check[7 ] = votingEscrow.ownerOf(	72	);
        check[8 ] = votingEscrow.ownerOf(	77	);
        check[9 ] = votingEscrow.ownerOf(	78	);
        check[10 ] = votingEscrow.ownerOf(	82	);
        check[11 ] = votingEscrow.ownerOf(	83	);
        check[12 ] = votingEscrow.ownerOf(	92	);
        check[13 ] = votingEscrow.ownerOf(	71	);
        check[14 ] = votingEscrow.ownerOf(	100	);
        check[15 ] = votingEscrow.ownerOf(	76	);
        check[16 ] = votingEscrow.ownerOf(	79	);
        check[17 ] = votingEscrow.ownerOf(	81	);

        size = votingEscrow.balanceOfNFT(37);
        size = size +  votingEscrow.balanceOfNFT(43);
        size = size +  votingEscrow.balanceOfNFT(44);
        size = size +  votingEscrow.balanceOfNFT(45);
        size = size +  votingEscrow.balanceOfNFT(46);
        size = size +  votingEscrow.balanceOfNFT(57);
        size = size +  votingEscrow.balanceOfNFT(72);
        size = size +  votingEscrow.balanceOfNFT(77);
        size = size +  votingEscrow.balanceOfNFT(78);
        size = size +  votingEscrow.balanceOfNFT(82);
        size = size +  votingEscrow.balanceOfNFT(83);
        size = size +  votingEscrow.balanceOfNFT(92);
        size = size +  votingEscrow.balanceOfNFT(71);
        size = size +  votingEscrow.balanceOfNFT(100);
        size = size +  votingEscrow.balanceOfNFT(76);
        size = size +  votingEscrow.balanceOfNFT(79);
        size = size +  votingEscrow.balanceOfNFT(81);

    }      
    function makeSafeNFTs() internal {
    VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        mSigSize = votingEscrow.balanceOfNFT(38);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	33	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	34	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	35	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	36	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	39	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	40	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	41	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	42	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	47	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	48	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	49	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	50	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	55	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	56	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	58	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	59	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	60	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	61	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	62	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	63	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	64	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	65	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	66	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	67	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	68	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	69	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	70	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	73	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	74	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	75	);
mSigSize = mSigSize + votingEscrow.balanceOfNFT(	80	);    }     


    function run() external {
        makeOwners();
        makeChecks();
        makeSafeNFTs();


        if (check[1] == owner[37]){
            console2.log ("ID 37 OK");
        }
        if (check[2] == owner[43]){
            console2.log ("ID 43 OK");
        }
                if (check[3] == owner[44]){
            console2.log ("ID 44 OK");
        }
                if (check[4] == owner[45]){
            console2.log ("ID 45 OK");
        }
                if (check[5] == owner[46]){
            console2.log ("ID 46 OK");
        }
                if (check[6] == owner[57]){
            console2.log ("ID 57 OK");
        }
                if (check[7] == owner[72]){
            console2.log ("ID 72 OK");
        }
                if (check[8] == owner[77]){
            console2.log ("ID 77 OK");
        }
                if (check[9] == owner[78]){
            console2.log ("ID 78 OK");
        }        
                if (check[10] == owner[82]){
            console2.log ("ID 82 OK");
        }
                if (check[11] == owner[83]){
            console2.log ("ID 83 OK");
        }
                if (check[12] == owner[92]){
            console2.log ("ID 92 OK");
        }
                if (check[13] == owner[71]){
            console2.log ("ID 71 OK");
        }
                if (check[14] == owner[100]){
            console2.log ("ID 100 OK");
        }
                if (check[15] == owner[76]){
            console2.log ("ID 76 OK");
        }
                if (check[16] == owner[79]){
            console2.log ("ID 79 OK");
        }
                if (check[17] == owner[81]){
            console2.log ("ID 81 OK");
        }
        

        console2.log ("total locked tokens are", size);
        console2.log ("total locked tokens in MSig NFTs", mSigSize);




}
}
