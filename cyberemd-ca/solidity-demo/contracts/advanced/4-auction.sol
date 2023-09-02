// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract auction_demo {
    enum AuctionType {
        Free,
        Fixed
    }

    uint8 constant userFee = 90;
    uint8 constant platFormFee = 10;

    bool public isFinished;
    address public seller;
    address public highestBider;
    uint256 public hightestPrice;
    uint256 public endTime;
    uint256 public fixedBid;
    AuctionType public aType;

    address owner;

    event Bid(address from, uint256 price);
    event Win(address from, uint256 price);

    constructor(
        address _seller,
        uint256 _endTime,
        uint256 _fixedBid,
        AuctionType _aType
    ) {
        seller = _seller;
        endTime = _endTime;
        fixedBid = _fixedBid;
        aType = _aType;
        hightestPrice = 0;
        isFinished = false;
    }

    function bid() public payable {
        require(!isFinished, "auction is end");
        require(endTime > block.timestamp, "bit is over time");
        require(msg.value > 0, "value should be positive");

        if (aType == AuctionType.Fixed) {
            require(
                msg.value == (hightestPrice + fixedBid),
                "fixed value not match"
            );
        } else {
            require(msg.value > hightestPrice, "value is lt than bid");
        }

        if (highestBider != address(0)) {
            payable(highestBider).transfer(hightestPrice);
        }

        highestBider = msg.sender;
        hightestPrice = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function close() public payable {
        require(!isFinished, "auction is end");
        require(endTime < block.timestamp, "bit is ongoing");
        require(hightestPrice > 0, "no one bit");

        isFinished = true;

        payable(seller).transfer((hightestPrice * userFee) / 100);
        payable(owner).transfer((hightestPrice * platFormFee) / 100);

        emit Win(highestBider, hightestPrice);
    }
}
