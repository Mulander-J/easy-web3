// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Goods {
    struct TraceLog {
        address operator;
        uint256 timestamp;
        uint8 status;
        string remark;
    }
    uint8 constant STATUS_CREATE = 0;
    uint8 nowStatus;
    uint256 goodsId;
    TraceLog[] traces;

    event NewStatus(address _operator, uint256 _timestamp, uint8 _status);

    constructor(uint256 _goodsId) {
        goodsId = _goodsId;
        updateStatus(STATUS_CREATE, "create");
    }

    function updateStatus(uint8 _status, string memory _remark) public returns(bool){
        nowStatus = _status;
        traces.push(TraceLog(tx.origin, block.timestamp, _status, _remark));
        emit NewStatus(tx.origin, block.timestamp, _status);
        return true;
    }

    function getNowStatus () public view returns(uint8) {
        return nowStatus;
    }

    function getTraces() public view returns (TraceLog[] memory) {
        return traces;
    }
}
