// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFPot is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    event PotMinted(
        string tokenURI,
        address owner,
        uint256 tokenId
    );

    Counters.Counter private _tokenIdCounter;
    mapping(string => bool) private _mintedUris;

    constructor() ERC721("NFPot", "POT") {}

    function payToMint(address to, string memory uri) public payable {
        require(isMinted(uri) == false, "Already minted");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mintedUris[uri] = true;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit PotMinted(uri, msg.sender, tokenId);
    }

    function isMinted(string memory uri) public view returns (bool) {
        return _mintedUris[uri] == true;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}