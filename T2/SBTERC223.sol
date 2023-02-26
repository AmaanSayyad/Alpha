pragma solidity ^0.8.0;

import "./ERC223.sol";

contract SBTERC223 is ERC223 {
    string public name = "SBTERC223";
    string public symbol = "SBT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 400000000 * 10**uint(decimals);

    constructor() {
        balances[msg.sender] = totalSupply;
    }
}
