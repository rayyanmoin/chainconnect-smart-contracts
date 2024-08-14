//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

error NoPriceForNFS(string status, uint256 price);
error NoBidForBuy(string status, uint256 bidDuration);
error NoDurationBid();
error NoData();

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function mint(address _to, uint _amount) external;
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

interface IChainConnect {}
event Mint(
    address _user,
    uint256 _bidDuration,
    uint8 _status,
    uint256 _price,
    string _metadata,
    string _tokenURI,
    uint256 indexed _tokenId
);

event RewardClaimed(
    address _user,
    uint _reward,
    uint _claimId,
    uint256 _likes,
    bytes _signature,
    uint256 indexed _tokenId
);
event Bid(address indexed _user, uint256 indexed _postId, uint _bidAmount);
event PostChanged(
    address _user,
    uint256 indexed _tokenId,
    uint256 _sellValue,
    uint256 _bidDuration,
    string _uri,
    uint8 _buyStatus
);
event PostBought(
    address indexed to,
    address indexed _from,
    uint256 indexed _tokenId,
    uint256 _amount
);
event RewardTokenChanged(
    address _owner,
    address indexed _from,
    address indexed _to
);
event OwnerChanged(address oldOwner, address newOwner);
event RewardFactorChanged(
    address _owner,
    uint256 _oldFactor,
    uint256 _newFactor
);
