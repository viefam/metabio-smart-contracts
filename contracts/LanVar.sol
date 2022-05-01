// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract LanVar is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, ChainlinkClient {
    using Counters for Counters.Counter;
    using Chainlink for Chainlink.Request;

    event MintFinished(string tokenURI, address owner, uint256 tokenId, bool success);

    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 10000000;
    uint256 public constant MINT_PRICE = 1000000000000000;

    struct requestInfo {
        string tokenURI;
        address owner;
    }

    mapping (bytes32 => requestInfo) private requests;

    IERC20 private token =  IERC20(0x2C8f56E5f468E1708555A9B334D94973509778E2);
    uint256 private rewardAmount = 1 * 10 ** 18;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor() ERC721("LanVar", "LVN") {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function payToMint(address to, string memory uri) public payable returns (bytes32 requestId) {
        require (totalSupply() < MAX_SUPPLY, "Max supply reached");
        require (msg.value >= MINT_PRICE, "Need to pay more");

        // Verify using chainlink API request
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        requestInfo memory _request = requestInfo({
        owner: to,
        tokenURI: uri
        });

        // Set the URL to perform the GET request on
        request.add("get", string.concat("http://stag-proxy.viefam.com/tokenURI/", uri));
        request.add("path", "result");

        // Sends the request
        bytes32 _requestId = sendChainlinkRequestTo(oracle, request, fee);
        // Store request info
        requests[_requestId] = _request;

        return _requestId;
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _mintable) public recordChainlinkFulfillment(_requestId)
    {
        requestInfo memory _request = requests[_requestId];
        if (_mintable > 0) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(_request.owner, tokenId);
            _setTokenURI(tokenId, _request.tokenURI);
            emit MintFinished(_request.tokenURI, _request.owner, tokenId, true);
        } else {
            emit MintFinished(_request.tokenURI, _request.owner, 0, false);
        }
    }

    function updateTokenURI(uint256 tokenId, string memory uri) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner");
        uint256 erc20Balance = token.balanceOf(address(this));
        _setTokenURI(tokenId, uri);
        if (erc20Balance >= rewardAmount) {
            token.transfer(msg.sender, rewardAmount);
        }
    }

    function getBalance() public onlyOwner view returns (uint256) {
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