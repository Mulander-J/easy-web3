// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Good {
    address public currentWinner;
    uint public currentAuctionPrice;

    constructor() {
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice() public payable {
        require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
        (bool sent, ) = currentWinner.call{value: currentAuctionPrice}("");
        if (sent) {
            currentAuctionPrice = msg.value;
            currentWinner = msg.sender;
        }
    }

    // function withdraw() public {
    //     require(msg.sender != currentWinner, "Current winner cannot withdraw");

    //     uint amount = balances[msg.sender];
    //     balances[msg.sender] = 0;

    //     (bool sent, ) = msg.sender.call{value: amount}("");
    //     require(sent, "Failed to send Ether");
    // }
}