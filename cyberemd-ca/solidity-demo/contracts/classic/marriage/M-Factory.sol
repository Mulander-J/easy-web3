// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./M-Evidence.sol";

contract MarriageFactory {
    mapping(string => address) key_evi;

    function addEvidence(
        string memory _key,
        string memory _evi,
        address _female,
        address _male
    ) public returns (address) {
        MarriageEvidence evi = new MarriageEvidence(_evi, _female, _male);
        address _eviAddr = address(evi);
        key_evi[_key] = _eviAddr;
        return _eviAddr;
    }
    function sign(string memory _key) public returns(bool){
        address addr = key_evi[_key];
        return IMEvidence(addr).sign();
    }
    function getEvidence(string memory _key) public view returns(string memory, address[] memory, address[] memory){
        address addr = key_evi[_key];
        return IMEvidence(addr).getEvidence();
    }
    function isAllSigned(string memory _key) public view returns(bool){
        address addr = key_evi[_key];
        return IMEvidence(addr).isAllSigned();
    }
}
