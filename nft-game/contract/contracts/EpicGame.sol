// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Util we use to log infos.
import "hardhat/console.sol";

// Helper we wrote to encode in Base64.
import "../libraries/Base64.sol";

contract EpicGame is ERC721, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    struct CharacterAttr {
        string name;
        string imageURI;
        string intro;
        uint256 characterId;
    }
    struct PlayerAttr {
        uint256 hp;
        uint256 maxHp;
        uint256 critical;
        uint256 miss;
        uint256 attack;
        uint256 heal;
        uint256 characterId;
    }
    enum Instruct {
        Attack,
        Heal,
        Secret
    }
    enum AttackState {
        Normal,
        Miss,
        Critical
    }
    enum SecretType {
        Boss,
        Armor,
        Blood,
        Reborn
    }
    Counters.Counter private _tokenIds;
    Counters.Counter public _generation;
    uint256 constant _bossMaxHP = 1e3;
    uint256 constant _heroMaxHP = 200;
    uint256 constant _bossDamage = 200 / 4;
    uint256 constant _heroDamage = 200 / 4 / 2;
    uint256 public _round;
    CharacterAttr[] public charList;
    PlayerAttr[] public playerList;
    PlayerAttr public genesisBoss;
    mapping(address => uint256) public nftHolderIndex;
    event CharacterNFTMinted(address sender,uint256 tokenId,uint256 charIndex);
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp, AttackState state, uint256 round);
    constructor(
        string[] memory _name,
        string[] memory _imageURIs,
        string[] memory _intros
    ) ERC721("Hikarian", "HKR") {
        for (uint8 i = 0; i < _name.length; i += 1) {
            charList.push(CharacterAttr(_name[i],_imageURIs[i],_intros[i],i));
        }
        genesisBoss = PlayerAttr({
            characterId: 0x0,
            hp: _bossMaxHP,
            maxHp: _bossMaxHP,
            critical: 50,
            miss: 50,
            attack: _bossDamage,
            heal: _bossDamage
        });
        _tokenIds.increment();
        _generation.increment();
    }
    function updateChar (uint charId, string memory _name, string memory _imageURI,string memory _intro) public onlyOwner {
        require(charList.length>0, "Characters are uninitialed.");
        require(charId<charList.length, "CharacterId is not exited.");
        CharacterAttr storage c = charList[charId];
        c.name = _name;
        c.imageURI = _imageURI;
        c.intro = _intro;
        // console.log("CharacterId %s Updated. Name: %s | Intro %s.", charId, _name, _intro);
    }
    function random(string memory keyPrefix, uint256 max) internal view returns (uint256) {
      return uint256(keccak256(abi.encodePacked(keyPrefix, block.timestamp))) % max;
    }
    function mintCharacterNFT(uint256 _characterIndex) external {
        require(_characterIndex>0 && _characterIndex<charList.length,"CharacterId is not existed.");
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        nftHolderIndex[msg.sender] = newItemId;
        playerList.push(PlayerAttr({
            hp: _heroMaxHP,
            maxHp: _heroMaxHP,
            critical: random("CRITICAL", 20),
            miss: random("MISS", 20),
            attack: random("ATTAK", _heroDamage),
            heal: random("HEAL", _heroDamage),
            characterId: _characterIndex
        }));
        // console.log("Minted NFT tokenId %s and characterIndex %s",newItemId,_characterIndex);
        _tokenIds.increment();
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        PlayerAttr memory _player = playerList[_tokenId.sub(1)];
        CharacterAttr memory _char = charList[_player.characterId];
        string[16] memory parts;
        parts[0x0] = string(abi.encodePacked(
            '{"name": "', _char.name,
            ' -- NFT #: ', Strings.toString(_tokenId),
            '", "description": "', _char.intro,
            '" ,"image": "ipfs://', _char.imageURI
        ));
        parts[1] = '", "attributes": [ { "trait_type": "Health Points", "value": ';
        parts[2] = Strings.toString(_player.hp);
        parts[3] =  ', "max_value":';
        parts[4] =  Strings.toString(_player.maxHp);
        parts[5] =  '}, { "trait_type": "Attack Damage", "value": ';
        parts[6] =  Strings.toString(_player.attack);
        parts[7] =  '}, { "trait_type": "HEAL Damage", "value": ';
        parts[8] =  Strings.toString(_player.heal);
        parts[9] =  '}, { "trait_type": "Critical", "value": ';
        parts[10] =  Strings.toString(_player.critical);
        parts[11] =  '}, { "trait_type": "MISS", "value": ';
        parts[12] =  Strings.toString(_player.miss);
        parts[13] =  '}, { "trait_type": "SECRET", "value": "';
        parts[14] =  Strings.toString(_player.characterId);
        parts[15] =  '"} ]}';
        string memory uriStr = string(abi.encodePacked(parts[0],parts[1],parts[2],parts[3],parts[4],parts[5],parts[6],parts[7]));
        uriStr = string(abi.encodePacked(uriStr,parts[8],parts[9],parts[10],parts[11],parts[12],parts[13],parts[14],parts[15]));
        // console.log("uriStr",uriStr);
        string memory json = Base64.encode(bytes(uriStr));
        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function attackBoss(Instruct _instruct) public {
        uint256 userNftTokenId = nftHolderIndex[msg.sender];
        require(userNftTokenId>0, "User character uncreated.");
        PlayerAttr storage _player =  playerList[userNftTokenId.sub(1)];
        // console.log("Player character about to attack. Has %s HP and %s AD", _player.hp, _player.attack);
        // console.log("Boss has %s HP and %s AD", genesisBoss.hp, genesisBoss.attack);
        require (_player.hp > 0,"Error: character must have HP to attack boss.");
        require (genesisBoss.hp > 0,"Error: boss must have HP to attack boss.");
        uint256 heroDamage = _player.attack;
        uint256 bossDamage = genesisBoss.attack;
        AttackState adState = AttackState.Normal;
        if(random("critical", 100) + _player.critical > 50){
            heroDamage = heroDamage.mul(2);
            adState = AttackState.Critical;
        }
        if(random("miss", 100) - _player.miss > 80){
            heroDamage = 0x0;
            adState = AttackState.Miss;
        }
        if(_instruct == Instruct.Heal){
            _player.hp = _player.hp.add(heroDamage);
            heroDamage = 0x0;
            bossDamage = 0x0;
        }else {
            if(_instruct == Instruct.Secret){
                if(_player.characterId == uint256(SecretType.Armor)){
                    bossDamage = 0x0;
                    heroDamage = heroDamage.add(genesisBoss.attack);
                }else if(_player.characterId == uint256(SecretType.Blood)){
                    _player.hp = _player.hp.add(heroDamage);
                }else if(_player.characterId == uint256(SecretType.Reborn)){
                    _player.hp = _heroMaxHP;
                    bossDamage = 0x0;
                    heroDamage = 0x0;
                }
            }
        }
        _player.hp = _player.hp.sub(bossDamage);
        genesisBoss.hp = genesisBoss.hp.sub(heroDamage);
        // console.log("Player attacked boss at %s. New boss hp: %s", heroDamage ,genesisBoss.hp);
        // console.log("Boss attacked player at %s. New player hp: %s\n", bossDamage, _player.hp);
        _round = _round.add(1);
        if(genesisBoss.hp==0x0){
            genesisBoss.hp = _bossMaxHP;
            _round = 0x0;
            _generation.increment();
        }
        emit AttackComplete(genesisBoss.hp, _player.hp, adState, _round);
    }

    function getGeneration() public view returns (uint256) {
      return _generation.current();
    }

    function getHeors() public view returns (PlayerAttr[] memory) {
      return playerList;
    }

    function getCharacters() public view returns (CharacterAttr[] memory) {
      return charList;
    }

    function getTheHero() public view returns (PlayerAttr memory) {
      uint256 userNftTokenId = nftHolderIndex[msg.sender];
      if (userNftTokenId > 0x0) {
        return playerList[userNftTokenId.sub(1)];
      } else {
        PlayerAttr memory emptyStruct;
        return emptyStruct;
      }
    }
}
