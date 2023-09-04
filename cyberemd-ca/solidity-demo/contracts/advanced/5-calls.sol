// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// 1.slave logic
contract ageSlave {
    uint8 private age;
    function setAge(uint8 _age) external {
        age = _age;
    }
    function getAge() external view returns(uint8) {
        return age;
    }
}
/// 2.slave logic with interface
interface IAgeSlave {
    function setAge(uint8 _age) external;
    function getAge() external view returns(uint8);
}
contract ageSlaveImp is IAgeSlave {
    uint8 private age;
    function setAge(uint8 _age) external {
        age = _age;
    }
    function getAge() external view returns(uint8) {
        return age;
    }
}

/// 1. master-slave upgradable
contract ageMaster {
    address owner;
    ageSlave theAger;

    constructor(address _slaveAddr) {
        owner = msg.sender;
        theAger = ageSlave(_slaveAddr);
    }

    function upgrade(address _slaveAddr) public  {
        require(msg.sender == owner, "only owner");
        theAger = ageSlave(_slaveAddr);
    }

    function setAge(uint8 _age) public {
        theAger.setAge(_age);
    }
    function getAge() external view returns(uint8) {
        return theAger.getAge();
    }
}
/// 2. master-slave upgradable with interface
contract ageMasterImp {
    address owner;
    IAgeSlave theAger;

    constructor(address _slaveAddr) {
        owner = msg.sender;
        theAger = IAgeSlave(_slaveAddr);
    }

    function upgrade(address _slaveAddr) public  {
        require(msg.sender == owner, "only owner");
        theAger = IAgeSlave(_slaveAddr);
    }

    function setAge(uint8 _age) public {
        theAger.setAge(_age);
    }
    function getAge() external view returns(uint8) {
        return theAger.getAge();
    }
}