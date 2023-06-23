// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {IERC20} from 'contracts/interfaces/IERC20.sol';
import {IOBLOTR} from 'contracts/interfaces/IOBlotr.sol';


// This script is used to reset all the NFTs that have voted

address constant EOA = 0x1bAe1083CF4125eD5dEeb778985C1Effac0ecC06;
address constant POVP = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;
address constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
address constant OBLOTR = 0x9f9A1Aa08910867F38359F4287865c4A1162C202;
address constant BLOTR = 0xFf0BAF077e8035A3dA0dD2abeCECFbd98d8E63bE; 


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
    address[] private WCANTO_BNB = [0x1f9AdfE106aA6220BCC898AE4B85d6F68d0aDbF5];
    address[] private sCANTO_wCANTO = [0xe506707dF5fE9b2F6c0Bd6C5039fc542Af1eeB50];
    address[] private sCANTO_BLOTR = [0x44724F2A542D9b7653923D87F17712b113FEB448];
    address[] private FLOW_sCANTO = [0x754AeD0D7A61dD3B03084d5bB8285D674D663703];

    address[] private sCANTO_FLOW = [0x754AeD0D7A61dD3B03084d5bB8285D674D663703];
    address[] private BLOTR_FLOW = [0x257B3C794E8b0b1ef2260E2747fFf354b70bb4C5];
    address[] private underFLOW_FLOW = [0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6];
    address[] private ETH_sCANTO = [0x563C5377215E06e501C0F093012eE4b91D5F55D4];



      uint256[] ONEHUNDRED = [10000];
      uint256[] FIFTY = [5000];
      uint256[] THIRTY = [3000];

    uint256[] tokenIds = [29,30,31,32,51,52,53,54,85];


    function run() external {
        uint256 PrivateKey = vm.envUint("ASSETEOA_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);

        // getRebase(); 
        // increaseLockTime();
        // vote();  

        mintOBlotrAndSend(); 
       
        vm.stopBroadcast();
      

    }
    function vote() private {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);


        voter.vote(29, BLOTR_FLOW, ONEHUNDRED ); // 3M 
        voter.vote(30, BLOTR_FLOW, ONEHUNDRED ); // 3M 
        voter.vote(31, underFLOW_FLOW, ONEHUNDRED ); // 3M 
        voter.vote(32, underFLOW_FLOW, ONEHUNDRED ); // 3M 
        voter.vote(51, BLOTR_FLOW, ONEHUNDRED ); // 2M 
        voter.vote(52, BLOTR_FLOW, ONEHUNDRED ); //  2M 
        voter.vote(53, ETH_sCANTO, ONEHUNDRED ); //  2M 
        voter.vote(54, ETH_sCANTO, ONEHUNDRED ); // 2M 


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
        // voter.reset(93); // 1m 1yr 


    }
    function mintOBlotrAndSend() private {
      uint256 balBlotr = IERC20(BLOTR).balanceOf(EOA);
      if(IERC20(BLOTR).allowance(EOA, OBLOTR) <= balBlotr) {
          IERC20(BLOTR).approve(OBLOTR, 10_000_000 * 1e18);
      }
      if(balBlotr >= 1_000 * 1e18){
        IOBLOTR(OBLOTR).mint(EOA, balBlotr);
      }
      uint256 oBlotrBal = IERC20(OBLOTR).balanceOf(EOA);
      IERC20(OBLOTR).transfer(POVP, oBlotrBal);
      uint256 flowBal = IERC20(FLOW).balanceOf(EOA);
      IERC20(FLOW).transfer(POVP, flowBal);
    }

    function getRebase() private {
        RewardsDistributor rewardsDistributor = RewardsDistributor(0x73278a66b75aC0714c4B049dFF26e5CddF365c85);

        uint256 claimable = rewardsDistributor.claimable(29);
        if (claimable > 50000 * 1e18){
          rewardsDistributor.claim_many(tokenIds);
        }
    }

    function increaseLockTime() private {
      VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

      if (votingEscrow.locked__end(29) <= block.timestamp - 1210000){
        votingEscrow.increase_unlock_time(29, 126242339); 
        votingEscrow.increase_unlock_time(30, 126242339);
        votingEscrow.increase_unlock_time(31, 126242339); 
        votingEscrow.increase_unlock_time(32, 126242339);
        votingEscrow.increase_unlock_time(51, 126242339); 
        votingEscrow.increase_unlock_time(52, 126242339); 
        votingEscrow.increase_unlock_time(53, 126242339); 
        votingEscrow.increase_unlock_time(54, 126242339); 
      }
    }

}
