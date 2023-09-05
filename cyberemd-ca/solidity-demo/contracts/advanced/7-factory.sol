// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract car_demo {
    address owner;
    string name;

    constructor(string memory _name) {
        owner = msg.sender;
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function setName(string memory _name) public {
        name = _name;
    }
}

contract factory_demo {
    address[] public allCars;

    constructor() {}

    function addCar(string memory _name) public returns (bool) {
        car_demo car = new car_demo(_name);
        if (address(car) != address(0)) {
            allCars.push(address(car));
            return true;
        }
        return false;
    }

    function getName(uint256 _index) public view returns (string memory) {
        require(_index < allCars.length, "_index invalid");
        address carAddr = allCars[_index];
        require(address(0) != carAddr, "address invalid");
        return car_demo(carAddr).getName();
    }
}
