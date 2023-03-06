// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {IGovernor} from "openzeppelin-contracts/contracts/governance/IGovernor.sol";
import {IVotes} from "openzeppelin-contracts/contracts/governance/utils/IVotes.sol";

import {L2Governor} from "contracts/governance/L2Governor.sol";
import {L2GovernorCountingSimple} from "contracts/governance/L2GovernorCountingSimple.sol";
import {L2GovernorVotes} from "contracts/governance/L2GovernorVotes.sol";
import {L2GovernorVotesQuorumFraction} from "contracts/governance/L2GovernorVotesQuorumFraction.sol";
import 'contracts/interfaces/ITurnstile.sol';

contract VeloGovernor is
    L2Governor,
    L2GovernorCountingSimple,
    L2GovernorVotes,
    L2GovernorVotesQuorumFraction
{
    address public constant turnstile = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    address public team;
    uint256 public constant MAX_PROPOSAL_NUMERATOR = 50; // max 5%
    uint256 public constant PROPOSAL_DENOMINATOR = 1000;
    uint256 public proposalNumerator = 2; // start at 0.02%

    constructor(IVotes _ve, uint256 _csrNftId)
        L2Governor("Velodrome Governor")
        L2GovernorVotes(_ve)
        L2GovernorVotesQuorumFraction(4) // 4%
    {
        team = msg.sender;
        ITurnstile(turnstile).assign(_csrNftId);
    }

    function votingDelay() public pure override(IGovernor) returns (uint256) {
        return 15 minutes; // 1 block
    }

    function votingPeriod() public pure override(IGovernor) returns (uint256) {
        return 1 weeks;
    }

    function setTeam(address newTeam) external {
        require(msg.sender == team, "not team");
        team = newTeam;
    }

    function setProposalNumerator(uint256 numerator) external {
        require(msg.sender == team, "not team");
        require(numerator <= MAX_PROPOSAL_NUMERATOR, "numerator too high");
        proposalNumerator = numerator;
    }

    function proposalThreshold()
        public
        view
        override(L2Governor)
        returns (uint256)
    {
        return
            (token.getPastTotalSupply(block.timestamp) * proposalNumerator) /
            PROPOSAL_DENOMINATOR;
    }
}
