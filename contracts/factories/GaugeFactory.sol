// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import 'contracts/interfaces/IGaugeFactory.sol';
import 'contracts/Gauge.sol';
import 'contracts/interfaces/ITurnstile.sol';

contract GaugeFactory is IGaugeFactory {
    address public constant turnstile = 0xEcf044C5B4b867CFda001101c617eCd347095B44;
    address public last_gauge;
    uint256 public immutable csrNftId;

    constructor(uint256 _csrNftId) {
        ITurnstile(turnstile).assign(_csrNftId);
        csrNftId = _csrNftId;
    }
    function createGauge(address _pool, address _external_bribe, address _ve, bool isPair, address[] memory allowedRewards) external returns (address) {
        last_gauge = address(new Gauge(_pool, _external_bribe, _ve, msg.sender, isPair, allowedRewards, csrNftId));
        return last_gauge;
    }
}
