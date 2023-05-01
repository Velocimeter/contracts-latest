// SPDX-License-Identifier: MIT
//  forge script scripts/VotePOVP.s.sol:VotePOVP --rpc-url https://mainnode.plexnode.org:8545 -vvv
// forge script scripts/VotePOVP.s.sol:VotePOVP --rpc-url https://mainnode.plexnode.org:8545 -vvv --broadcast --slow

//  forge script scripts/VotePOVP.s.sol:VotePOVP --rpc-url https://canto.slingshot.finance	 -vvv
// forge script scripts/VotePOVP.s.sol:VotePOVP --rpc-url https://canto.slingshot.finance -vvv --broadcast --slow

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";

// This script is use to vote with the POVP, it calls the voter.voter(uint256 tokenId, address[] _poolVote, uint256[] _weights) 10000 =100%
// It can also take arrays but increases gas cost.

address constant VoterEOA = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;


contract VotePOVP is Script { 

      address[] private  FLOW_WCANTO = [0x2Cc24302fa019C5A8F252afC9A69fCfBB8Dd8D2F];
      address[] private  FLOW_NOTE = [0x7e79E7B91526414F49eA4D3654110250b7D9444f];
      address[] private  FLOW_USDC  = [0x2267DAa9B7458F5cFE03d3485cc871800977c2c6]; 
      address[] private  FLOW_ETH = [0x57E8eFA2639A4cA7069cD90f7e27092758271e6b];
      address[] private  FLOW_USDT = [0x6f00840f81C41DC2f7C6f81Eb2E3EaeA973DBF5f]; //<-stop voting
      address[] private  FLOW_multiBTC = [0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062];
      address[] private  FLOW_ATOM = [0xddA6259A93649346535db8744502493ee023208D];
      address[] private underFLOW_FLOW = [0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6];



      uint256[] ONEHUNDRED = [10000];
      uint256[] FIFTY = [5000];
      uint256[] THIRTY = [3000];

      uint256[] tokenIds = [2,3,4,5,6,7,8,9,10,11,12,13,14];

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        getRebase();

        // votingEscrow.increase_unlock_time(2, 126242339); 
        // votingEscrow.increase_unlock_time(3, 126242339);
        // votingEscrow.increase_unlock_time(4, 126242339); 
        // votingEscrow.increase_unlock_time(5, 126242339);
        // votingEscrow.increase_unlock_time(6, 126242339); 
        // votingEscrow.increase_unlock_time(7, 126242339); 
        // votingEscrow.increase_unlock_time(8, 126242339); 
        // votingEscrow.increase_unlock_time(9, 126242339); 
        // votingEscrow.increase_unlock_time(10, 126242339); 
        // votingEscrow.increase_unlock_time(11, 126242339); 
        // votingEscrow.increase_unlock_time(12, 126242339);
        // votingEscrow.increase_unlock_time(13, 126242339); 
        // votingEscrow.increase_unlock_time(14, 126242339); 

        voter.vote(2, FLOW_USDC, ONEHUNDRED); // 1M  
        voter.vote(3, FLOW_USDC, ONEHUNDRED); // 1M 
        voter.vote(4, underFLOW_FLOW, ONEHUNDRED); // 1M
        voter.vote(5, FLOW_WCANTO, ONEHUNDRED); // 1M
        voter.vote(6, FLOW_WCANTO, ONEHUNDRED); // 1M reset()
        voter.vote(7, FLOW_WCANTO, ONEHUNDRED); // 2M
        voter.vote(8, FLOW_NOTE, ONEHUNDRED); //  2M
        voter.vote(9, FLOW_NOTE, ONEHUNDRED); // 2M
        voter.vote(10, FLOW_NOTE, ONEHUNDRED); //  2M
        voter.vote(11, FLOW_NOTE, ONEHUNDRED); // 2M
        voter.vote(12, FLOW_WCANTO, ONEHUNDRED); // 2M
        voter.vote(13, FLOW_WCANTO, ONEHUNDRED); //  3M
        voter.vote(14, FLOW_WCANTO, ONEHUNDRED); // 3M

        vm.stopBroadcast();


    }
    function getRebase() private {
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);
        uint256 claimable = rewardsDistributor.claimable(2);
        if (claimable > 50000 * 1e18){
          rewardsDistributor.claim_many(tokenIds);
        }
    }
}
