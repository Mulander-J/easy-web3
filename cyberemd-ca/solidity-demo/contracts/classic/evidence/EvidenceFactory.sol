// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Evidence.sol";

contract EvidenceFactory is IEvidenceFactory {
    address owner;
    address[] signer;
    mapping(string => address) key_evi;

    event NewEvidence(address indexed _issuer, address _eviAddr, string _key);
    event Sign(address indexed _signer, string _key);

    constructor(address[] memory _singers) {
        owner = msg.sender;
        for (uint i = 0; i < _singers.length; i++) {
            signer.push(_singers[i]);
        }
    }

    function addEvidence(
        string memory _key,
        string memory _evi
    ) public returns (address) {
        Evidence evi = new Evidence(_evi);
        address _eviAddr = address(evi);
        key_evi[_key] = _eviAddr;
        emit NewEvidence(msg.sender, _eviAddr, _key);
        return _eviAddr;
    }

    function sign(string memory _key) public returns (bool) {
        address addr = key_evi[_key];
        emit Sign(msg.sender, _key);
        return Evidence(addr).sign();
    }

    function getEvidence(
        string memory _key
    ) public view returns (string memory, address[] memory, address[] memory) {
        address addr = key_evi[_key];
        return Evidence(addr).getEvidence();
    }

    function getIsAllSigned(string memory _key) public view returns (bool) {
        address addr = key_evi[_key];
        return Evidence(addr).isAllSigned();
    }

    function valid(address _singer) public view returns (bool) {
        if (signer.length == 0) return true;
        for (uint256 i = 0; i < signer.length; i++) {
            if (signer[i] == _singer) return true;
        }
        return false;
    }

    function getSigner(uint256 _index) public view returns (address) {
        if (_index >= signer.length) {
            return address(0);
        }
        return signer[_index];
    }

    function getSignersLen() public view returns (uint256) {
        return signer.length;
    }
}
