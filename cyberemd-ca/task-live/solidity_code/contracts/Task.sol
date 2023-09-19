// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Task {
    enum TaskStatus {
        Initial,
        Taken,
        Finished,
        Success
    }
    struct TaskData {
        address issuer;
        address taker;
        string intro;
        string comment;
        uint256 bonus;
        uint256 timestamp;
        TaskStatus status;
    }

    address token;
    TaskData[] tasks;
    mapping(address => bool) facuets;
    uint256 constant FAUCET_INIT = 100 ether;

    event NewTask(
        address indexed _issuer,
        uint256 indexed _index,
        string _intro,
        uint256 _bonus
    );
    event TaskUpdate(
        address indexed _operator,
        uint256 indexed _index,
        TaskStatus _status
    );

    modifier exists(uint256 _index) {
        require(_index < tasks.length, "index out of stack");
        _;
    }

    constructor(address _token) {
        token = _token;
    }

    function issue(
        uint256 _bonus,
        string memory _intro
    ) public returns (uint256) {
        require(bytes(_intro).length > 0, "intro is empty");
        require(_bonus > 0, "bonus should > 0");
        require(_bonus <= IERC20(token).balanceOf(msg.sender), "balance not enough");

        TaskData memory task = TaskData(
            msg.sender,
            address(0),
            _intro,
            "",
            _bonus,
            block.timestamp,
            TaskStatus.Initial
        );
        tasks.push(task);
        uint256 index = tasks.length - 1;
        emit NewTask(msg.sender, index, _intro, _bonus);
        return index;
    }

    function take(uint256 _index) public exists(_index) {
        TaskData storage task = tasks[_index];

        require(task.issuer != msg.sender, "issuer can't taken");
        require(task.taker == address(0), "task is taken");
        require(task.status == TaskStatus.Initial, "invalid task status");

        task.taker = msg.sender;
        task.status = TaskStatus.Taken;
        emit TaskUpdate(msg.sender, _index, task.status);
    }

    function commit(uint256 _index) public exists(_index) {
        TaskData storage task = tasks[_index];

        require(task.taker == msg.sender, "invalid taker");
        require(task.status == TaskStatus.Taken, "invalid task status");

        task.status = TaskStatus.Finished;
        emit TaskUpdate(msg.sender, _index, task.status);
    }

    function settled(
        uint256 _index,
        string memory _comment,
        bool _passed
    ) public exists(_index) {
        TaskData storage task = tasks[_index];

        require(task.issuer == msg.sender, "invalid issuer");
        require(task.status == TaskStatus.Finished, "invalid task status");

        task.comment = _comment;
        if (_passed) {
            task.status = TaskStatus.Success;
            IERC20(token).transferFrom(task.issuer, task.taker, task.bonus);
        } else {
            task.status = TaskStatus.Initial;
        }
        emit TaskUpdate(msg.sender, _index, task.status);
    }

    function register(address _to) public {
        require(_to != address(0), "invalid address");
        require(!facuets[msg.sender], "already registered");
        facuets[msg.sender] = true;
        IERC20(token).transfer(_to, FAUCET_INIT);
    }

    function task(uint256 _index) public view exists(_index)  returns(TaskData memory _task) {
        return tasks[_index];
    }
}
