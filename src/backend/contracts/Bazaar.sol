// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Bazaar is ReentrancyGuard {
    address payable public immutable s_commisionAccount;
    uint256 public immutable s_commision;
    uint256 public s_itemCount;

    struct Item {
        uint256 itemId;
        IERC721 nft;
        uint256 nftId;
        uint256 price;
        address payable seller;
        bool sold;
    }
    mapping(uint256 => Item) public items;

    event Listed(
        uint256 itemId,
        address indexed nft,
        uint256 nftId,
        uint256 price,
        address indexed seller
    );

    event Sold(
        uint256 itemId,
        address indexed nft,
        uint256 nftId,
        uint256 price,
        address indexed buyer,
        address indexed seller
    );

    constructor(uint256 _commision) {
        s_commision = _commision;
        s_commisionAccount = payable(msg.sender);
    }

    function createItem(
        IERC721 _nft,
        uint256 _nftId,
        uint256 _price
    ) external nonReentrant {
        require(_price > 0, "price has to be greater than 0");
        s_itemCount++;
        // transfer nft from seller to this market
        _nft.transferFrom(msg.sender, address(this), _nftId);
        items[s_itemCount] = Item(
            s_itemCount,
            _nft,
            _nftId,
            _price,
            payable(msg.sender),
            false
        );
        emit Listed(s_itemCount, address(_nft), _nftId, _price, msg.sender);
    }

    function PurchaseItem(uint256 _itemId) external payable nonReentrant {
        Item storage item = items[_itemId];
        require(_itemId > 0 && _itemId <= s_itemCount, "NFT does not exist");
        require(
            msg.value > item.price,
            "not enough ether to purchase and cover gas fees"
        );
        require(!item.sold, "NFT already sold");

        uint256 bazaarCommison = comission(item);
        uint256 cost = item.price - bazaarCommison;
        //send commission to bazzar;
        (s_commisionAccount).transfer(bazaarCommison);
        //send amount to seller;
        (item.seller).transfer(cost);
        // send nft to buyer;
        (item.nft).transferFrom(address(this), msg.sender, item.nftId);
        item.sold = true;

        uint256 refund = msg.value - item.price;
        refund > 0
            ? payable(msg.sender).transfer(refund)
            : selfdestruct(s_commisionAccount);

        emit Sold(
            _itemId,
            address(item.nft),
            item.nftId,
            item.price,
            msg.sender,
            item.seller
        );
    }

    function comission(Item memory _item) public view returns (uint256) {
        return (_item.price * (s_commision / 100));
    }
}
