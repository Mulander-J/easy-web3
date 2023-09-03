// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

contract ERC165 is IERC165 {
    /// @dev You must not set element 0xffffffff to true
    mapping(bytes4 => bool) internal supportedInterfaces;

    constructor() {
        supportedInterfaces[IERC165.supportsInterface.selector] = true;
    }

    function supportsInterface(
        bytes4 interfaceID
    ) external view returns (bool) {
        return supportedInterfaces[interfaceID];
    }
}
