// SPDX-License-Identifier: MIT
//forge script scripts/KillGauges.s.sol:KillGauges --rpc-url http://143.42.54.208:8545/  -vvv
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import "../contracts/interfaces/ITurnstile.sol";



contract Turnstile is Script { 

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);

        uint256 TokenId = 178;
        uint256 maxTokenId = 585;
        while (TokenId <= maxTokenId) {
                uint256 balance = ITurnstile(0xEcf044C5B4b867CFda001101c617eCd347095B44).balances(TokenId);

                balance = balance / 1000000000000000000;
                    if (balance > 1){
                        console2.log("Token ID: ", TokenId);
                        console2.log("Locked amount: ", balance, "wCANTO");
                    }    
                TokenId++;        

            }


        vm.stopBroadcast();
        }

}

//            address owner = 0x0a178469E3d08BEAA0a289E416Ab924F10807989;

// // get contract address's NFT ID
// cast call 0xEcf044C5B4b867CFda001101c617eCd347095B44 "getTokenId(address)" 0x0a178469E3d08BEAA0a289E416Ab924F10807989 --rpc-url https://canto.slingshot.finance

// // get NFT's balance
// cast call 0xEcf044C5B4b867CFda001101c617eCd347095B44 "balances(uint256)" 594 --rpc-url https://canto.slingshot.finance

// // token id, recipient, amount
// cast call 0xEcf044C5B4b867CFda001101c617eCd347095B44 "withdraw(uint256,address,uint256)" $TOKEN_ID $RECIPIENT_ADDRESS $WITHDRAW_AMOUNT --rpc-url https://canto.slingshot.finance --private-key $PRIVATE_KEY

