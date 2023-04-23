// SPDX-License-Identifier: MIT

//   forge script scripts/MintForCoorApe.s.sol:MintForCoorApe --rpc-url https://mainnode.plexnode.org:8545 -vvv --broadcast --slow

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {Flow} from "../contracts/Flow.sol";


address constant pujimak_in = 0x981CaC16246D9641bE07BbA6E19E304b74B173BC;
address constant arrowpm = 0x53eB9A6f34e1FeAD9Cf1013c7058679bcA6Acc43;
address constant Lartistokrat = 0xD39ec0556B27beA894718C981470A15724278585;
address constant leon7m = 0x9ba3956bbC21409cfA533499d461ae39C979993B;
address constant eleven = 0x8843f611A7510f139DB69541AeBb33dd2319C093;
address constant Cryptodoi = 0xb72B159AFFB75Cb092EFe7AF8F178566EFDD225c;
address constant prof = 0x8189CA95335AF50A0c9490547186008a6d7747dA;
address constant millicare7 = 0xdD81866Ea68e3f7A036D3bC386c445745E135b16;
address constant Steph = 0x0A335391047F06bd67AF434314614B39c70499Eb;
address constant Oxuep = 0xB0720A40d6335dF0aC90fF9e4b755217632Ca78C;
address constant MempoolEd = 0x92Ef2f096558149C49fa2553C4Dff3C7CC2763a6;
address constant jamesDigital = 0xE8306d0cBa02c1f5a23b38DC3D0f4D6c5fA7A092;
address constant Ethboi = 0xAE886e2A6AA00e98C0C7b1e4885f94a2dB720690;
address constant Flowers = 0xC438E5d32f9381b59072b9a0c730Cbac41575A4E;
address constant Stephen = 0xD360EcB91406717Ad13C4fae757b69B417E2Af6b;
address constant RektFoodFarmer = 0x2d1bdC590Cb736097Bc5577c8974e28dc48F5ECc;
address constant Drakeondigital = 0x62D6E8C7c03D3Fc6276d3A44977C2501593BB90A;
address constant DavidXYZ = 0xf6301E682769A8b3ECdCe94b2419ba40A958D17e;
address constant OxPonci = 0x5fA275BA9F04BDC906084478Dbf41CBE29388C5d;
address constant Strawberryking = 0xC9eebecb1d0AfF4fb2B9978516E075A33639892C;
address constant shatterproof = 0x7c22953Bf2245A8298baf26D586Bd4b08a87caaa;
address constant h1kupz = 0x714C8A1DB40eedc9240AF30bB25D5440796536aa;
address constant pujimak = 0x3C2d6d7144241F1F1203c29C124585e55B58975E;
address constant oxSaturn = 0x71baFD458A46b3BE856C64cdFc25845c0cf9C6Ca;

uint256 constant FOUR_YEARS = 126_144_000;
uint256 constant TotalFLOW = 838_000 * 1e18;



contract MintForCoorApe is Script {
    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);
        VotingEscrow votingEscrow = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
        Flow flow = Flow(0xB5b060055F0d1eF5174329913ef861bC3aDdF029);

        flow.approve(0x8E003242406FBa53619769F31606ef2Ed8A65C00, TotalFLOW);


    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,arrowpm);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,Lartistokrat);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,leon7m);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,eleven);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,Cryptodoi);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,prof);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,millicare7);
    votingEscrow.create_lock_for(2000000000000000000000,FOUR_YEARS,Steph);
    votingEscrow.create_lock_for(10000000000000000000000,FOUR_YEARS,Oxuep);
    votingEscrow.create_lock_for(14000000000000000000000,FOUR_YEARS,MempoolEd);
    votingEscrow.create_lock_for(18000000000000000000000,FOUR_YEARS,jamesDigital);
    votingEscrow.create_lock_for(30000000000000000000000,FOUR_YEARS,Ethboi);
    votingEscrow.create_lock_for(32000000000000000000000,FOUR_YEARS,Flowers);
    votingEscrow.create_lock_for(36000000000000000000000,FOUR_YEARS,Stephen);
    votingEscrow.create_lock_for(36000000000000000000000,FOUR_YEARS,RektFoodFarmer);
    votingEscrow.create_lock_for(38000000000000000000000,FOUR_YEARS,Drakeondigital);
    votingEscrow.create_lock_for(42000000000000000000000,FOUR_YEARS,DavidXYZ);
    votingEscrow.create_lock_for(56000000000000000000000,FOUR_YEARS,OxPonci);
    votingEscrow.create_lock_for(62000000000000000000000,FOUR_YEARS,Strawberryking);
    votingEscrow.create_lock_for(74000000000000000000000,FOUR_YEARS,shatterproof);
    votingEscrow.create_lock_for(94000000000000000000000,FOUR_YEARS,h1kupz);
    votingEscrow.create_lock_for(102000000000000000000000,FOUR_YEARS,pujimak);
    votingEscrow.create_lock_for(178000000000000000000000,FOUR_YEARS,oxSaturn);

        vm.stopBroadcast();
        }
    }


// 