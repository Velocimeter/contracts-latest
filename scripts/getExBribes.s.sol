// SPDX-License-Identifier: MIT


// forge script scripts/getExBribes.s.sol:getExBribes --rpc-url https://canto.slingshot.finance	  -vvv --broadcast

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {Pair} from "../contracts/Pair.sol";
import {IPair} from "../contracts/interfaces/IPair.sol";
import {IBribe} from "../contracts/interfaces/IBribe.sol";

import {WrappedExternalBribe} from "../contracts/WrappedExternalBribe.sol";
import {Voter} from "../contracts/Voter.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";

contract getExBribes is Script {
    function run() external view {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        uint256 totalNFTs = 24;
        uint8[24] memory nftIDs  = [33, 34, 35, 36, 38, 39, 40, 41, 42, 47, 48, 49, 50, 55, 56, 58, 61, 62, 63, 64, 65, 66, 69, 70];
        uint256 currentTokenId = 0;

        while (currentTokenId <= totalNFTs) {
            uint256 id = nftIDs[currentTokenId];
            address pair = voter.poolVote(id, 0);
            address bribe = IPair(pair).externalBribe();
            logArray(bribe);

            console2.log(id);
            console2.log(bribe);

            currentTokenId++;
        }
    }
}

function logArray(address[] calldata arr) {
uint i = 0;
  for (i; i<arr.length; i++) {
    console2.log(arr[i]);
  }
}
