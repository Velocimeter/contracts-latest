// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {IBribe} from "../contracts/interfaces/IBribe.sol";
import {IERC20} from 'contracts/interfaces/IERC20.sol';
import {IOBLOTR} from 'contracts/interfaces/IOBlotr.sol';
import {IGauge} from "../contracts/interfaces/IGauge.sol";


// This script is use to vote with the POVP, it calls the voter.voter(uint256 tokenId, address[] _poolVote, uint256[] _weights) 10000 =100%
// It can also take arrays but increases gas cost.

address constant POVP = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;
address constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant OBLOTR = 0x9f9A1Aa08910867F38359F4287865c4A1162C202;
address constant BLOTR = 0xFf0BAF077e8035A3dA0dD2abeCECFbd98d8E63bE;
address constant ETH = 0x5FD55A1B9FC24967C4dB09C513C3BA0DFa7FF687;
address constant sCanto = 0x9F823D534954Fc119E31257b3dDBa0Db9E2Ff4ed;
address constant sCANTO_wCANTO_Gauge = 0x368A98078eC7bD360d0715e92aE8B57c20154937;
address constant underFLOW = 0x42F4a26B58bC1f4Fa9652D208a0223947AB742c7;


contract VotePOVP is Script { 

      address[] private sCANTO_FLOW = [0x754AeD0D7A61dD3B03084d5bB8285D674D663703];
      address[] private BLOTR_FLOW = [0x257B3C794E8b0b1ef2260E2747fFf354b70bb4C5];
      address[] private ETH_sCANTO = [0x563C5377215E06e501C0F093012eE4b91D5F55D4];
      address[] private underFLOW_FLOW = [0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6];


      uint256[] ONEHUNDRED = [10000];
      uint256[] FIFTY = [5000];
      uint256[] THIRTY = [3000];

      uint256[] tokenIds = [2,3,4,5,6,7,8,9,10,11,12,13,14];

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);

        // claimBribes();
        // mintOBlotr();  
        // sendRewards();

        // claimETHBribes();
        // claimFlowBlotrBribes();
        // claimUnderFlowBribes();

        getRebase();
        increaseLockTime();
        vote();

        vm.stopBroadcast();
    }      
    function sendRewards() private {
        uint256 balOBlotr = IERC20(OBLOTR).balanceOf(POVP);
          bribe(balOBlotr);
    }
    function vote() private {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        voter.vote(2, sCANTO_FLOW, ONEHUNDRED ); // 11.5M  
        voter.vote(3, sCANTO_FLOW, ONEHUNDRED ); // 11.6M 
        voter.vote(4, sCANTO_FLOW, ONEHUNDRED ); // 4.3M
        voter.vote(5, sCANTO_FLOW, ONEHUNDRED ); // 4.3M
        voter.vote(6, sCANTO_FLOW, ONEHUNDRED ); // 4.3M 
        voter.vote(12, underFLOW_FLOW, ONEHUNDRED ); // 4.2M
        voter.vote(13, BLOTR_FLOW, ONEHUNDRED ); //  5.3M
        voter.vote(14, ETH_sCANTO, ONEHUNDRED ); // 6.4M
    }

    function bribe(uint256 _amountOBlotr) private {
      uint256 balFLOW = IERC20(FLOW).balanceOf(POVP);
      uint256 flowSplit = balFLOW / 3;
      uint256 blotrSplit = _amountOBlotr / 3;

      address xxBribe_sCanto_Flow = 0x96139C7B2266539f23fed15D91046F4e8ee0b545;
      address xxBribe_Blotr_Flow = 0x35C9bbab52d14373cF8cB2ca58a4CA9C57A2FC11;
      address xxBribe_Blotr_sCanto = 0xc632487e01CA93C4D96438C5314F67796386EACC;
      
      if(IERC20(FLOW).allowance(POVP, xxBribe_Blotr_Flow) <= flowSplit) {
        IERC20(FLOW).approve(xxBribe_Blotr_Flow, 10_000_000 * 1e18);
      }
      if(IERC20(FLOW).allowance(POVP, xxBribe_Blotr_sCanto) <= flowSplit) {
        IERC20(FLOW).approve(xxBribe_Blotr_sCanto, 10_000_000 * 1e18);
      }      
      if(IERC20(FLOW).allowance(POVP, xxBribe_sCanto_Flow) <= flowSplit) {
        IERC20(FLOW).approve(xxBribe_sCanto_Flow, 10_000_000 * 1e18);
      }

      if(IERC20(OBLOTR).allowance(POVP, xxBribe_Blotr_Flow) <= blotrSplit) {
        IERC20(OBLOTR).approve(xxBribe_Blotr_Flow, 10_000_000 * 1e18);
      }
      if(IERC20(OBLOTR).allowance(POVP, xxBribe_Blotr_sCanto) <= blotrSplit) {
        IERC20(OBLOTR).approve(xxBribe_Blotr_sCanto, 10_000_000 * 1e18);
      }      
      if(IERC20(OBLOTR).allowance(POVP, xxBribe_sCanto_Flow) <= blotrSplit) {
        IERC20(OBLOTR).approve(xxBribe_sCanto_Flow, 10_000_000 * 1e18);
      } 
        IBribe(xxBribe_sCanto_Flow).notifyRewardAmount(FLOW, flowSplit);
        IBribe(xxBribe_Blotr_sCanto).notifyRewardAmount(FLOW, flowSplit);
        IBribe(xxBribe_Blotr_Flow).notifyRewardAmount(FLOW, flowSplit); 
        IBribe(xxBribe_sCanto_Flow).notifyRewardAmount(OBLOTR, blotrSplit);
        IBribe(xxBribe_Blotr_Flow).notifyRewardAmount(OBLOTR, blotrSplit);
        IBribe(xxBribe_Blotr_sCanto).notifyRewardAmount(OBLOTR, blotrSplit);
    }
    function mintOBlotr() private {
      uint256 balBlotr = IERC20(BLOTR).balanceOf(POVP);
      if(IERC20(BLOTR).allowance(POVP, OBLOTR) <= balBlotr) {
          IERC20(BLOTR).approve(OBLOTR, 10_000_000 * 1e18);
      }
      if(balBlotr >= 10_000 * 1e18){
        IOBLOTR(OBLOTR).mint(POVP, balBlotr);
      }
    }
    function claimBribes() private { 
          Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

          address[] memory xbribe = new address[](1); 
          xbribe[0] = 0x506faB47Fbe622109e103D2C43c86df5B51d8104;
          address[] memory xxBribe = new address[](1); 
          xxBribe[0] = 0x96139C7B2266539f23fed15D91046F4e8ee0b545; 
          address[][] memory bribes = new address[][](1);
          address[] memory bribeArray = new address[](4);
          bribeArray[0] = sCanto; 
          bribeArray[1] = OBLOTR; 
          bribeArray[2] = BLOTR; 
          bribeArray[3] = FLOW; 
          bribes[0] = bribeArray; 

          uint256 curID = 2;
          uint256 lastID = 6;

          while (curID <= lastID) {
            voter.claimBribes(xbribe, bribes, curID);
            voter.claimBribes(xxBribe, bribes, curID);
            curID++;
          } 
    }         
    function claimETHBribes() private {
      Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

          address[] memory ethXBribes = new address[](2);
          ethXBribes[0]= 0x8d01c692a5e7724132d9c6BDf4D4Fb93ef25860c;
          ethXBribes[1]= 0x2c3bCc7b7b7fbb66f7FEF5f2593A845966d2838c;
          address [][] memory ethBribes = new address[][](1);
          address [] memory ethBribeArray = new address[](4);
            ethBribeArray[0] = sCanto;
            ethBribeArray[1] = OBLOTR;
            ethBribeArray[2] = FLOW;
            ethBribeArray[3] = ETH;
          ethBribes[0] = ethBribeArray; 

          voter.claimBribes(ethXBribes, ethBribes, 14);        
    }
    function claimFlowBlotrBribes() private {
      Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

          address[] memory XBribes = new address[](2);
          XBribes[0]= 0x35C9bbab52d14373cF8cB2ca58a4CA9C57A2FC11;
          XBribes[1]= 0xd11A815FCea7bD7B4BcB4E8774bE86F9AA33558c;
          address [][] memory Bribes = new address[][](1);
          address [] memory BribeArray = new address[](3);
            BribeArray[0] = BLOTR;
            BribeArray[1] = OBLOTR;
            BribeArray[2] = FLOW;
          Bribes[0] = BribeArray; 

          voter.claimBribes(XBribes, Bribes, 13);        
    }
    function claimUnderFlowBribes() private {
       Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

          address[] memory XBribes = new address[](2);
          XBribes[0]= 0xD51FdD3AAce02adC7451aDAd679E73DB5e21B702;
          XBribes[1]= 0xd0D17C23Fd3d0E1fbFbBa4ca30F7E1533C62AF81;
          address [][] memory Bribes = new address[][](1);
          address [] memory BribeArray = new address[](2);
            BribeArray[0] = underFLOW;
            BribeArray[1] = FLOW;
          Bribes[0] = BribeArray; 

          voter.claimBribes(XBribes, Bribes, 12);        
    }
    function getRebase() private {
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);
        uint256 claimable = rewardsDistributor.claimable(2);
        if (claimable > 50000 * 1e18){
          rewardsDistributor.claim_many(tokenIds);
        }
    }
    function increaseLockTime() private {
      VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

      if (votingEscrow.locked__end(2) <= block.timestamp + 125032339){
        votingEscrow.increase_unlock_time(2, 126242339); 
        votingEscrow.increase_unlock_time(3, 126242339);
        votingEscrow.increase_unlock_time(4, 126242339); 
        votingEscrow.increase_unlock_time(5, 126242339);
        votingEscrow.increase_unlock_time(6, 126242339); 

        votingEscrow.increase_unlock_time(12, 126242339);
        votingEscrow.increase_unlock_time(13, 126242339); 
        votingEscrow.increase_unlock_time(14, 126242339); 
      }
    }
    // function gauge(uint256 _amount) private {
    //   if(IERC20(OBLOTR).allowance(POVP, sCANTO_wCANTO_Gauge) <= _amount) {
    //     IERC20(OBLOTR).approve(sCANTO_wCANTO_Gauge, 10_000_000 * 1e18);
    //   }
    //   IGauge(sCANTO_wCANTO_Gauge).notifyRewardAmount(OBLOTR, _amount);
    // }

}


      // address[] private  FLOW_WCANTO = [0x2Cc24302fa019C5A8F252afC9A69fCfBB8Dd8D2F];
      // address[] private  FLOW_NOTE = [0x7e79E7B91526414F49eA4D3654110250b7D9444f];
      // address[] private  FLOW_USDC  = [0x2267DAa9B7458F5cFE03d3485cc871800977c2c6]; //<-stop voting 
      // address[] private  FLOW_ETH = [0x57E8eFA2639A4cA7069cD90f7e27092758271e6b];
      // address[] private  FLOW_USDT = [0x6f00840f81C41DC2f7C6f81Eb2E3EaeA973DBF5f]; //<-stop voting
      // address[] private  FLOW_multiBTC = [0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062];
      // address[] private underFLOW_FLOW = [0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6];
      // address[] private  sCANTO_wCANTO = [0xe506707dF5fE9b2F6c0Bd6C5039fc542Af1eeB50];
      // address[] private  sCANTO_BLOTR = [0x44724F2A542D9b7653923D87F17712b113FEB448];


      // forge script script/VotePOVP.s.sol:VotePOVP --rpc-url https://velocimeter.tr.zone/ --vvvv --broadcast --slow
