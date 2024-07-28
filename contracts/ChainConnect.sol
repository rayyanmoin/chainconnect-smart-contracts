// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.26;
import "./AccountCreation.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error NoPriceForNFS(string status, uint256 price);
error NoBidForBuy(string status, uint256 bidDuration);
error NoDurationBid();
error NoData();

contract ChainConnect is AccountCreation {
    using Strings for uint256;

    struct Post {
        uint256 sellValue;
        uint256 bidDuration;
        string uri;
        uint8 buyStatus;
    }

    struct LastBidInfo{
        address lastBidder;
        uint price;
    }
    // Token Id to lastBidInfo.
    mapping(uint => LastBidInfo) private lastBidInfo;

    //  tokenId to Post .
    mapping(uint => Post) private post;
    mapping(uint => string) private _tokenURIs;
    // tokenID to user's Address.
    mapping(uint => address) public idToOwner;
    uint public tokenId = 1;
    uint public ONE = 1 ether;

    address public owner;

    /**
    1 -> Buyable
    2 -> NFS
    3 -> Biddable
     */

    constructor(
        string memory _name,
        string memory _symbol,
        address _owner
    ) AccountCreation(_name, _symbol) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    function changeOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view virtual override returns (string memory) {
        require(
             _tokenId <= tokenId,
            "ERC721URIStorage: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[_tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(_tokenId);
    }
    //setter functions

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `_tokenId`.
     *
     * Requirements:
     *
     * - `_tokenId` must exist.
     */
    function _setTokenURI(
        uint256 _tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(
            _tokenId <= tokenId,
            "ERC721URIStorage: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function mint(
        uint256 _bidDuration,
        uint8 _status,
        uint256 _price,
        string calldata _metadata,
        string memory _tokenURI
    ) external {
        bytes memory b  = bytes(_tokenURI);

        if (b.length == 0){
            revert NoData();
        }
        if (_status == 2 && _price > 0) {
            revert NoPriceForNFS("Not For Sale",_price);
        }
        if (_status == 1 && _bidDuration > 0) {


            revert NoBidForBuy("No Duration", _bidDuration);
        }
        if (_status == 3 && _bidDuration < 1) {
            revert NoDurationBid();
        }

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        idToOwner[tokenId] = msg.sender;

        post[tokenId] = Post(_price, block.timestamp+_bidDuration, _tokenURI, _status);


        tokenId++;
    }

    function buyPost(uint _postId)external payable{
        
        require(_postId >= 0 && _postId <= tokenId,"Invalid tokenID");
        require(post[_postId].price >= msg.value,"Invalid Price");
        require(post[_postId].status == 1,"Invalid Status");

        (bool sent,) = idToOwner[_postId].call{value:msg.value}("");
        require(sent,"Not sent" );
        _transfer(idToOwner[_postId],msg.sender,_postId);
        idToOwner[_postId] = msg.sender;

    }

    function bid(uint _postId)external payable{
        require(_postId >= 0 && _postId <= tokenId,"Invalid tokenID");
        require(post[_postId].price >= msg.value,"Invalid Price");
        require(post[_postId].status == 3,"Invalid Status");

        require(block.timestamp <=  post[_postId].bidDuration,"bid passed");
        require(msg.sender != lastBidInfo[_postId].lastbidder,"Already Bid");
        
        (bool sent,) = lastBidInfo[_postId].lastBidder.call{value:lastBidInfo[_postId].price}("");
        require(sent,"not sent");
        lastBidInfo[_postId] = LastBidInfo(msg.sender,msg.value);

    }

}
