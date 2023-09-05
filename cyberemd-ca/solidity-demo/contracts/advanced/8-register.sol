// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct ContractInfo {
    address publisher;
    address addr;
    string version;
}

contract register_demo {
    address owner;
    mapping(string => ContractInfo) contracts;

    constructor() {
        owner = msg.sender;
    }

    function register(
        string memory _key,
        address _addr,
        string memory _ver
    ) public returns (bool) {
        if (address(0) == contracts[_key].publisher) {
            contracts[_key].publisher = msg.sender;
        }
        contracts[_key].addr = _addr;
        contracts[_key].version = _ver;
        return true;
    }

    function getInfo(
        string memory _key
    ) public view returns (ContractInfo memory) {
        return contracts[_key];
    }
}
