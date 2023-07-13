// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Login {
    // Each bytes32 variable would occupy one slot
    // because bytes32 variable has 256 bits(32*8)
    // which is the size of one slot

    // Slot 0
    bytes32 private username;
    // Slot 1
    bytes32 private password;
    // Slot2
    uint32 private num2 = 2;
    // Slot3
    uint256 private num3 = 3;
    // Slot4
    uint32 private num4 = 4;
    // Slot4
    uint32 private num5 = 5;

    constructor(bytes32 _username, bytes32 _password) {
        username = _username;
        password = _password;
    }
}