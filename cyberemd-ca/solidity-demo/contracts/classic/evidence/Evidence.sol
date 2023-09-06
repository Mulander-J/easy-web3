// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEvidenceFactory {
    function valid(address) external returns (bool);

    function getSigner(uint256) external returns (address);

    function getSignersLen() external returns (uint256);
}

contract Evidence {
    string evidence;
    address factory;
    address[] signed;

    constructor(string memory _evi) {
        require(_isValid(tx.origin), "invalid signer");
        signed.push(tx.origin);
        factory = msg.sender;
        evidence = _evi;
    }

    function _isValid(address _signer) internal returns (bool) {
        return IEvidenceFactory(factory).valid(_signer);
    }

    function getEvidence () public returns (string memory, address[] memory, address[] memory) {
        uint256 len = IEvidenceFactory(factory).getSignersLen();
        address[] memory _signers = new address[](len);
        for (uint256 i = 0; i < len; i++) {
            _signers[i] = IEvidenceFactory(factory).getSigner(i);
        }
        return (evidence, _signers, signed);
    }

    function sign() public returns (bool) {
        require(_isValid(tx.origin), "invalid signer");
        if (isSigned(tx.origin)) {
            return true;
        }
        signed.push(tx.origin);

        return true;
    }

    function isSigned(address _signer) public view returns (bool) {
        for (uint256 i = 0; i < signed.length; i++) {
            if (signed[i] == _signer) return true;
        }
        return false;
    }

    function isAllSigned() public returns (bool) {
        uint256 len = IEvidenceFactory(factory).getSignersLen();
        for (uint256 i = 0; i < len; i++) {
            if (!isSigned(IEvidenceFactory(factory).getSigner(i))) return false;
        }
        return true;
    }
}
