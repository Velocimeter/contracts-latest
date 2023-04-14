// SPDX-License-Identifier: MIT
//   forge script scripts/VoteAntiBrick.s.sol:VoteAntiBrick --rpc-url https://mainnode.plexnode.org:8545 -vvv
//   forge script scripts/VoteAntiBrick.s.sol:VoteAntiBrick --rpc-url https://mainnode.plexnode.org:8545 -vvv --broadcast --slow

pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";

// This script is use to vote with the POVP, it calls the voter.voter(uint256 tokenId, address[] _poolVote, uint256[] _weights) 10000 =100%
// It can also take arrays but increases gas cost.

// VoterEOA = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a

contract VoteAntiBrick is Script { 

        uint256 FIFTY = 500;
        uint256 ONE = 100;

address constant vAMM_multiBTC_USDT = 0x69aE6BE12B5A3E62D1713F6ddd6ce990964beBb9;
address constant vAMM_cINU_WCANTO = 0x2501c056218F3C8F3c8B249bF4ddd941ae5642B4;
address constant vAMM_TAROT_USDC = 0x744c6f8abe326417D2b0e70d283889833eeAF029;
address constant vAMM_NOTE_multiBTC = 0xe86F5A4634966e434f54Af4B598417dB0BA524E7;
address constant vAMM_USDC_WCANTO = 0x9D047638826096ec3AbCa3cda9973dB19C89a786;
address constant vAMM_NOTE_IBEX = 0xB4FDDc1Df9CCA17e26328316e94C9099aCbd3bF8;
address constant vAMM_ETH_FLOW = 0x57E8eFA2639A4cA7069cD90f7e27092758271e6b;
address constant vAMM_FLOW_CRE8R = 0xD622BE04Bc6c129EAa3915E33863c94123705678;
address constant vAMM_ETH_CRE8R = 0x237F9c6d2BBeAcc91049710ac47e3eAc83cDC55c;
address constant vAMM_FLOW_ATOM = 0xddA6259A93649346535db8744502493ee023208D;
address constant vAMM_NOTE_SOMM = 0x4ae856378217164b455d12B3420f2c1400480006;
address constant vAMM_BIFI_WCANTO = 0x2dBFeB48dEaccBFf9b0a54dEd1BC172e135a809C;
address constant sAMM_BUSD_NOTE = 0x006B764F1a38dd173Bbb9b73beF095De68E81571;
address constant vAMM_cINU_FLOW = 0x931fDDa6450278672CebeF4b7100a64dE439623f;
address constant vAMM_ACS_USDC = 0x9A408eC2c41FADC0D73a61F46060E83fF864D2E6;
address constant vAMM_WCANTO_FLOW = 0x2Cc24302fa019C5A8F252afC9A69fCfBB8Dd8D2F;
address constant vAMM_INJ_FLOW = 0xA069AA071ebe51274e2c095D63Ba03Fe51D98e0A;
address constant vAMM_NOTE_FLOW = 0x7e79E7B91526414F49eA4D3654110250b7D9444f;
address constant vAMM_WCANTO_CRE8R = 0x7392c47d48b3794344500Ca4c61A824e13FA8693;
address constant vAMM_USDC_FLOW = 0x2267DAa9B7458F5cFE03d3485cc871800977c2c6;
address constant sAMM_NOTE_USDC = 0x5CbB5ed3C767d7BcC7f8796aCF37a9D181233A2f;
address constant vAMM_WCANTO_SOMM = 0x9A2310444766FdE6316D183e2Bb1c39379E3a042;
address constant sAMM_acsFLOW_FLOW = 0x5cEd6533Ed0AefdC8D2761d1F6d3868889BAaBa1;
address constant vAMM_INJ_WCANTO = 0x72A4EE8e502B5aa3ef6b848a05cA3c323Ed6196d;
address constant vAMM_cINU_multiBTC = 0x4a0b21b17285d38f09005dDab39438e11FdfDfDD;
address constant vAMM_ETH_multiBTC = 0x1D4E33e07ddf9cc8EDB204102c3238b6A2c0e3fb;
address constant vAMM_WCANTO_ATOM = 0x04A68FD82344377d7c2Dc3CdfA8235c907805577;
address constant sAMM_USDC_USDT = 0x1086B26CF340801b26CA2DF58d20CE688Fd3E779;
address constant vAMM_NOTE_cINU = 0xf73628177406aF55Dc6921c38F819c2Ace55f910;
address constant vAMM_NOTE_CRE = 0x8575d59C17c0aF03C49e91037cC1a6e6CB67d57C;
address constant vAMM_WCANTO_GRAV = 0xe5Cb0a1e0be0c17CdE827E0372490D767495D6aF;
address constant vAMM_WCANTO_IBEX = 0xbdc98c219E4eD84BfbE7d356eE8311c55157786A;
address constant vAMM_FLOW_USDT = 0x6f00840f81C41DC2f7C6f81Eb2E3EaeA973DBF5f;
address constant vAMM_ETH_WCANTO = 0x96D976892c6f01Ab5c13E843B38BEe90C2238F03;
address constant vAMM_INJ_NOTE = 0x85748e1441bb8C2C79c45109579221FF18f1596d;
address constant vAMM_NOTE_AKT = 0xE52D071568036DB68934566A18886E0eE6BFdA53;
address constant vAMM_WCANTO_BNB = 0x1f9AdfE106aA6220BCC898AE4B85d6F68d0aDbF5;
address constant vAMM_multiBTC_FLOW = 0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062;
address constant vAMM_fBOMB_FLOW = 0x42E3294D7095e830359EF9bAbEcD478e9Aa79f3F;
address constant vAMM_USDC_USDT = 0x1Bc3232FF3cA851d4aAfcF1dB40C63794Ee06dec;
address constant vAMM_FLOW_SOMM = 0xaC2C49a475C8d3b79FBA2eBaFCB11eC45B271680;
address constant vAMM_OSMO_NOTE = 0xaa5dA094074d25CF09D823A08530c04ce2F00892;
address constant vAMM_NOTE_CRE8R = 0xa15EFE39f030Db4261c8cE3420A04e6ffb48F43A;
address constant vAMM_ETH_fBOMB = 0x2ac9325E28DbF44b1F78dF9028bfe71750113b3F;
address constant vAMM_CBONK_WCANTO = 0x7A184021B591f948247d6ca4213F6586Ea00C650;
address constant vAMM_NOTE_WCANTO = 0xB06eD5FE7C94467450a163D63F352F4A8F7eAa71;
address constant vAMM_multiBTC_WCANTO = 0x582A99ED86a3d9b9AA8Aff5AdcceEE6f38e1c22A;
address constant vAMM_WBTC_ETH = 0xa2f7ecE2f2A0ffd24889223dE9a8D8F4F8E3943F;
address constant sAMM_WBTC_multiBTC = 0x1F20056B539366909c702bb93e1c65ED2878C9e2; 
       
       
        address[] private all = [
vAMM_multiBTC_USDT , 
vAMM_cINU_WCANTO , 
vAMM_TAROT_USDC , 
vAMM_NOTE_multiBTC , 
vAMM_USDC_WCANTO , 
vAMM_NOTE_IBEX , 
vAMM_ETH_FLOW , 
vAMM_FLOW_CRE8R , 
vAMM_ETH_CRE8R , 
vAMM_FLOW_ATOM , 
vAMM_NOTE_SOMM , 
vAMM_BIFI_WCANTO , 
sAMM_BUSD_NOTE , 
vAMM_cINU_FLOW , 
vAMM_ACS_USDC , 
vAMM_WCANTO_FLOW , 
vAMM_INJ_FLOW , 
vAMM_NOTE_FLOW , 
vAMM_WCANTO_CRE8R , 
vAMM_USDC_FLOW , 
sAMM_NOTE_USDC , 
vAMM_WCANTO_SOMM , 
sAMM_acsFLOW_FLOW , 
vAMM_INJ_WCANTO , 
vAMM_cINU_multiBTC , 
vAMM_ETH_multiBTC , 
vAMM_WCANTO_ATOM , 
sAMM_USDC_USDT , 
vAMM_NOTE_cINU , 
vAMM_NOTE_CRE , 
vAMM_WCANTO_GRAV , 
vAMM_WCANTO_IBEX , 
vAMM_FLOW_USDT , 
vAMM_ETH_WCANTO , 
vAMM_INJ_NOTE , 
vAMM_NOTE_AKT , 
vAMM_WCANTO_BNB ,  
vAMM_multiBTC_FLOW , 
vAMM_fBOMB_FLOW , 
vAMM_USDC_USDT , 
vAMM_FLOW_SOMM , 
vAMM_OSMO_NOTE , 
vAMM_NOTE_CRE8R , 
vAMM_ETH_fBOMB , 
vAMM_CBONK_WCANTO , 
vAMM_NOTE_WCANTO , 
vAMM_multiBTC_WCANTO , 
vAMM_WBTC_ETH , 
sAMM_WBTC_multiBTC  	 
        ];

        uint256[] spread = [
                ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, 
                ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, 
                ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, 
                ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, 
                ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE, ONE
        ];

    function run() external {
        uint256 votePrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(votePrivateKey);
        Voter voter = Voter( 0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

        voter.vote(377, all, spread);
        // voter.poke(377);

        vm.stopBroadcast();
    }

}
