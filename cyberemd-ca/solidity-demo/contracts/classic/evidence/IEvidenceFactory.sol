// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface  IEvidenceFactory {
    function valid (address) external returns(bool);
    function getSigner (uint256) external returns(address);
    function getSignersLen () external returns(uint256);
}