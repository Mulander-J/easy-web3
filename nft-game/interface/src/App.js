import React, { useEffect, useState } from 'react';
import twitterLogo from './assets/twitter-logo.svg';
import './App.css';
import SelectCharacter from './Components/SelectCharacter';
import Arena from './Components/Arena';
import LoadingIndicator from './Components/LoadingIndicator';
import {toast} from 'react-toastify';
import {shortenString} from './utils/tools.js';

/**
 * Ethers Set
 */
import { ethers } from 'ethers';
import { CONTRACT_ADDRESS, transformPlayerData, transformCharacterData } from './constants';
import myEpicGame from './utils/GameAbi.json';

// Constants
const TWITTER_HANDLE = 'Mulander_King';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;

const App = () => {

  // State

  /*
   * Just a state variable we use to store our user's public wallet. Don't forget to import useState.
   */
  const [currentAccount, setCurrentAccount] = useState(null);

  /*
  * Right under current account, setup this new state property
  */
  const [characterNFT, setCharacterNFT] = useState(null);
  const [characters, setCharacters] = useState([]);
  const [charBoss, setCharBoss] = useState(null);
  const [generation, setGeneration] = useState(0);
  const [round, setRound] = useState(0);

  /*
  * New state property added here
  */
  const [isLoading, setIsLoading] = useState(false);

  /*
   * Implement your connectWallet method here
   */
  const connectWalletAction = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert('Get MetaMask!');
        return;
      }

      /*
       * Fancy method to request access to account.
       */
      const accounts = await ethereum.request({
        method: 'eth_requestAccounts',
      });

      /*
       * Boom! This should print out public address once we authorize Metamask.
       */
      console.log('Connected', accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };


  /*
   * Start by creating a new action that we will run on component load
   */
  // Actions
  const checkIfWalletIsConnected = async () => {
      try {
        const { ethereum } = window;

        if (!ethereum) {
          toast.dark('Make sure you have MetaMask!');
          /*
          * We set isLoading here because we use return in the next line
          */
          setIsLoading(false);
          return;
        } else {
          console.log('We have the ethereum object', ethereum);

          const accounts = await ethereum.request({ method: 'eth_accounts' });

          if (accounts.length !== 0) {
            const account = accounts[0];
            console.log('Found an authorized account:', account);
            toast(`Welcome Back! ${shortenString(account)}`);
            setCurrentAccount(account);
          } else {
            console.log('No authorized account found');
            toast.warn('Plz connect any account to this website!');
          }
        }
      } catch (error) {
        console.log(error);
      }
      /*
      * We release the state property after all the function logic
      */
      setIsLoading(false);
  };

  /*
   * This runs our function when the page loads.
   */
  useEffect(() => {
    /*
    * Anytime our component mounts, make sure to immiediately set our loading state
    */
    setIsLoading(true);
    checkIfWalletIsConnected();
  }, []);

  /*
 * Add this useEffect right under the other useEffect where you are calling checkIfWalletIsConnected
 */
useEffect(() => {
  /*
   * The function we will call that interacts with out smart contract
   */
  const fetchNFTMetadata = async () => {
    console.log('Checking for Character NFT on address:', currentAccount);
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const gameContract = new ethers.Contract(
      CONTRACT_ADDRESS,
      myEpicGame.abi,
      signer
    );
    const charactersTxn = await gameContract.getCharacters();
    console.log('charactersTxn:', charactersTxn);
    const allCharacters = charactersTxn.map((characterData) =>
        transformCharacterData(characterData)
    );
    setCharBoss(allCharacters[0]||null);
    setCharacters(allCharacters.slice(1));
    let numTxn = await gameContract.getGeneration();
    setGeneration(Number(numTxn));
    numTxn = await gameContract._round();
    setRound(Number(numTxn));
    const txn = await gameContract.getTheHero();
    if (txn.characterId > 0) {
      console.log('User has character NFT');
      let palyer = transformPlayerData(txn);
      setCharacterNFT({
        ...palyer,
        ...allCharacters[palyer.characterId]
      });
    } else {
      setCharacterNFT(null);
      console.log('No character NFT found');
    }
  };

  /*
  * Once we are done with all the fetching, set loading state to false
  */
  setIsLoading(false);

  /*
   * We only want to run this, if we have a connected wallet
   */
  if (currentAccount) {
    console.log('CurrentAccount:', currentAccount);
    fetchNFTMetadata();
  }
}, [currentAccount]);

  // Render Methods
  const renderContent = () => {
    /*
    * If the app is currently loading, just render out LoadingIndicator
    */
    if (isLoading) {
      return <LoadingIndicator />;
    }
    /*
    * Scenario #1
    */
    if (!currentAccount) {
      return (
        <div className="connect-wallet-container">
          <img
            src="https://64.media.tumblr.com/tumblr_mbia5vdmRd1r1mkubo1_500.gifv"
            alt="Monty Python Gif"
          />
          <button
            className="cta-button connect-wallet-button"
            onClick={connectWalletAction}
          >
            Connect Wallet To Get Started
          </button>
        </div>
      );
      /*
      * Scenario #2
      */
    } else if (currentAccount && !characterNFT) {
      return <SelectCharacter setCharacterNFT={setCharacterNFT} chars={characters}/>;
      /*
      * If there is a connected wallet and characterNFT, it's time to battle!
      */
    } else if (currentAccount && characterNFT) {
      return <Arena characterNFT={characterNFT} setCharacterNFT={setCharacterNFT} setRound={setRound} charBoss={charBoss}/>;
    }
  };

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">⚔️ Metaverse Slayer ⚔️</p>
          <p className="sub-text">Team up to protect the Metaverse!</p>
          <p className="sub-text">
            <span>Generation: {generation}</span> | <span>Round: {round}</span>
          </p>
          {renderContent()}
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built by @${TWITTER_HANDLE}`}</a>
        </div>
        <a
            className="footer-text"
            href={`https://rinkeby.etherscan.io/address/${CONTRACT_ADDRESS}`}
            target="_blank"
            rel="noreferrer"
          >Rinkeby Link</a>
      </div>
    </div>
  );
};

export default App;
