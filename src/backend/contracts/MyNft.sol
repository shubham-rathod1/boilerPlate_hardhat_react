// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNft is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private s_nftId;

    constructor() ERC721("name", "symbol") {}

    function mintNft(string memory _tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        s_nftId.increment();
        uint256 newId = s_nftId.current();

        _safeMint(msg.sender, newId);
        _setTokenURI(newId, _tokenURI);
        return newId;
    }
}
