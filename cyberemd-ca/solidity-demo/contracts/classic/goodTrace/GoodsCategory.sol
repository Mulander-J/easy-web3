// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Good.sol";

contract GoodsCategory {
    struct GoodsData {
        Goods goodsIns;
        bool isExists;
    }
    bytes10 categoryId;
    mapping(uint256 => GoodsData) goodsIds;

    event NewGoods(address _operator, uint256 _goodsId);

    modifier HasGoods(uint256 _goodsId) {
        require(goodsIds[_goodsId].isExists, "_goodsId not exists");
        _;
    }

    constructor(bytes10 _categoryId) {
        categoryId = _categoryId;
    }

    function newGoods(uint256 _goodsId) public returns (Goods) {
        require(!goodsIds[_goodsId].isExists, "_goodsId exists");

        goodsIds[_goodsId].isExists = true;

        Goods _goods = new Goods(_goodsId);
        goodsIds[_goodsId].goodsIns = _goods;

        emit NewGoods(tx.origin, _goodsId);

        return _goods;
    }

    function getGoodsData(
        uint256 _goodsId
    ) public view HasGoods(_goodsId) returns (Goods) {
        return goodsIds[_goodsId].goodsIns;
    }

    function getTraces(
        uint256 _goodsId
    ) public view HasGoods(_goodsId) returns (Goods.TraceLog[] memory) {
        return goodsIds[_goodsId].goodsIns.getTraces();
    }

    function setStatus(
        uint256 _goodsId,
        uint8 _status,
        string memory _remark
    ) public HasGoods(_goodsId) returns (bool) {
        return goodsIds[_goodsId].goodsIns.updateStatus(_status, _remark);
    }

    function getStatus(
        uint256 _goodsId
    ) public view HasGoods(_goodsId) returns (uint8) {
        return goodsIds[_goodsId].goodsIns.getNowStatus();
    }
}
