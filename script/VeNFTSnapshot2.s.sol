// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";

contract VeNFTSnapshot2 is Script {


    // function filtered() public view returns (address _filter) {
    //         address[] memory filterList = new address[](14);
    //             filterList[0] = 0xF6ec240620aD5288028ad1F96D8725db0c838B90; 
    //             filterList[1] = 0x4F09B919d969b58A96E8BD7673f12372D09395E8;
    //             filterList[2] = 0xD204E3dC1937d3a30fc6F20ABc48AC5506C94D1E;
    //             filterList[3] = 0xfF2AD84b31f046dECC8A4F627c7cf81fe61FF54b;
    //             filterList[4] = 0xa31d50414535263A9b217C7A517253Db0E9e8519;
    //             filterList[5] = 0x53a5dD07127739e5038cE81eff24ec503A6CC479;
    //             filterList[6] = 0xF0e4e74Ce34738826477b9280776fc797506fE13;
    //             filterList[7] = 0xC5C821dE580A01f5979F3223cb2A34a8832eF3A4;
    //             filterList[8] = 0x5BD97307A40DfBFDBAEf4B3d997ADB816F2dadCC;
    //             filterList[9] = 0xCAfc58De1E6A071790eFbB6B83b35397023E1544;
    //             filterList[10] = 0xA67D2c03c3cfe6177a60cAed0a4cfDA7C7a563e0;
    //             filterList[11] = 0xC6493626be58Dc647A5103970Da5BcF9F7FdbFd2;
    //             filterList[12] = 0xAA3736052423f768D224E38771F6D08802a6a3De;
    //             filterList[13] = 0xa7f37a4699dD344440341134e9f94a4E7BA83110;         


    //             uint256 length = filterList.length;

    //         for (uint256 i = 0; i < length;) {
    //             address filterNow = filterList[i];
    //             return (filterNow);
    //             ++i;
    //         }
    // }       


    function run() external view {
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        // maxID taken from https://tuber.build/token/0x8E003242406FBa53619769F31606ef2Ed8A65C00/token-transfers
        // maxId 1115
        uint256 currentTokenId = 1;
        uint256 maxTokenId = 1116;

        while (currentTokenId <= maxTokenId) {
            address owner = votingEscrow.ownerOf(currentTokenId);
            uint256 lockedLeft = votingEscrow.locked__end(currentTokenId);

            if (owner != address(0)) {
                if (lockedLeft >= (block.timestamp + 94608000)) {
                    // if (owner != filtered()) {

                        (int128 lockAmount,) = votingEscrow.locked(currentTokenId);

                        console2.log("Token ID: ");
                        console2.log(currentTokenId);
                        console2.log("Owner: ");
                        console2.log(owner);
                        console2.log("Locked amount: ");
                        console2.log(lockAmount);
                    // }
                }
            }

            currentTokenId++;
        }
    }
}

