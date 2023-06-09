pragma solidity 0.8.13;

interface IOBLOTR {
    function mint(address to, uint256 value) external;
    function transfer(address to, uint256 value) external returns (bool);
    function withdraw(uint256) external;
}
