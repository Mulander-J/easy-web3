// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    string ercName;
    string ercSymbol;
    uint8 ercDecimals;
    uint256 ercTotalSupply;

    address owner;

    mapping(address => uint256) ercBalances;
    mapping(address => mapping(address => uint256)) ercAllowances;

    modifier positiveNum(uint256 _value) {
        require(_value > 0, "_value must > 0");
        _;
    }
    modifier validAddr(address _addr) {
        require(address(0) != _addr, "address is zero");
        _;
    }
    modifier enough(address _addr, uint256 _value) {
        require(ercBalances[_addr] >= _value, "balance not enough");
        _;
    }

    constructor(
        string memory _ercName,
        string memory _ercSymbol,
        uint8 _ercDecimals
    ) {
        owner = msg.sender;
        ercName = _ercName;
        ercSymbol = _ercSymbol;
        ercDecimals = _ercDecimals;
    }

    function name() external view returns (string memory) {
        return ercName;
    }

    function symbol() external view returns (string memory) {
        return ercSymbol;
    }

    function decimals() external view returns (uint8) {
        return ercDecimals;
    }

    function totalSupply() external view returns (uint256) {
        return ercTotalSupply;
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return ercBalances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    )
        external
        positiveNum(_value)
        validAddr(_to)
        enough(msg.sender, _value)
        returns (bool success)
    {
        ercBalances[msg.sender] -= _value;
        ercBalances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        external
        positiveNum(_value)
        validAddr(_from)
        validAddr(_to)
        enough(_from, _value)
        returns (bool success)
    {
        require(
            ercAllowances[_from][msg.sender] >= _value,
            "allowance not enough"
        );

        ercBalances[_from] -= _value;
        ercBalances[_to] += _value;
        ercAllowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        success = true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) external positiveNum(_value) validAddr(_spender) returns (bool success) {
        // require(ercBalances[msg.sender] >= _value, "user balance not enough");

        ercAllowances[msg.sender][_spender] += _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256 remaining) {
        remaining = ercAllowances[_owner][_spender];
    }

    function mint (address _to, uint256 _value) public positiveNum(_value)  validAddr(_to) returns(bool) {
        require(msg.sender == owner, "only admin address");
        ercBalances[_to] += _value;
        ercTotalSupply += _value;

        emit Transfer(address(0), _to, _value);

        return true;
    }
}
