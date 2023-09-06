// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibRole {
    struct Role {
        mapping(address => bool) exists;
        mapping(address => string) info;
    }

    function isExist(
        Role storage _role,
        address _addr
    ) internal view returns (bool) {
        if (_addr == address(0)) return false;
        return _role.exists[_addr];
    }

    function addRole(
        Role storage _role,
        address _addr,
        string memory _info
    ) internal returns (bool) {
        if (isExist(_role, _addr)) {
            return false;
        }

        _role.exists[_addr] = true;
        _role.info[_addr] = _info;

        return true;
    }

    function removeRole(
        Role storage _role,
        address _addr
    ) internal returns (bool) {
        if (!isExist(_role, _addr)) {
            return false;
        }

        delete _role.exists[_addr];
        delete _role.info[_addr];

        return true;
    }

    function updateRole(
        Role storage _role,
        address _addr,
        string memory _info
    ) internal returns (bool) {
        if (!isExist(_role, _addr)) {
            return false;
        }

        _role.info[_addr] = _info;

        return true;
    }
}
