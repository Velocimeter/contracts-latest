// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

import {Voter} from "../contracts/Voter.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {Flow} from "../contracts/Flow.sol";
import {PairFactory} from "../contracts/factories/PairFactory.sol";
import {Gauge} from '../contracts/Gauge.sol';
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract ResetWithdrawNFT is Script {
    address private constant ceazor = 0x71655980A65E481B09FD77643dA2726F955Ff3Ed;
    uint256 private constant tknID = 285;
    address private constant TANK = 0x0A868fd1523a1ef58Db1F2D135219F0e30CBf7FB;
    address private constant ATOM = 0xecEEEfCEE421D8062EF8d6b4D814efe4dc898265;
    address private constant wCANTO = 0x826551890Dc65655a0Aceca109aB11AbDbD7a07B;


    function run() external {
        VotingEscrow votingEscrow = VotingEscrow(0x99F911758345BB6DE08d28b2319D93B914e375a1);
        Flow flow = Flow(0xB5b060055F0d1eF5174329913ef861bC3aDdF029);
        Flow v1flow = Flow(0x2Baec546a92cA3469f71b7A091f7dF61e5569889);
        Voter voter = Voter(0xd08143fD3362aDdF5FAac314B2642c0270587503);
        PairFactory pairfactory = PairFactory(0xfEC3a2ec1f0676D59493Fe0F45911E6B5DF5E205);
        Gauge gauge1 = Gauge(0xFD2F8bD82b0ecAcbe42BD9097c36EA667B66A023);
        Gauge gauge2 = Gauge(0x09141c84a510416ff727AC2bB49cf15526d3Ae47);

        

        uint256 ceazorPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(ceazorPrivateKey);

        uint256 bal1 = v1flow.balanceOf(0x89443935AA0BB6e9fAD7E87b57da426e11aC82c5);
        uint256 bal2 = flow.balanceOf(0x89443935AA0BB6e9fAD7E87b57da426e11aC82c5);

        console2.log("v1FLOW", bal1/1000000000000000000, "vs v2FLOW", bal2/1000000000000000000);

        // uint256 divBal = gauge2.derivedBalance(ceazor);
        // console2.log(divBal);

    //    uint256 ATOMBal = IERC20(ATOM).balanceOf(TANK);
    //    console2.log(ATOMBal);
    //    uint256 CantoBal = IERC20(wCANTO).balanceOf(TANK);
    //    console2.log(CantoBal);

        // gauge1.withdrawToken(5000, tknID);
        // gauge2.withdrawToken(5000, tknID);

        // uint256 bal1 = flow.balanceOf(ceazor);
        // console2.log(bal1);

        // bool owned = votingEscrow.isApprovedOrOwner(ceazor, tknID);
        // console2.log(owned);

        // uint256 attached = votingEscrow.attachments(tknID);
        // console2.log(attached);
        
        // address tank = pairfactory.tank();
        // uint256 tankBalFlow = flow.balanceOf(tank);
        // console2.log(tankBalFlow);

        // uint votes = votingEscrow.getVotes(ceazor);
        // console2.log(votes);

        // address minter = voter.minter();
        // console2.log(minter);
    
        // address pools = voter.poolVote(tknID);
        // console2.log(pools);



        // voter.detachTokenFromGauge(tknID, ceazor);
        // uint256 attached = votingEscrow.attachments(tknID);
        // console2.log(attached);

        // voter.reset(tknID);
        // votingEscrow.withdraw(tknID);

        // uint256 bal2 = flow.balanceOf(ceazor);
        // console2.log(bal2);

        // uint256 diff = bal2 - bal1;
        // console2.log(diff);

        vm.stopBroadcast();
    }

}
