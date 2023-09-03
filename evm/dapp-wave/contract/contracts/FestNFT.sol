// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// We need some util functions from openzeppelin.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// plugin for console.
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "../libraries/Base64.sol";

contract FestNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // The source array of words for random pick.
  string[] private festDay = [
    "DEFI DAY", "DEX DAY", "MEME DAY", 
    "NFT DAY", "DAO DAY", "GEMEFI DAY",
    "SOCIALFI DAY","WEB3 DAY","METAVERSE DAY"
  ];
  string[] private currency = [
    "BTC", "ETH", "BNB", "SOL", "USDT", "SAMO"
  ];
  string[] private behavior = [
    "CONCERT", "THEATRE", "BAKERY", "BAR", "BARBER SHOP", "RACECOURSE", "SPACESHIP"
  ];
  string[] private accompany = [
    "BLOOD", "SOUL", "Mate", "STRANAGER", "ALONE"
  ];
  string[] private marker = [
    "METADATA","PLANENT", "ARCHITECTURE", "ANIMAL", "ATOM"
  ];
  // Declare a bunch of colors.
  string[] private moodColors = [
    "RED", "PURPLE", "PINK", "YELLOW", "BLUE", "GREEN", "RAINBOW"
  ];
  // Declare each day of month.
  uint [] private dayInMon = [31,28,31,30,31,30,31,31,30,31,30,31];

  // event NewFestNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("FestNFT", "FEST") {
    console.log("This is my NFT contract. Woah!");
  }
  function contractURI() public view returns (string memory) {
    string memory json = Base64.encode(bytes(string(abi.encodePacked(
      '{"name": "Fest Anniversary"',
      ',"description": "FestNFT is a creative NFT published by Fest DAO. Each item consists of a festival definition and a festival activity, describing human behaviour in the new festival of the web3 era."',
      ',"image": "https://openseacreatures.io/image.png"'
      ',"external_link": "https://openseacreatures.io"}'
      // '"seller_fee_basis_points": 100',
      // '"fee_recipient": ""'
    ))));
    string memory output = string(abi.encodePacked("data:application/json;base64,", json));
    return output;
  }
  function getTotalNFTsMintedSoFar() public view returns(uint){
    return _tokenIds.current();
  }
  function random(string memory input, uint256 max) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input))) % max;
  }
  function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
    uint256 randIndex = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))),sourceArray.length);
    return sourceArray[randIndex];
}
  function getFestDay(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "FEST_DAY", festDay);
  }
  function getBehavior(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "BEHAVIOR", behavior);
  }
  function getAccompany(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "ACCOMPANY", accompany);
  }
  function getMarker(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "MARKER", marker);
  }
  function getColor(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "MOOD_COLORS", moodColors);
  }
  /**
  * TODO zero fix
  */
  function getDate(uint256 tokenId) public view returns (string memory) {
    uint mon = getNums(tokenId, 12);
    uint day = getNums(tokenId, dayInMon[mon]);
    console.log("Mon %d , Day %d", mon, day);
    return string(abi.encodePacked(Strings.toString(mon==0?1:mon), "/", Strings.toString(day==0?1:day)));
  }
  function getCurrency(uint256 tokenId) public view returns (string memory) {
     return pluck(tokenId, "USE_CURRENCY", currency);
  }
  function getNums(uint256 tokenId,uint256 max) public pure returns (uint) {
     return uint(random(string(abi.encodePacked("NUM",tokenId)), max));
  }
  function tokenURI(uint256 tokenId, string memory location) private view returns (string memory) {
    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // data:image/svg+xml;base64,INSERT_YOUR_BASE64_ENCODED_SVG_HERE
    // data:application/json;base64,INSERT_YOUR_BASE64_ENCODED_JSON_HERE
    string[19] memory parts;

    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">';
    
    parts[1] = getFestDay(tokenId);

    parts[2] = '</text><text x="10" y="40" class="base">';

    parts[3] = getDate(tokenId);

    parts[4] = '</text><text x="10" y="60" class="base">';

    parts[5] = getMarker(tokenId);

    parts[6] = '</text><text x="10" y="80" class="base">';

    parts[7] = getColor(tokenId);

    parts[8] = '</text><text x="10" y="100" class="base">';

    parts[9] =  getAccompany(tokenId);

    parts[10] = '</text><text x="10" y="120" class="base">';

    parts[11] = bytes(location).length == 0 ? "metaverse" :location;

    parts[14] = '</text><text x="10" y="140" class="base">';

    string memory _num = Strings.toString(getNums(tokenId, 100));
    string memory _curr = getCurrency(tokenId);

    parts[15] = string(abi.encodePacked(_num, " ", _curr));

    parts[16] = '</text><text x="10" y="160" class="base">';

    parts[17] = getBehavior(tokenId);

    parts[18] = "</text></svg>";

    string memory imageUrl = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
    imageUrl = string(abi.encodePacked(imageUrl, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16], parts[17], parts[18]));

    console.log("\n----------SVG----------");
    console.log(imageUrl);
    console.log("----------SVG----------\n");

    string memory attrArray = string(abi.encodePacked(
      '[{"trait_type": "FestDay", "value": "', parts[1],
      '"},{"trait_type": "Marker", "value":"', parts[5],
      '"},{"trait_type": "Color", "value":"', parts[7],
      '"},{"trait_type": "Behavior", "value":"', parts[17],
      '"},{"trait_type": "Accompany", "value":"', parts[9],
      '"},{"trait_type": "Currency", "value":"', _curr,
      '"},{"trait_type": "Amount", "display_type": "number", "value":', _num,
      '},{"trait_type": "Birthday", "display_type": "date", "value":', Strings.toString(block.timestamp),
      '}]'
    ));

    console.log("\n----------ATTR----------");
    console.log(attrArray);
    console.log("----------ATTR----------\n");

    string memory json = Base64.encode(bytes(string(abi.encodePacked(
      '{"name": "Fest #',Strings.toString(tokenId),
      '", "description": "Define the fest of ', parts[1], '& wrote down what u comsumed.", ',
      // '"background_color":"ffffff",',
      // '"animation_url": "https://openseacreatures.io/3", ', 
      // '"external_url": "https://openseacreatures.io/3", ', 
      // '"youtube_url": "https://openseacreatures.io/3", ', 
      '"attributes":', attrArray,
      ',"image": "data:image/svg+xml;base64,', Base64.encode(bytes(imageUrl)), '"}'
    ))));

    string memory output = string(abi.encodePacked("data:application/json;base64,", json));

    console.log("\n----------URI----------");
    console.log(output);
    console.log("----------URI----------\n");

    return output;
  }
  function mintFest(address to, string memory location) public returns (uint){
    uint256 newItemId = _tokenIds.current();

    _safeMint(to, newItemId);
    
    _setTokenURI(newItemId, tokenURI(newItemId, location));
  
    _tokenIds.increment();

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, to);

    // emit NewFestNFTMinted(msg.sender, newItemId);

    return newItemId;
  }
}