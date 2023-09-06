// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./M-Libaray.sol";

contract MCharacters {
    using LibRole for LibRole.Role;
    LibRole.Role characters;
    address[] allCharas;
    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only onwer");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function isCharacter(address _signer) public view returns (bool) {
        return characters.isExist(_signer);
    }

    function addCharacter(
        address _signer,
        string memory _info
    ) public onlyOwner returns (bool) {
        bool ok = characters.addRole(_signer, _info);
        allCharas.push(_signer);
        return ok;
    }

    function restCharacter(
        address _signer,
        string memory _info
    ) public onlyOwner returns (bool) {
        bool ok = characters.updateRole(_signer, _info);
        uint256 _index;
        for (; _index < allCharas.length; _index++) {
            if (allCharas[_index] == _signer) {
                break;
            }
        }
        if (_index < allCharas.length - 1) {
            allCharas[_index] = allCharas[allCharas.length - 1];
            allCharas.pop();
        } else if (_index == allCharas.length - 1) {
            allCharas.pop();
        }

        return ok;
    }

    function removeCharacter(address _signer) public onlyOwner returns (bool) {
        return characters.removeRole(_signer);
    }
}
