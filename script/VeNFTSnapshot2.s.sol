// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";

contract VeNFTSnapshot2 is Script {

mapping(address => bool) filter;


    function makeFilter() internal {

        filter[0xF6ec240620aD5288028ad1F96D8725db0c838B90] = true; //somm
        filter[0x4F09B919d969b58A96E8BD7673f12372D09395E8] = true; //velodrom
        filter[0xD204E3dC1937d3a30fc6F20ABc48AC5506C94D1E] = true; //tarot
        filter[0xfF2AD84b31f046dECC8A4F627c7cf81fe61FF54b] = true; //impermax
        filter[0xa31d50414535263A9b217C7A517253Db0E9e8519] = true; //dexVault
        filter[0x53a5dD07127739e5038cE81eff24ec503A6CC479] = true; //acsveFLOW
        filter[0xF0e4e74Ce34738826477b9280776fc797506fE13] = true; //cINU
        filter[0xC5C821dE580A01f5979F3223cb2A34a8832eF3A4] = true; //firebird
        filter[0x5BD97307A40DfBFDBAEf4B3d997ADB816F2dadCC] = true; //aCryptos
        filter[0xCAfc58De1E6A071790eFbB6B83b35397023E1544] = true; // DOG
        filter[0xA67D2c03c3cfe6177a60cAed0a4cfDA7C7a563e0] = true; // Cre8r
        filter[0xC6493626be58Dc647A5103970Da5BcF9F7FdbFd2] = true; //YFX
        filter[0xAA3736052423f768D224E38771F6D08802a6a3De] = true; //Openx
        filter[0xa7f37a4699dD344440341134e9f94a4E7BA83110] = true; // stride
        filter[0xF09d213EE8a8B159C884b276b86E08E26B3bfF75] = true; //beefy
        filter[0xcC06464C7bbCF81417c08563dA2E1847c22b703a] = true; //voterEOA
        filter[0x1bAe1083CF4125eD5dEeb778985C1Effac0ecC06] = true; //asset EOA
        filter[0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51] = true; // safe
    }             


    function run() external {
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        // maxID taken from https://tuber.build/address/0x8E003242406FBa53619769F31606ef2Ed8A65C00/transactions#address-tabs
        // maxId 1138
        uint256 currentTokenId = 1214;
        uint256 currentTokenId2 = 1214;
        uint256 maxTokenId = 1216;
        makeFilter();

        while (currentTokenId <= maxTokenId) {
            address owner = votingEscrow.ownerOf(currentTokenId);
            uint256 lockedLeft = votingEscrow.locked__end(currentTokenId);
            uint256 lockedAmnt = votingEscrow.balanceOfNFT(currentTokenId);

            if (owner != address(0)) {
                if (lockedLeft >= (block.timestamp + 94608000)) {
                    if (lockedAmnt >= 1000 * 1e18){ 
                        if (filter[owner] == false) {

                            console2.log(owner);
                        }
                    }
                }
            }
            currentTokenId++;
        }
        while (currentTokenId2 <= maxTokenId) {
            address owner = votingEscrow.ownerOf(currentTokenId2);
            uint256 lockedLeft = votingEscrow.locked__end(currentTokenId2);
            uint256 lockedAmnt = votingEscrow.balanceOfNFT(currentTokenId2);

                if (owner != address(0)) {
                 if (lockedLeft >= (block.timestamp + 94608000)) {
                    if (lockedAmnt >= 1000 * 1e18){
                        if (filter[owner] == false) {

                            (int128 lockAmount,) = votingEscrow.locked(currentTokenId2);

                            console2.log(lockAmount);
                        }
                    }
                }
            }
            currentTokenId2++;
        }
    }
}

