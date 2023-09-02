import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { CONTRACT_ADDRESS, transformPlayerData, SECRETS } from '../../constants';
import myEpicGame from '../../utils/GameAbi.json';
import './Arena.css';
import LoadingIndicator from '../LoadingIndicator';
import { toast } from 'react-toastify';

const Arena = ({ characterNFT, setCharacterNFT, setRound, charBoss }) => {

    // State
    const [gameContract, setGameContract] = useState(null);
    const [boss, setBoss] = useState(null);
    const [attackState, setAttackState] = useState('');

    // Actions
    const runAttackAction = async (instruct) => {
        try {
            if (gameContract) {
              setAttackState('attacking');
              console.log('Attacking boss...');
              const attackTxn = await gameContract.attackBoss(instruct);
              await attackTxn.wait();
              console.log('attackTxn:', attackTxn);
              setAttackState('hit');
            }
          } catch (error) {
            console.error('Error attacking boss:', error);
            toast.error(error?.error?.message||error.message);
            setAttackState('');
          }
    };

    // UseEffects
    useEffect(() => {
        const fetchBoss = async () => {
            const bossTxn = await gameContract.genesisBoss();
            console.log('Boss:', bossTxn);
            setBoss(transformPlayerData(bossTxn));
        };
        const onAttackComplete = (newBossHp, newPlayerHp, adState, round) => {
            const bossHp = newBossHp.toNumber();
            const playerHp = newPlayerHp.toNumber();

            console.log(`AttackComplete: Boss Hp: ${bossHp} Player Hp: ${playerHp}`);

            setBoss((prevState) => {
                return { ...prevState, hp: bossHp };
            });

            setCharacterNFT((prevState) => {
                return { ...prevState, hp: playerHp };
            });

            setRound(Number(round));
            Number(adState) > 0 && toast.dark(Number(adState)===1?'Miss Attack':'Critical Attack');
        };

        if (gameContract) {
            fetchBoss();
            gameContract.on('AttackComplete', onAttackComplete);
        }

        /*
        * Make sure to clean up this event when this component is removed
        */
        return () => {
            if (gameContract) {
                gameContract.off('AttackComplete', onAttackComplete);
            }
        }
    }, [gameContract]);

    // UseEffects
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
            console.log('Ethereum object not found');
        }
    }, []);

    return (
        <div className="arena-container">
            {boss && (
                <div className="boss-container">
                     <h2>The Boss</h2>
                    <div className={`boss-content ${attackState}`}>
                        <div className="image-content">
                            <h2>🔥 {charBoss.name} 🔥</h2>
                            <img src={charBoss.imageURI} alt={`Boss ${charBoss.name}`} />
                            <div className="health-bar">
                                <progress value={boss.hp} max={boss.maxHp} />
                                <p>{`${boss.hp} / ${boss.maxHp} HP`}</p>
                            </div>
                        </div>
                        <div className="stats">
                            <h4>
                                <span>{`⚔️ Attack Damage: ${boss.attack}`}</span>
                                <span>{`🗡️ Critical: +${boss.critical}`}</span>
                            </h4>
                            <h4>
                                <span>{`❤️ Heal Damage: ${boss.heal}`}</span>
                                <span>{`⚡️ Miss: +${boss.miss}`}</span>
                            </h4>
                        </div>
                    </div>
                </div>
            )}
            <div className="attack-container">
                {attackState === 'attacking' && (
                    <div className="loading-indicator">
                        <LoadingIndicator />
                        <p>Attacking ⚔️</p>
                    </div>
                )}
                <button className="cta-button" onClick={()=>{runAttackAction(0)}}>
                    {`💥 Attack ${charBoss.name}`}
                </button>
                <button className="cta-button" onClick={()=>{runAttackAction(1)}}>
                    {`❤️ Heal ${characterNFT.name}`}
                </button>
                <button className="cta-button" onClick={()=>{runAttackAction(2)}}>
                    {`🌟 Use Secret`}
                </button>
                <p>{SECRETS[characterNFT.characterId-1]}</p>
            </div>
            {characterNFT && (
                    <div className="players-container">
                        <div className="player-container">
                            <h2>Your Character</h2>
                            <div className="player">
                                <div className="image-content">
                                    <h2>{characterNFT.name}</h2>
                                    <img
                                        src={characterNFT.imageURI}
                                        alt={`Character ${characterNFT.name}`}
                                    />
                                    <div className="health-bar">
                                        <progress value={characterNFT.hp} max={characterNFT.maxHp} />
                                        <p>{`${characterNFT.hp} / ${characterNFT.maxHp} HP`}</p>
                                    </div>
                                </div>
                                <div className="stats">
                                    <h4>
                                        <span>{`⚔️ Attack Damage: ${characterNFT.attack}`}</span>
                                        <span>{`🗡️ Critical: +${characterNFT.critical}`}</span>
                                    </h4>
                                    <h4>
                                        <span>{`❤️ Heal Damage: ${characterNFT.heal}`}</span>
                                        <span>{`⚡️ Miss: +${characterNFT.miss}`}</span>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                )}
        </div>
    );
};

export default Arena;