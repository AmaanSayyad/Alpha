// Write a contract compatible to the SBTERC223 contract.

pragma solidity ^0.8.0;

contract ERC223 {
    mapping(address => uint256) public balances;
    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);

    function transfer(address to, uint256 value, bytes memory data) public returns (bool success) {
        if (balances[msg.sender] >= value) {
            balances[msg.sender] -= value;
            balances[to] += value;
            emit Transfer(msg.sender, to, value, data);
            return true;
        }
        return false;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        bytes memory empty;
        return transfer(to, value, empty);
    }
}