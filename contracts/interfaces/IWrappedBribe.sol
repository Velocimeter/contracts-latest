// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

interface IWrappedBribe {
    function notifyRewardAmount(address token, uint amount) external;
    function updateRewardAmount(address[] memory tokens) external;
}
