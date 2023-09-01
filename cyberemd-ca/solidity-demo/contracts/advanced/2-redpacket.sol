// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract redpacket_demo {
    uint256 public tol;
    bool public isArg;
    uint8 public count;
    uint256 part;
    address owner;
    mapping(address => bool) takens;

    constructor(bool _isArg, uint8 _count) payable {
        owner = msg.sender;
        tol = msg.value;
        isArg = _isArg;
        count = _count;
        part = _isArg ? tol / count : 0;
    }

    function getAmount() internal view returns (uint256 _amount) {
        if (isArg) {
            _amount = part;
        } else {
            _amount = count == 1
                ? tol
                : uint(
                    keccak256(
                        abi.encodePacked(block.timestamp, msg.sender, tol)
                    )
                ) % tol;
        }
    }

    function take() public payable {
        require(!checkTaken(msg.sender), "user already taken once");
        require(count > 0, "packets is out");

        uint256 _amount = getAmount();
        count--;
        tol -= _amount;
        takens[msg.sender] = true;
        payable(msg.sender).transfer(_amount);
    }

    function checkTaken(address _who) public view returns (bool) {
        return takens[_who];
    }

    function kill() public payable {
        selfdestruct(payable(owner));
    }
}
