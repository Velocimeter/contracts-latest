// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";


contract KillGauges is Script { 

//pairs
address constant AGG_sCANTO =  0x5c87D41bc9Ac200a18179Cc2702D9Bb38c27d8fE;
address constant AGG_wCANTO  = 0x16fB6c0203d85ab1a1c17E0BC6513e75B5931557;
address constant wCANTO_TAROT  = 0x744c6f8abe326417D2b0e70d283889833eeAF029;
address constant ETH_multiBTC  = 0x1D4E33e07ddf9cc8EDB204102c3238b6A2c0e3fb;
address constant sCANTO_CRE8R  = 0x0df8eC4046b0ca072a3318d793C05f87E9C76d25;
address constant wCANTO_CRE8R  = 0x7392c47d48b3794344500Ca4c61A824e13FA8693;
address constant NOTE_multiBTC  = 0xe86F5A4634966e434f54Af4B598417dB0BA524E7;
address constant ACS_USDC  = 0x5cEd6533Ed0AefdC8D2761d1F6d3868889BAaBa1;
address constant multiBTC_USDT  = 0x69aE6BE12B5A3E62D1713F6ddd6ce990964beBb9;
address constant NOTE_CRE8R  = 0xa15EFE39f030Db4261c8cE3420A04e6ffb48F43A;
address constant IBEX_NOT  = 0xB4FDDc1Df9CCA17e26328316e94C9099aCbd3bF8;
address constant CRE8R_FLOW = 0xD622BE04Bc6c129EAa3915E33863c94123705678;
address constant ETH_CRE8R = 0x237F9c6d2BBeAcc91049710ac47e3eAc83cDC55c;
address constant cINU_multiBTC = 0x4a0b21b17285d38f09005dDab39438e11FdfDfDD;
address constant wBTC_multiBTC = 0x1F20056B539366909c702bb93e1c65ED2878C9e2;
address constant PEPE_wCANTO = 0x228183e6C336CA5F7142b4F6a2538E3a5db97582;
address constant multiBTC_wCANTO = 0x582A99ED86a3d9b9AA8Aff5AdcceEE6f38e1c22A;
address constant multiBTC_FLOW = 0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062;

mapping(uint256 => address) pairs;
mapping(address => address) gauges;

    function makePairs() internal {

        pairs[1] =  AGG_sCANTO ;
        pairs[2] =  AGG_wCANTO  ;
        pairs[3] =  wCANTO_TAROT  ;
        pairs[4] =  ETH_multiBTC  ;
        pairs[5] =  sCANTO_CRE8R  ;
        pairs[6] =  wCANTO_CRE8R  ;
        pairs[7] =  NOTE_multiBTC  ;
        pairs[8] =  ACS_USDC  ;
        pairs[9] =  multiBTC_USDT  ;
        pairs[10] =  NOTE_CRE8R  ;
        pairs[11] =  IBEX_NOT  ;
        pairs[12] =  CRE8R_FLOW ;
        pairs[13] =  ETH_CRE8R ;
        pairs[14] =  cINU_multiBTC ;
        pairs[15] =  wBTC_multiBTC ;
        pairs[16] =  PEPE_wCANTO ;
        pairs[17] =  multiBTC_wCANTO ;
        pairs[18] =  multiBTC_FLOW ;
    }

    function makeGauges() internal {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
        gauges[AGG_sCANTO] = voter.gauges(AGG_sCANTO);
        gauges[AGG_wCANTO] = voter.gauges(AGG_wCANTO);
        gauges[wCANTO_TAROT] = voter.gauges(wCANTO_TAROT);
        gauges[ETH_multiBTC] = voter.gauges(ETH_multiBTC);
        gauges[sCANTO_CRE8R] = voter.gauges(sCANTO_CRE8R);
        gauges[wCANTO_CRE8R] = voter.gauges(wCANTO_CRE8R);
        gauges[NOTE_multiBTC] = voter.gauges(NOTE_CRE8R);
        gauges[ACS_USDC] = voter.gauges(ACS_USDC);
        gauges[multiBTC_USDT] = voter.gauges(multiBTC_USDT);
        gauges[NOTE_CRE8R] = voter.gauges(NOTE_CRE8R);
        gauges[IBEX_NOT] = voter.gauges(IBEX_NOT);
        gauges[CRE8R_FLOW] = voter.gauges(CRE8R_FLOW);
        gauges[ETH_CRE8R] = voter.gauges(ETH_CRE8R);
        gauges[cINU_multiBTC] = voter.gauges(cINU_multiBTC);
        gauges[wBTC_multiBTC] = voter.gauges(wBTC_multiBTC);
        gauges[PEPE_wCANTO] = voter.gauges(PEPE_wCANTO);
        gauges[multiBTC_wCANTO] = voter.gauges(multiBTC_wCANTO);
        gauges[multiBTC_FLOW] = voter.gauges(multiBTC_FLOW);

    }

    function run() external {
        uint256 PrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);

        makePairs();
        makeGauges();
        uint256 currentPair = 1;
        uint256 maxPair = 18;
        while (currentPair <= maxPair){

            address gauge = gauges[pairs[currentPair]];    
            console2.log(gauge);
            _killGauges(gauge);
            currentPair++;
        }

        vm.stopBroadcast();
    }


    function _killGauges(address _gauge) private {
        Voter voter = Voter(0xC5B58aE761a77fF16d548dE9b42933c8FBfe4c33);
        if (voter.isAlive(_gauge) == true){
            voter.killGauge(_gauge);
            }
    }

    function _isAlive(address _gauge) private view {
        Voter voter = Voter(0xC5B58aE761a77fF16d548dE9b42933c8FBfe4c33);
          bool alive = voter.isAlive(_gauge);
          console2.log(_gauge, "is alive?", alive);
        }
}



