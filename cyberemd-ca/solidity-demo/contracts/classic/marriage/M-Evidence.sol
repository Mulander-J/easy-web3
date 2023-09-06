// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMEvidence {
    function isValid(address) external view returns (bool);

    function isAllSigned() external view returns (bool);

    function getEvidence()
        external
        view
        returns (string memory, address[] memory, address[] memory);

    function sign() external returns (bool);
}

contract MarriageEvidence is IMEvidence {
    string evidence;
    address[] signers;
    address[] signed;

    event NewEvidence(address indexed _issuer, address _female, address _male);
    event Sign(address indexed _singer);

    modifier notZero(address _addr) {
        require(address(0) != _addr, "invalid zero addreess");
        _;
    }

    constructor(
        string memory _evi,
        address _female,
        address _male
    ) notZero(_female) notZero(_male) {
        require(_female != tx.origin, "sender can't be verifier");
        require(_male != tx.origin, "sender can't be verifier");
        signed.push(tx.origin);
        signers.push(tx.origin);
        signers.push(_female);
        signers.push(_male);
        evidence = _evi;

        emit NewEvidence(tx.origin, _female, _male);
    }

    function getEvidence()
        external
        view
        returns (string memory, address[] memory, address[] memory)
    {
        return (evidence, signed, signed);
    }

    function _isValid(address _signer) internal view returns (bool) {
        if (signers.length == 0) return true;
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == _signer) return true;
        }
        return false;
    }

    function isValid(address _signer) external view returns (bool) {
        return _isValid(_signer);
    }

    function isSigned(address _signer) internal view returns (bool) {
        for (uint256 i = 0; i < signed.length; i++) {
            if (signed[i] == _signer) {
                return true;
            }
        }
        return false;
    }

    function isAllSigned() external view returns (bool) {
        for (uint256 i = 0; i < signers.length; i++) {
            if (!isSigned(signers[i])) return false;
        }
        return true;
    }

    function sign() external returns (bool) {
        require(_isValid(tx.origin), "invalid signer");
        if (isSigned(tx.origin)) {
            return true;
        }
        signed.push(tx.origin);
        emit Sign(tx.origin);
        return true;
    }
}
