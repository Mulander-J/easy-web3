// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "../interface/IFestNFT.sol";

contract WavePortal {
    struct Layer {
        address owner;
        string name;
        uint256 id;
        uint256 timestamp;
    }
    struct Shape {
        address owner;
        string name;
        uint256 id;
        uint256 timestamp;
    }
    struct Wave {
        address owner;
        string message;
        string geohash;
        bytes32 color;
        uint256 id;
        uint256 shapeId;
        uint256 layerId;
        uint256 timestamp;
    }
    struct UserStat {
        address account;
        uint256 id;
        uint256 timestamp;
        uint256 tolShape;
        uint256 tolWave;
        bool isUsed;
    }
    struct WhiteStat {
        WhiteCondition state;
        uint nftId;
    }
    enum WhiteCondition {
        UnListed,
        Available,
        Used
    }

    address private owner;
    address private festNFT;

    uint256 public maxGift = 5000;

    uint256 public totalLayers;
    uint256 public totalShapes;
    uint256 public totalWaves;
    uint256 public totalUsers;

    uint256 private seed; // random seed
    uint256 private giftAmount = 0.001 ether; // gift amount

    Layer[] public layers;  // get all layer
    Wave[] public waves;   // get all waves

    mapping(address => Shape[]) public shapes;  // get all shapes
    mapping(address => mapping(uint256 => bool)) public shapeMap;
    mapping(address => UserStat) public userMap;
    mapping(uint256 => bool) public layerMap;

    mapping(address => uint256) public lastWavedAt; // the time user lastWavedAt.
    mapping(address => WhiteStat) internal whiteList; // check the user whitelist.
    
    event NewWave(address indexed from, uint256 timestamp, uint256 id);
    event NewGift(address indexed from, uint256 timestamp, uint256 tokenId);
    event NewUser(address indexed from, uint256 timestamp, uint256 id);

    constructor() payable {
        owner = msg.sender;
        addLayer("Earth");
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Yo yo, I am a contract made by Mulander.King");
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Only owner");
         _;
    }
    modifier onlyWhiteList() {
        require(whiteList[msg.sender].state!=WhiteCondition.Used , "Caller is already gifted!");
        require(whiteList[msg.sender].state==WhiteCondition.Available , "Caller is not in the whitelist");
        _;
    }

    function setFestNFT(address _fNft) public onlyOwner{
        festNFT = _fNft;
    }

    function wave(string memory _message, string memory _geohash,bytes32 _color,uint256 _shapeId,uint256 _layerId) public {
         /*
         * We need to make sure the current timestamp is at least 10s bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 10 seconds < block.timestamp,
            "Wait 10s"
        );
        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;
        /*
        * Generate a new seed for the next user that sends a wave
        */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        /*
        * Check LayerId
        */
        require(layerMap[_layerId], "Layer is not exist");
        /*
        * Handle Users
        */
        UserStat memory user =  userMap[msg.sender];
        uint256 _theShapeId = _shapeId;
        if(!user.isUsed){   // New User Come
            totalUsers+=1;
            userMap[msg.sender] = UserStat(msg.sender, totalUsers, block.timestamp, 0, 1,true);
            _theShapeId = addShape("Meta");
            emit NewUser(msg.sender, block.timestamp, totalUsers);
        }else{ 
            require(shapeMap[msg.sender][_theShapeId], "Shape is not exist");
            // if(whiteList[msg.sender]==WhiteCondition.UnListed && user.tolWave>=4 && user.tolShape>=2) {
            if(whiteList[msg.sender].state==WhiteCondition.UnListed && user.tolWave>=2) {
                whiteList[msg.sender].state = WhiteCondition.Available;
                console.log("new gift user %s coming",msg.sender);
            }
            userMap[msg.sender].tolWave+=1;
        }
        /*
        * Handle Waves
        */
        totalWaves += 1;
        waves.push(Wave(msg.sender,_message,_geohash,_color,totalWaves,_theShapeId,_layerId,block.timestamp));
        console.log("%s has waved!", msg.sender);
        emit NewWave(msg.sender, block.timestamp, totalWaves);
    }
    function waveGift(string memory location) external onlyWhiteList{
        seed = (block.difficulty + block.timestamp + seed) % 100;
        /*
        * Give a 50% chance that the user wins the prize.
        */
        require(seed<= 50, "You lost the chance!");
        require(giftAmount <= address(this).balance,"Git Bonouns is ran out!");
        (bool success, ) = (msg.sender).call{value: giftAmount}("");
        require(success, "Gift Withdraw Failed");
        require(festNFT != address(0x0),"NFT-Contract is not exit!");
        uint _tokenId = IFestNFT(festNFT).mintFest(msg.sender, bytes(location).length == 0 ? "metaverse" :location);
        /*
        * Gift only once for each account.
        */
        whiteList[msg.sender].state = WhiteCondition.Used;
        whiteList[msg.sender].nftId = _tokenId;
        emit NewGift(msg.sender, block.timestamp, _tokenId);   
    }
    function addLayer(string memory name) public onlyOwner returns(uint256) {
        totalLayers+=1;
        layerMap[totalLayers] = true;
        layers.push(Layer(msg.sender,name, totalLayers, block.timestamp));
        return totalLayers;
    }
    function addShape(string memory name) public returns(uint256) {
        totalShapes+=1;
        userMap[msg.sender].tolShape+=1;
        shapeMap[msg.sender][totalShapes] = true;
        shapes[msg.sender].push(Shape(msg.sender,name, totalShapes, block.timestamp));
        return totalShapes;
    }
    /**
    * Get Waves/Shaps/Layers
    */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
    function getAllShapes() public view returns (Shape[] memory) {
        return shapes[msg.sender];
    }
    function getAllLayers() public view returns (Layer[] memory) {
        return layers;
    }
    /**
    * Get User
    */
    function getUserStat() public view returns (UserStat memory) {
        return userMap[msg.sender];
    }
    function getWhiteCondition(address _addr) public view returns (WhiteCondition) {
        return whiteList[_addr].state;
    }
    function getWinnerNftId() public view returns (uint) {
        return whiteList[msg.sender].nftId;
    }
    /**
    * Get Totals
    */
    function getTotalLayers() public view returns (uint256) {
        console.log("We have %d total layers!", totalLayers);
        return totalLayers;
    }
    function getTotalShapes() public view returns (uint256) {
        console.log("We have %d total shapes!", totalShapes);
        return totalShapes;
    }
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
    function getTotalUser() public view returns (uint256) {
        console.log("We have %d total users!", totalUsers);
        return totalUsers;
    }
    function getTotalBatch() public view returns (string [] memory, uint256 [] memory) {
        string [] memory  _keys = new string[](4);
        uint256 [] memory  _vals = new uint256[](4);

        _keys[0] = "Layers";
        _keys[1] = "Shapes";
        _keys[2] = "Waves";
        _keys[3] = "Users";

        _vals[0] = totalLayers;
        _vals[1] = totalShapes;
        _vals[2] = totalWaves;
        _vals[3] = totalUsers;

        return (_keys, _vals);
    }
}