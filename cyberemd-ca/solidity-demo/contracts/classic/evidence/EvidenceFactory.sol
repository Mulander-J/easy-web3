// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Evidence.sol";

contract EvidenceFactory is IEvidenceFactory {
    address owner;
    address[] signer;
    mapping (string => address) key_evi;

    event NewEvidence(address indexed c, string _key);

    constructor(address [] memory _singers) {
        owner = msg.sender;
        for (uint i = 0; i < _singers.length; i++) {
            signer.push(_singers[i]);
        }
    }
    function addEvidence (string memory _key, string memory _evi) public {
        Evidence evi = new Evidence(_evi);
        key_evi[_key] = address(evi);
    }
    function sign (string memory _key) public returns(bool){
        address addr = key_evi[_key];
        return Evidence(addr).sign();
    }
    function getIsAllSigned (string memory _key) public returns(bool){
        address addr = key_evi[_key];
        return Evidence(addr).isAllSigned();
    }

    function valid (address _singer) public view returns(bool) {
        for (uint256 i = 0; i < signer.length; i++) {
            if (signer[i] == _singer) return true;
        }
        return false;
    }
    function getSigner (uint256 _index) public view returns(address) {
        if(_index < signer.length) {
            return address(0);
        }
        return signer[_index];
    }
    function getSignersLen () public view returns(uint256){
        return signer.length;
    }
}