const CONTRACT_ADDRESS = '0xC6B1748Eb303a0b2639629F46f4e27AE8B0A285b';

export const SECRETS = [
  "Poseidon Armor : Injury Avoidance And Return Attack",
  "The Last Whisper : Blood Suck While Attack",
  "Muse Kiss : Recharge Full HP"
];

const transformPlayerData = (player) => {
  return {
    characterId:player.characterId.toNumber(),
    hp: player.hp.toNumber(),
    maxHp: player.maxHp.toNumber(),
    attack: player.attack.toNumber(),
    heal: player.heal.toNumber(),
    critical: player.critical.toNumber(),
    miss: player.miss.toNumber()
  };
};
const transformCharacterData = (characterData) => {
  return {
    characterId:characterData.characterId.toNumber(),
    name:characterData.name,
    intro:characterData.intro,
    imageURI: 'https://cloudflare-ipfs.com/ipfs/' + characterData.imageURI,
  };
};

export { CONTRACT_ADDRESS, transformCharacterData, transformPlayerData };