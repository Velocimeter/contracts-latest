// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IFlow} from "contracts/interfaces/IFlow.sol";
import {AutoBribe} from "contracts/AutoBribe.sol";

contract AutoBribeDeploy is Script {
    // token addresses
    address private constant FLOW = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
    address private constant TEAM_MULTI_SIG = 0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51;
    address private constant EOA = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;

    // xx_wrapped_bribe contracts
    address private constant wCanto_flow = 0x9F36475D908b0dc69132b286Fe2d81FE18e69dA1;
    address private constant note_flow = 0xbf819513BDE355B3f93C21181D1bc28F856886f0;
    address private constant eth_flow = 0x39890f4B8B3Dda42B3e7534A5e621F1f8C06f2C9;
    address private constant usdc_flow = 0x8b8E41196E00C7EDBA79Fc5431951f9E387769ea;
    address private constant eth_cre8r = 0x039A01e600BC54bcc16c29041383eFd18121605B;
    address private constant cizza_wCanto = 0xe36e26c9b62587c718c10F5060F20d56D51143Eb;
    address private constant usdPLUS_wCanto = 0x9172605fedc6ff47dfa2364dcd7842b4069a62c7;

    address private constant wCanto_Colin = 0xDC0224171b614854dC32c242099A217479e1ddE6;

    //TODO: Both these should be set BEFORE run()
    address private constant WRAPPED_BRIBE = usdPLUS_wCanto; // TODO: change wrapped bribe address
    string private constant name = "USD+_WCANTO_Autobribe"; // give the contract a unique name
    address private constant PROJECT; //supply the projects wallet address here

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        uint256 csrNftId = IFlow(FLOW).csrNftId();
        AutoBribe autoBribe = new AutoBribe(
            WRAPPED_BRIBE,
            EOA,
            csrNftId,
            name
        );

        // autoBribe.initProject(PROJECT);
        // autoBribe.transferOwnership(TEAM_MULTI_SIG);

        vm.stopBroadcast();
    }
}



