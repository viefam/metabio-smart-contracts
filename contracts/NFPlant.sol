// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFPlant is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    using Counters for Counters.Counter;

    event MintFinished(
        string tokenURI,
        address owner,
        uint256 tokenId,
        bool success
    );

    Counters.Counter private _tokenIdCounter;
    uint256 public constant MINT_PRICE = 0.0001 ether;
    address private constant ERC20_TOKEN_ADDRESS = 0x2C8f56E5f468E1708555A9B334D94973509778E2;

    struct requestInfo {
        string tokenURI;
        address owner;
    }

    mapping(bytes32 => requestInfo) private requests;

    IERC20 private token = IERC20(ERC20_TOKEN_ADDRESS);
    uint256 private rewardAmount = 1 * 10 ** decimals();

    constructor() ERC721("NFPlant", "PLT") {}

    function payToMint(address to, string memory uri)
        public
        payable
    {
        require(msg.value >= MINT_PRICE, "Need to pay more");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function updateTokenURI(uint256 tokenId, string memory uri) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner");
        uint256 erc20Balance = token.balanceOf(address(this));
        _setTokenURI(tokenId, uri);
        if (erc20Balance >= rewardAmount) {
            token.transfer(msg.sender, rewardAmount);
        }
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(getBalance());
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

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

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
