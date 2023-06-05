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

// This script is use to vote with the POVP, it calls the voter.voter(uint256 tokenId, address[] _poolVote, uint256[] _weights) 10000 =100%
// It can also take arrays but increases gas cost.

address constant VoterEOA = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;
address constant flow = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant oBlotr = 0x9f9A1Aa08910867F38359F4287865c4A1162C202;
address constant blotr = 0xFf0BAF077e8035A3dA0dD2abeCECFbd98d8E63bE;
address constant sCanto = 0x9F823D534954Fc119E31257b3dDBa0Db9E2Ff4ed;


contract VotePOVP is Script { 

      address[] private sCANTO_FLOW = [0x754AeD0D7A61dD3B03084d5bB8285D674D663703];
      address[] private BLOTR_FLOW = [0x257B3C794E8b0b1ef2260E2747fFf354b70bb4C5];
      address[] private ETH_sCANTO = [0x563C5377215E06e501C0F093012eE4b91D5F55D4];


      uint256[] ONEHUNDRED = [10000];
      uint256[] FIFTY = [5000];
      uint256[] THIRTY = [3000];

      uint256[] tokenIds = [2,3,4,5,6,7,8,9,10,11,12,13,14];

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);

        // getRebase();
        // increaseLockTime();
        // vote();

        // claimBribes();

        bribe();

        vm.stopBroadcast();

    }
    function vote() private {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        voter.vote(2, sCANTO_FLOW, ONEHUNDRED ); // 1M  
        voter.vote(3, sCANTO_FLOW, ONEHUNDRED ); // 1M 
        voter.vote(4, sCANTO_FLOW, ONEHUNDRED ); // 1M
        voter.vote(5, sCANTO_FLOW, ONEHUNDRED ); // 1M
        voter.vote(6, sCANTO_FLOW, ONEHUNDRED ); // 1M 
        voter.vote(7, sCANTO_FLOW, ONEHUNDRED ); // 2M
        voter.vote(8, sCANTO_FLOW, ONEHUNDRED ); //  2M
        voter.vote(9, sCANTO_FLOW, ONEHUNDRED ); // 2M
        voter.vote(10, sCANTO_FLOW, ONEHUNDRED ); //  2M
        voter.vote(11, sCANTO_FLOW, ONEHUNDRED ); // 2M
        voter.vote(12, sCANTO_FLOW, ONEHUNDRED ); // 2M
        voter.vote(13, sCANTO_FLOW, ONEHUNDRED ); //  3M
        voter.vote(14, sCANTO_FLOW, ONEHUNDRED ); // 3M
    }

    function bribe() private {
      uint256 balFLOW = IERC20(flow).balanceOf(VoterEOA);
      uint256 balBlotr = IERC20(blotr).balanceOf(VoterEOA);
      uint256 balOBlotr = IERC20(oBlotr).balanceOf(VoterEOA);

      address xxBribe = 0x96139C7B2266539f23fed15D91046F4e8ee0b545;
      if (balFLOW >= 100_000 * 1e18) {
        IBribe(xxBribe).notifyRewardAmount(flow, 100_000 * 1e18);
      }
      if (balBlotr >= 50_000 * 1e18) {
        IBribe(xxBribe).notifyRewardAmount(blotr, 50_000 * 1e18);
      }
      if (balOBlotr >= 50_000 * 1e18) {
        IBribe(xxBribe).notifyRewardAmount(oBlotr, 50_000 * 1e18);
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
          bribeArray[1] = oBlotr; 
          bribeArray[2] = blotr; 
          bribeArray[3] = flow; 
          bribes[0] = bribeArray; 

          uint256 curID = 2;
          uint256 lastID = 14;

          while (curID <= lastID) {
            voter.claimBribes(xbribe, bribes, curID);
            voter.claimBribes(xxBribe, bribes, curID);
            curID++;
          }
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

      if (votingEscrow.locked__end(29) <= block.timestamp - 1210000){
        votingEscrow.increase_unlock_time(2, 126242339); 
        votingEscrow.increase_unlock_time(3, 126242339);
        votingEscrow.increase_unlock_time(4, 126242339); 
        votingEscrow.increase_unlock_time(5, 126242339);
        votingEscrow.increase_unlock_time(6, 126242339); 
        votingEscrow.increase_unlock_time(7, 126242339); 
        votingEscrow.increase_unlock_time(8, 126242339); 
        votingEscrow.increase_unlock_time(9, 126242339); 
        votingEscrow.increase_unlock_time(10, 126242339); 
        votingEscrow.increase_unlock_time(11, 126242339); 
        votingEscrow.increase_unlock_time(12, 126242339);
        votingEscrow.increase_unlock_time(13, 126242339); 
        votingEscrow.increase_unlock_time(14, 126242339); 
      }
    }
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
