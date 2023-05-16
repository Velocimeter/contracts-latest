// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {VotingEscrow} from "../contracts/VotingEscrow.sol";

contract VeNFTSnapshot is Script {
    function run() external view {
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
        // From https://alto.build/collections/0x990eff367c6c4aece43c1e98099061c897730f27
        uint256 currentTokenId = 201;
        uint256 maxTokenId = 300;
        while (currentTokenId <= maxTokenId) {
            address owner = votingEscrow.ownerOf(currentTokenId);

            if (owner != address(0)) {
                (int128 lockAmount,) = votingEscrow.locked(currentTokenId);

                // console2.log("Token ID: ");
                // console2.log(currentTokenId);
                // console2.log("Owner: ");
                console2.log(owner);
                console2.log("Locked amount: ");
                console2.log(lockAmount);
            }

            currentTokenId++;
        }
    }
}

