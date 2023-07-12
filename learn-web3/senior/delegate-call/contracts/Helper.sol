// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Helper {
    uint public num;
    uint public num1;
    uint public num2;
    string public str1;

    function setNum(uint _num) public {
        num = _num;
    }

    // under delegatecall this will return empty if origin caller dont have slot3 value
    function getStr() public view returns (string memory) {
        return str1;
    }
}