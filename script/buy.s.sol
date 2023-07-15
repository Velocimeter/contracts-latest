// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";

import {Flow} from "../contracts/Flow.sol";
import {Router} from "../contracts/Router.sol";
import {IPair} from "../contracts/interfaces/IPair.sol";
import {IRouter} from "../contracts/interfaces/IRouter.sol";
import {IERC20} from "../contracts/interfaces/IERC20.sol";

contract Buy is Script {

    address constant public router = 0x8e2e2f70B4bD86F82539187A634FB832398cc771;
    address constant flow = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
    address constant wCanto = 0x826551890Dc65655a0Aceca109aB11AbDbD7a07B;
    address constant public wallet = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);

        buy();
        // sell();

        vm.stopBroadcast();
    }

    function buy() private {
        uint256 wCantoBal = IERC20(wCanto).balanceOf(wallet);
        uint256 amountToBuy = 1 * 1e18;
        uint256 amountToGetMin = amountToBuy * 9000 / 100;

        IRouter(router).swapExactTokensForTokensSimple(amountToBuy, amountToGetMin, wCanto, flow, false, wallet, block.timestamp + 100);        

    }
    // function sell() private {
    //     uint256 balFVM = IERC20(FVM).balanceOf(wallet);
    //     uint256 minFTM = ;

    //     IERC20(FVM).approve(router, balFVM);
    //     IRouter(router).swapExactTokensForEth(balFVM, minFTM, [pair], wallet, block.timestamp + 100);
    // }

}


