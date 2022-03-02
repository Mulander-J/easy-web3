import React, { useEffect, useState } from "react";
import "./SelectCharacter.css";
import { ethers } from "ethers";
import { CONTRACT_ADDRESS, transformPlayerData, SECRETS } from "../../constants";
import myEpicGame from "../../utils/GameAbi.json";
import LoadingIndicator from "../LoadingIndicator";
import { toast } from "react-toastify";
import { shortenString } from "../../utils/tools.js";


const SelectCharacter = ({ setCharacterNFT, chars }) => {
  const [gameContract, setGameContract] = useState(null);
  const [mintingCharacter, setMintingCharacter] = useState(false);

  const renderCharacters = () =>
    chars.map((character) => (
      <div className="character-item" key={character.name}>
        <div className="name-container">
          <p>{character.name}</p>
        </div>
        <img
          src={character.imageURI}
          alt={character.name}
        />
        <p className="character-intro">
            {character.intro}
            <br/>
            Secret.{SECRETS[character.characterId-1]}
        </p>
        <button
          type="button"
          className="character-mint-button"
          onClick={mintCharacterNFTAction(character.characterId)}
        >{`Mint ${character.name}`}</button>
      </div>
    ));

  // Actions
  const mintCharacterNFTAction = (characterId) => async () => {
    try {
      if (gameContract) {
        setMintingCharacter(true);
        console.log("Minting character in progress...");
        const mintTxn = await gameContract.mintCharacterNFT(characterId);
        await mintTxn.wait();
        console.log("mintTxn:", mintTxn);
        setMintingCharacter(false);
      }
    } catch (error) {
      console.warn("MintCharacterAction Error:", error);
      toast.error(error?.error?.message || error.message);
      setMintingCharacter(false);
    }
  };

  // UseEffect
  useEffect(() => {
    const { ethereum } = window;
    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const gameContract = new ethers.Contract(
        CONTRACT_ADDRESS,
        myEpicGame.abi,
        signer
      );
      setGameContract(gameContract);
    } else {
      console.log("Ethereum object not found");
    }
  }, []);

  useEffect(() => {
    const onCharacterMint = async (sender, tokenId, characterIndex) => {
      toast.success(
        `CharacterNFTMinted - sender: ${shortenString(
          sender
        )} tokenId: ${tokenId.toNumber()} characterIndex: ${characterIndex.toNumber()}`
      );
      alert(
        `Your NFT is all done -- see it here: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`
      );
      if (gameContract) {
        const characterNFT = await gameContract.getTheHero();
        console.log("CharacterNFT: ", characterNFT);
        let player = transformPlayerData(characterNFT);
        setCharacterNFT({
          ...player,
          ...chars[player.characterId-1]
        });
      }
    };
    if (gameContract) {
      gameContract.on("CharacterNFTMinted", onCharacterMint);
    }
    return () => {
      if (gameContract) {
        gameContract.off("CharacterNFTMinted", onCharacterMint);
      }
    };
  }, [gameContract]);

  return (
    <div className="select-character-container">
      <h2>Mint Your Hero. Choose wisely.</h2>
      {chars.length > 0 && (
        <div className="character-grid">{renderCharacters()}</div>
      )}
      {mintingCharacter && (
        <div className="loading">
          <div className="indicator">
            <LoadingIndicator />
            <p>Minting In Progress...</p>
          </div>
          <img
            src="https://media2.giphy.com/media/61tYloUgq1eOk/giphy.gif?cid=ecf05e47dg95zbpabxhmhaksvoy8h526f96k4em0ndvx078s&rid=giphy.gif&ct=g"
            alt="Minting loading indicator"
          />
        </div>
      )}
    </div>
  );
};

export default SelectCharacter;
