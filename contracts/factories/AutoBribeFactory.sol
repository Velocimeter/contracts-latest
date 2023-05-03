// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AutoBribe} from "contracts/AutoBribe.sol";
import "contracts/interfaces/ITurnstile.sol";

contract AutoBribeFactory {
    address public constant TURNSTILE =
        0xEcf044C5B4b867CFda001101c617eCd347095B44;
    uint256 public immutable csrNftId;
    address public immutable team;
    address public immutable wBribeFactory;

    constructor(address _team, address _wBribeFactory, uint256 _csrNftId) {
        team = _team;
        wBribeFactory = _wBribeFactory;
        ITurnstile(TURNSTILE).assign(_csrNftId);
        csrNftId = _csrNftId;
    }

    function createAutoBribe(
        address wbribe,
        string memory name
    ) external returns (address auto_bribe) {
        require(wbribe != address(0), "Wrapped bribe not yet created");
        auto_bribe = address(new AutoBribe(wbribe, team, csrNftId, name));
    }
}
