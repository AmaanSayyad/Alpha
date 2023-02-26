pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DocumentVerification is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(string => uint8) hashes;

    constructor() public ERC721("DocumentVerification", "DOCV") {}

    function createNFT(string memory tokenURI, string memory documentHash) public returns (uint256) {
        require(hashes[documentHash] != 1, "This document has already been verified");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        hashes[documentHash] = 1;
        return newItemId;
    }

    function getConnectedWalletBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }
}
