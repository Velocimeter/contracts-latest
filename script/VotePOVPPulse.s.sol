// // SPDX-License-Identifier: MIT

// pragma solidity 0.8.13;

// // Scripting tool
// import "forge-std/console2.sol";
// import {Script} from "../lib/forge-std/src/Script.sol";
// import {Voter} from "../contracts/Voter.sol";
// import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
// import {VotingEscrow} from "../contracts/VotingEscrow.sol";
// import {IBribe} from "../contracts/interfaces/IBribe.sol";
// import {IERC20} from 'contracts/interfaces/IERC20.sol';
// import {IOBLOTR} from 'contracts/interfaces/IOBlotr.sol';
// import {IGauge} from "../contracts/interfaces/IGauge.sol";


// // This script is use to vote with the POVP, it calls the voter.voter(uint256 tokenId, address[] _poolVote, uint256[] _weights) 10000 =100%
// // It can also take arrays but increases gas cost.

// address constant POVP = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;
// address constant FLOW = 0x39b9D781dAD0810D07E24426c876217218Ad353D;
// address constant wPLS = 0xA1077a294dDE1B09bB078844df40758a5D0f9a27;
// address constant USDC = 0x15D38573d2feeb82e7ad5187aB8c1D52810B1f07;

// address constant wPLS_FLOW = 0xf5eDDb4781e3ec355F49Db60248b34B4D7c467e6;
// address constant USDC_FLOW = 0xd166B6BAcDeC273dD457DD3aDeF9708dcB26734A;



// contract VotePOVP is Script { 

//       address[] private poolsForVote = [wPLS_FLOW, USDC_FLOW];

//       uint256[] ONEHUNDRED = [10000];
//       uint256[] FIFTY = [5000, 5000];

//       uint256[] tokenIds = [35];

//     function run() external {
//         uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
//         vm.startBroadcast(votePrivateKey);

//         getRebase();
//         increaseLockTime();
//         vote();
    
//         vm.stopBroadcast();

//     }      
//     function getRebase() private {
//         RewardsDistributor rewardsDistributor = RewardsDistributor(0x582aEB28632800467C7F672375fE57baB15822a5);
//         uint256 claimable = rewardsDistributor.claimable(35);
//         if (claimable > 50000 * 1e18){
//           rewardsDistributor.claim_many(tokenIds);
//         }
//     }
//     function increaseLockTime() private {
//         VotingEscrow votingEscrow = VotingEscrow(0xe7b8F4D74B7a7b681205d6A3D231d37d472d4986);
//         votingEscrow.increase_unlock_time(35, 15748629);  
//         }
//     function vote() private {
//         Voter voter = Voter(0x8C4FF4004c8a85054639B86E9F8c26e9DA7ff738);

//         voter.vote(35, poolsForVote, [FIFTY, FIFTY]); 

//     }

//     function claimBribes() private { 
//           Voter voter = Voter(0x8C4FF4004c8a85054639B86E9F8c26e9DA7ff738);

//           address[] memory xbribe = new address[](1); 
//           xbribe[0] = 0x506faB47Fbe622109e103D2C43c86df5B51d8104;
//           address[] memory xxBribe = new address[](1); 
//           xxBribe[0] = 0x96139C7B2266539f23fed15D91046F4e8ee0b545; 
//           address[][] memory bribes = new address[][](1);
//           address[] memory bribeArray = new address[](4);
//           bribeArray[0] = sCanto; 
//           bribeArray[1] = OBLOTR; 
//           bribeArray[2] = BLOTR; 
//           bribeArray[3] = FLOW; 
//           bribes[0] = bribeArray; 

//           uint256 curID = 2;
//           uint256 lastID = 14;

//           while (curID <= lastID) {
//             voter.claimBribes(xbribe, bribes, curID);
//             voter.claimBribes(xxBribe, bribes, curID);
//             curID++;
//           }
//     }

// }


