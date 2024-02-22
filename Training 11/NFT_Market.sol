// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace is IERC721Receiver {
    using Address for address;
    using Counters for Counters.Counter;

    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256[]) public sellerListings;
    Counters.Counter private _listingIds;

    IERC721 private _nftContract;
    address private _owner;

    event NFTListed(uint256 indexed listingId, address indexed seller, uint256 indexed tokenId, uint256 price);
    event NFTSold(uint256 indexed listingId, address indexed buyer, uint256 indexed tokenId, uint256 price);

    constructor(address nftContractAddress) {
        _nftContract = IERC721(nftContractAddress);
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the owner");
        _;
    }

    function listNFT(uint256 tokenId, uint256 price) public {
        require(_nftContract.ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        require(price > 0, "Price must be greater than zero");

        _listingIds.increment();
        uint256 listingId = _listingIds.current();
        listings[listingId] = Listing(msg.sender, tokenId, price, true);
        sellerListings[msg.sender].push(listingId);

        emit NFTListed(listingId, msg.sender, tokenId, price);
    }

    function buyNFT(uint256 listingId) public payable {
        Listing memory listing = listings[listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient funds");

        _nftContract.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        payable(listing.seller).transfer(msg.value);

        delete listings[listingId];
        emit NFTSold(listingId, msg.sender, listing.tokenId, listing.price);
    }

    function withdraw() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
