// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    # Feature
    - 1.deposit
    - 2.withdraw
    - 3.transfer
 */

/// @title Bank Demo
/// @author Mulander
contract bank_demo {
    uint256 public tol;
    string public bankName;
    mapping(address => uint256) balances;

    constructor(string memory _name) {
        bankName = _name;
    }

    modifier positiveNum(uint256 _amount) {
        require(_amount > 0, "amount should lg than 0");
        _;
    }

    function deposit(uint256 _amount) public payable positiveNum(_amount) {
        require(msg.value == _amount, "amount should equal amount");
        balances[msg.sender] += _amount;
        tol += _amount;
        require(tol == address(this).balance, "tol and balance not match");
    }

    function withdraw(uint256 _amount) public payable positiveNum(_amount) {
        require(balances[msg.sender] >= _amount, "amount is not enough");
        balances[msg.sender] -= _amount;
        tol -= _amount;
        payable(msg.sender).transfer(_amount);
        require(tol == address(this).balance, "tol and balance not match");
    }

    function transfer(
        address _to,
        uint256 _amount
    ) public positiveNum(_amount) {
        require(balances[msg.sender] >= _amount, "amount is not enough");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function balanceOf(address _who) public view returns (uint256) {
        return balances[_who];
    }
}
