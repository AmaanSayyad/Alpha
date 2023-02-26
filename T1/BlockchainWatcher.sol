pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BlockchainWatcher is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 constant NUM_ADDRESSES = 100;
    uint256 constant MAX_LISTEN_BLOCKS = 100;
    uint256 constant LISTEN_INTERVAL_SECONDS = 10;

    EnumerableSet.AddressSet private _addresses;
    uint256 private _lastBlockNumber;

    event AddressAdded(address indexed account);
    event AddressRemoved(address indexed account);
    event TransactionReceived(address indexed from, address indexed to, uint256 value, uint256 blockNumber);

    constructor() Ownable() {}

    function addAddress(address account) external onlyOwner {
        require(_addresses.length() < NUM_ADDRESSES, "Too many addresses");
        require(!_addresses.contains(account), "Address already added");
        _addresses.add(account);
        emit AddressAdded(account);
    }

    function removeAddress(address account) external onlyOwner {
        require(_addresses.contains(account), "Address not found");
        _addresses.remove(account);
        emit AddressRemoved(account);
    }

    function checkTransactions() external onlyOwner {
        uint256 latestBlockNumber = block.number;
        if (latestBlockNumber <= _lastBlockNumber) {
            return;
        }
        uint256 fromBlockNumber = _lastBlockNumber + 1;
        if (latestBlockNumber - fromBlockNumber >= MAX_LISTEN_BLOCKS) {
            fromBlockNumber = latestBlockNumber - MAX_LISTEN_BLOCKS + 1;
        }
        for (uint256 i = fromBlockNumber; i <= latestBlockNumber; i++) {
            for (uint256 j = 0; j < _addresses.length(); j++) {
                address toAddress = _addresses.at(j);
                bytes memory data = abi.encodeWithSelector(IERC20(address(0)).transferFrom.selector, _msgSender(), toAddress, 1);
                (bool success, bytes memory result) = address(this).call(data);
                if (success) {
                    emit TransactionReceived(_msgSender(), toAddress, 1, i);
                }
            }
        }
        _lastBlockNumber = latestBlockNumber;
    }
}
