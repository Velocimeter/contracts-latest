// SPDX-License-Identifier: MIT
//  forge script scripts/VoteEOA.s.sol:VoteEOA --rpc-url https://mainnode.plexnode.org:8545 -vvv
// forge script scripts/VoteEOA.s.sol:VoteEOA --rpc-url https://mainnode.plexnode.org:8545 -vvv --broadcast --slow
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";


// This script is used to reset all the NFTs that have voted



contract VoteEOA is Script { 
    address[] private FLOW_WCANTO = [0x2Cc24302fa019C5A8F252afC9A69fCfBB8Dd8D2F];
    address[] private FLOW_NOTE = [0x7e79E7B91526414F49eA4D3654110250b7D9444f];
    address[] private FLOW_USDC  = [0x2267DAa9B7458F5cFE03d3485cc871800977c2c6]; 
    address[] private FLOW_ETH = [0x57E8eFA2639A4cA7069cD90f7e27092758271e6b];
    address[] private FLOW_USDT = [0x6f00840f81C41DC2f7C6f81Eb2E3EaeA973DBF5f];
    address[] private FLOW_multiBTC = [0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062];
    address[] private FLOW_ATOM = [0xddA6259A93649346535db8744502493ee023208D];
    address[] private ACS_USDC = [0x9A408eC2c41FADC0D73a61F46060E83fF864D2E6];
    address[] private ETH_WCANTO = [0x96D976892c6f01Ab5c13E843B38BEe90C2238F03];
    address[] private underFLOW_FLOW = [0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6];


      uint256[] ONEHUNDRED = [10000];
      uint256[] FIFTY = [5000];
      uint256[] THIRTY = [3000];

    uint256[] tokenIds = [29,30,31,32,51,52,53,54,85];


    function run() external {
        uint256 PrivateKey = vm.envUint("ASSETEOA_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        getRebase();
        // getRebase(29);
        // getRebase(30);
        // getRebase(31);
        // getRebase(32);
        // getRebase(51);
        // getRebase(52);
        // getRebase(53);
        // getRebase(29);
        

        // votingEscrow.increase_unlock_time(29, 126242339); 
        // votingEscrow.increase_unlock_time(30, 126242339);
        // votingEscrow.increase_unlock_time(31, 126242339); 
        // votingEscrow.increase_unlock_time(32, 126242339);
        // votingEscrow.increase_unlock_time(51, 126242339); 
        // votingEscrow.increase_unlock_time(52, 126242339); 
        // votingEscrow.increase_unlock_time(53, 126242339); 
        // votingEscrow.increase_unlock_time(54, 126242339); 


        voter.vote(29, FLOW_WCANTO, ONEHUNDRED ); // 3M 
        voter.vote(30, FLOW_ETH, ONEHUNDRED ); // 3M 
        voter.vote(31, FLOW_USDC, ONEHUNDRED ); // 3M 
        voter.vote(32, FLOW_USDC, ONEHUNDRED ); // 3M 
        voter.vote(51, FLOW_ETH, ONEHUNDRED ); // 2M 
        voter.vote(52, FLOW_ETH, ONEHUNDRED ); //  2M 
        voter.vote(53, FLOW_ETH, ONEHUNDRED ); //  2M 
        voter.vote(54, FLOW_ETH, ONEHUNDRED ); // 2M 
        voter.vote(85, underFLOW_FLOW, ONEHUNDRED); //1M



        // voter.reset(29); // 3m
        // voter.reset(30); // 3m
        // voter.reset(31); // 3m
        // voter.reset(32); // 3m
        // voter.reset(51); // 2m
        // voter.reset(52); // 2m
        // voter.reset(53); // 2m
        // voter.reset(54); // 2m
        // voter.reset(85); // 1m 4yr voting
        // voter.reset(84); // 1m 2yr listed on ALTO
        // voter.reset(90); // 1m 1yr 
        // voter.reset(91); // 1m 1yr
        // voter.reset(92); // 1m 1yr
        // voter.reset(93); // 1m 1yr 


        vm.stopBroadcast();
    }
    function getRebase() private {
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);

        uint256 claimable = rewardsDistributor.claimable(29);
        if (claimable > 50000 * 1e18){
          rewardsDistributor.claim_many(tokenIds);
        }
    }

}
