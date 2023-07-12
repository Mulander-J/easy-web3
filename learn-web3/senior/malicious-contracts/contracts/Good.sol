// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./Helper.sol";

contract Good {
    Helper helper;
    // Helper public helper;
    constructor(address _helper) payable {
        helper = Helper(_helper);
        // helper = new Helper();
    }

    function isUserEligible() public view returns(bool) {
        return helper.isUserEligible(msg.sender);
    }

    function addUserToList() public  {
        helper.setUserEligible(msg.sender);
    }

    fallback() external {}
}