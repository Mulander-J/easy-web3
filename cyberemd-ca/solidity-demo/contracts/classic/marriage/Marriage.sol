// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./M-Factory.sol";
import "./M-Characters.sol";

contract marriage_demo is MCharacters {
    MarriageFactory eviFactory;

    constructor() {
        addCharacter(msg.sender, "origin verifier");
        eviFactory = new MarriageFactory();
    }

    function issueEvidence(
        string memory _key,
        string memory _evi,
        address _female,
        address _male
    ) public {
        require(isCharacter(msg.sender), "not witness");
        eviFactory.addEvidence(_key, _evi, _female, _male);
    }

    function sign(string memory _key) public returns (bool) {
        return eviFactory.sign(_key);
    }

    function getEvidence(
        string memory _key
    ) public view returns (string memory, address[] memory, address[] memory) {
        return eviFactory.getEvidence(_key);
    }

    function isAllSigned(string memory _key) public view returns (bool) {
        return eviFactory.isAllSigned(_key);
    }
}
