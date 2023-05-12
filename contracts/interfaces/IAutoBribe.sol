// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

interface IAutoBribe {
    function deposit(address _bribeToken, uint256 _amount, uint256 _weeks) external;
    function emptyOut() external;
    function balance(address _bribeToken) external view returns (uint);
    function reclockBribeToNow() external;
}
