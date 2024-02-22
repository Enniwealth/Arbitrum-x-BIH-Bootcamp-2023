// SPDX-License-Identifier: MIT

contract NFTMarketplaceV1 {
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256[]) public sellerListings;
    uint256 public listingId;

    constructor() {
        listingId = 0;
    }

    /**
     * @dev List an NFT for sale
     * @param tokenId The ID of the NFT
     * @param price The price of the NFT
     */
    function listNFT(uint256 tokenId, uint256 price) public {
        // Implementation for listing an NFT
        listings[listingId] = Listing(msg.sender, tokenId, price, true);
        sellerListings[msg.sender].push(listingId);
        listingId++;
    }

    /**
     * @dev Buy an NFT
     * @param listingId The ID of the listing
     */
    function buyNFT(uint256 listingId) public payable {
        // Implementation for buying an NFT
        Listing storage listing = listings[listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient funds");

        address seller = listing.seller;
        uint256 tokenId = listing.tokenId;

        delete listings[listingId];
        listing.active = false;

        payable(seller).transfer(msg.value);
        // Assume ERC721 contract is called 'nftContract'
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    /**
     * @dev Withdraw funds from the contract
     */
    function withdraw() public {
        // Implementation for withdrawing funds
        // For simplicity, we assume the owner can withdraw all funds
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
    }
}