// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
    // mapping(address => bool) facuets;

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
        task.taker = msg.sender;
        task.status = TaskStatus.Taken;
        emit TaskUpdate(msg.sender, _index, task.status);
    }

    function commit(uint256 _index) public exists(_index) {
        TaskData storage task = tasks[_index];
        task.status = TaskStatus.Finished;
        emit TaskUpdate(msg.sender, _index, task.status);
    }

    function settled(
        uint256 _index,
        string memory _comment,
        bool _passed
    ) public exists(_index) {
        TaskData storage task = tasks[_index];
        task.comment = _comment;
        if (_passed) {
            task.status = TaskStatus.Success;
        } else {
            task.status = TaskStatus.Initial;
        }
        emit TaskUpdate(msg.sender, _index, task.status);
    }
}
