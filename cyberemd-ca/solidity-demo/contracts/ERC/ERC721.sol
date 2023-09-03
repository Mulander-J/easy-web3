// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721TokenReceiver.sol";

contract ERC721 is IERC165, IERC721 {
    /// ERC165
    mapping(bytes4 => bool) supportedInterfaces;
    /// ERC721
    mapping(address => uint256) ercTokenCount;
    mapping(uint256 => address) ercTokenOwner;
    mapping(uint256 => address) ercTokenApproved;
    mapping(address => mapping(address => bool)) ercTokenApprovedForAll;

    using Address for address;

    constructor() {
        // IERC165 interfaceID
        _registerInterface(IERC165.supportsInterface.selector);
        // IERC721 interfaceID
        _registerInterface(0x80ac58cd);
    }

    modifier canTransfer(uint256 _tokenId, address _from) {
        address owner = ercTokenOwner[_tokenId];
        require(owner == _from, "_form is not owner");
        require(
            msg.sender == owner ||
                ercTokenApproved[_tokenId] == msg.sender ||
                ercTokenApprovedForAll[owner][msg.sender],
            "not owner nor approved operator"
        );
        _;
    }

    // **** IERC - 165 **** //
    function _registerInterface(bytes4 interfaceID) internal {
        supportedInterfaces[interfaceID] = true;
    }

    function supportsInterface(
        bytes4 interfaceID
    ) external view returns (bool) {
        require(interfaceID != 0xffffffff, "invalid interfaceID");
        return supportedInterfaces[interfaceID];
    }

    // **** IERC - 721 **** //
    function balanceOf(address _owner) external view returns (uint256) {
        return ercTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return ercTokenOwner[_tokenId];
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return ercTokenApproved[_tokenId];
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return ercTokenApprovedForAll[_owner][_operator];
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        address owner = ercTokenOwner[_tokenId];
        require(
            msg.sender == owner || ercTokenApprovedForAll[owner][msg.sender],
            "not owner nor approved operator"
        );
        ercTokenApproved[_tokenId] = _approved;

        emit Approval(owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        ercTokenApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal canTransfer(_tokenId, _from) {
        /// transfer debt
        ercTokenOwner[_tokenId] = _to;
        ercTokenCount[_from] -= 1;
        ercTokenCount[_to] += 1;
        /// revoke approve
        ercTokenApproved[_tokenId] = address(0);

        emit Transfer(_from, _to, _tokenId);
    }

    function _safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) internal {
        _transferFrom(_from, _to, _tokenId);

        // safe code
        if (_to.isContract()) {
            bytes4 retval = IERC721TokenReceiver(_to).onERC721Received(
                msg.sender,
                _from,
                _tokenId,
                _data
            );
            require(
                retval == IERC721TokenReceiver.onERC721Received.selector,
                "unsupport onERC721Received"
            );
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        _transferFrom(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) external payable {
        _safeTransferFrom(_from, _to, _tokenId, _data);
    }

    function mint(address _to, uint256 _tokenId, bytes memory _data) external {
        require(_to != address(0), "_to is zero address");
        require(
            ercTokenOwner[_tokenId] == address(0),
            "_tokenId already exists"
        );

        ercTokenOwner[_tokenId] = _to;
        ercTokenCount[_to] += 1;

        if (_to.isContract()) {
            bytes4 retval = IERC721TokenReceiver(_to).onERC721Received(
                msg.sender,
                address(0),
                _tokenId,
                _data
            );
            require(
                retval == IERC721TokenReceiver.onERC721Received.selector,
                "unsupport onERC721Received"
            );
        }

        emit Transfer(address(0), _to, _tokenId);
    }
}
