// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GoodsCategory.sol";

contract GoodsFactory {
    struct CategoryData {
        GoodsCategory cateIns;
        bool isExists;
    }
    mapping(bytes10 => CategoryData) goodsCateIds;

    event NewCategory(address _operator, bytes10 _categoryId);
    event NewGoods(address _operator, uint256 _goodsId);

    modifier HasCategory(bytes10 _categoryId) {
        require(goodsCateIds[_categoryId].isExists, "_categoryId not exists");
        _;
    }

    function genCID(string memory _name) public pure returns (bytes10) {
        return bytes10(keccak256(abi.encode(_name)));
    }

    function newCategory(bytes10 _categoryId) public returns (GoodsCategory) {
        require(!goodsCateIds[_categoryId].isExists, "_categoryId exists");

        goodsCateIds[_categoryId].isExists = true;

        GoodsCategory category = new GoodsCategory(_categoryId);
        goodsCateIds[_categoryId].cateIns = category;

        emit NewCategory(msg.sender, _categoryId);

        return category;
    }

    function getCategory(
        bytes10 _categoryId
    ) public view HasCategory(_categoryId) returns (GoodsCategory) {
        return goodsCateIds[_categoryId].cateIns;
    }

    function newGoods(
        bytes10 _categoryId,
        uint256 _goodsId
    ) public HasCategory(_categoryId) returns (Goods) {
        GoodsCategory category = getCategory(_categoryId);
        Goods _goods = category.newGoods(_goodsId);
        emit NewGoods(msg.sender, _goodsId);
        return _goods;
    }

    function getGoods(
        bytes10 _categoryId,
        uint256 _goodsId
    ) public view HasCategory(_categoryId) returns (Goods) {
        GoodsCategory category = getCategory(_categoryId);
        return category.getGoodsData(_goodsId);
    }

    function getTraces(
        bytes10 _categoryId,
        uint256 _goodsId
    ) public view HasCategory(_categoryId) returns (Goods.TraceLog[] memory) {
        GoodsCategory category = getCategory(_categoryId);
        return category.getTraces(_goodsId);
    }

    function setStatus(
        bytes10 _categoryId,
        uint256 _goodsId,
        uint8 _status,
        string memory _remark
    ) public HasCategory(_categoryId) returns (bool) {
        GoodsCategory category = getCategory(_categoryId);
        return category.setStatus(_goodsId, _status, _remark);
    }

    function getStatus(
        bytes10 _categoryId,
        uint256 _goodsId
    ) public view HasCategory(_categoryId) returns (uint8) {
        GoodsCategory category = getCategory(_categoryId);
        return category.getStatus(_goodsId);
    }
}
