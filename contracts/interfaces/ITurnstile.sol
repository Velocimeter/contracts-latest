// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.13;

interface ITurnstile {
    function register(address) external returns(uint256);
    function assign(uint256) external returns(uint256);
}