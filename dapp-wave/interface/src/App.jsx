import React, {useEffect, useState, useCallback} from "react";
import {ethers} from "ethers";
import Jazzicon from 'react-jazzicon';
import {toast} from 'react-toastify';
import GoogleMapReact from 'google-map-react';
import Geohash from 'latlon-geohash';
import './App.css';
import contractWave from "./utils/wavePortal.json";

const shortenString = (str) => {
    return !str ? '' : str.length <= 11 ? str : str.substring(0, 6) + '...' + str.substring(str.length - 4)
}

const stepList = [
    {
        index: 1,
        title: 'Dot',
        content: 'Wave once as a dot.',
        tip: 'Waving duration is limited in 15 seconds.',
    },
    {
        index: 2,
        title: 'Line',
        content: 'Wave twice as a line.',
        tip: 'Line function is not avaliable yet.',
    },
    {
        index: 3,
        title: 'Shape',
        content: 'One more wave to united as a shape.',
        tip: 'Shape function is not avaliable yet.',
    },
    {
        index: 4,
        title: 'Claim',
        content: 'You are already in our white list! 50% chance to claim 0.001 eth & a special NFT for gift!',
        tip: 'If you lost the chance, you can still try again until you claimed.',
    },
]
const USRER_STAT_DEF = {
    account: '',
    id: 0,
    timestamp: '',
    tolShape: 0,
    tolWave: 0,
    isUsed: false,
}
const defaultProps = {
    key: "",
    center: {
        lat: 10.9983,
        lng: 77.0150
    },
    zoom: 11
};
const NFT_CONTRACT = "0x0193BbA92e1b610e06d1c18e5A00C068356Ab0dA";
const RARIBLE_LINK = `https://rinkeby.rarible.com/collection/${NFT_CONTRACT}/`;
const OPENSEA_LINK = `https://testnets.opensea.io/assets/${NFT_CONTRACT}/`;
const contractAddress = '0xb69C2209d8Ad1128DCdD16C5a1B3Ef0072b461Fb'
export default function App() {

    const MapNode = ({text}) => <div className="mapMarker">{text}</div>;
    /**
     * Create a variable here that references the abi content!
     */
    const contractABI = contractWave.abi
    /*
     * Just a state variable we use to store our user's public wallet.
     */
    const [loading, setLoading] = useState(false)

    const [currentAccount, setCurrentAccount] = useState('')
    const [nftId, setNftId] = useState('')

    const [waveTol, setWaveTol] = useState(0)
    const [userTol, setUserTol] = useState(0)
    const [userStat, setUserStat] = useState({
        account: '',
        id: 0,
        timestamp: '',
        tolShape: 0,
        tolWave: 0,
        isUsed: false,
    })

    const [shapeId, setShapeId] = useState(0)
    const [waves, setWaves] = useState([])

    const [step, setStep] = useState(0)

    const updateUserInfo = async () => {
        try {
            /**
             * Step
             * 1-Add Wave
             * 2-Add Line
             * 3-Add Shape
             * 4-Claim
             * 5-Claimed
             */
            const provider = new ethers.providers.Web3Provider(ethereum);
            const signer = provider.getSigner();
            const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);
            const accounts = await ethereum.request({method: 'eth_requestAccounts'})
            const resWhite = Number(await connectedContract.getWhiteCondition(currentAccount || accounts[0]))
            const resWhiteNft = Number(await connectedContract.getWinnerNftId())
            setNftId(Number(resWhiteNft) || 0)
            const resUser = await connectedContract.getUserStat()
            console.log("resWhite", resWhite)
            // console.log("resUser", resUser)
            setUserStat({
                ...USRER_STAT_DEF,
                account: resUser.account,
                id: Number(resUser.id),
                timestamp: resUser.timestamp ? new Date(Number(resUser.timestamp) * 1000).toLocaleString() : '',
                tolShape: Number(resUser.tolShape),
                tolWave: Number(resUser.tolWave),
                isUsed: resUser.isUsed,
            });
            let state = 0
            if (resWhite === 2) {
                state = 5
            } else if (resWhite === 1) {
                state = 4
            } else {
                state = Number(resUser.tolWave) + 1
                state >= 4 && (state = 3)
            }
            console.log("state", state)
            setStep(state)
            await getWave()
        } catch (err) {
            console.log("updateUserInfo", err)
            setUserStat(USRER_STAT_DEF)
            setStep(0)
        }
    }

    const getShapeId = async () => {
        if (shapeId) return shapeId
        if (!userStat.isUsed) return 0
        let _shapeId = 0;
        try {
            const provider = new ethers.providers.Web3Provider(ethereum);
            const signer = provider.getSigner();
            const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);
            let _userShpaes = await connectedContract.getAllShapes()
            _shapeId = Number(_userShpaes[0].id)
        } catch (err) {
            console.log(err)
            _shapeId = 0;
        }
        setShapeId(_shapeId);
        return _shapeId
    }

    const getWave = async () => {
        try {
            const provider = new ethers.providers.Web3Provider(ethereum);
            const signer = provider.getSigner();
            const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);
            const res = await connectedContract.getAllWaves()
            const _map = res.map(e => {
                const latlon = Geohash.decode(e.geohash);
                return {
                    ...latlon,
                    shapeId: Number(e.shapeId),
                    id: Number(e.id)
                }
            })
            // console.log("_map",_map)
            setWaves(_map)
        } catch (err) {
            console.log(err)
        }
    }

    const wave = async (data) => {
        if (loading) {
            alert("Wave is loading...")
            return
        }
        setLoading(true)
        try {
            const digits = 6
            const {lat, lng} = data
            const geoHash = Geohash.encode(lat, lng, digits)
            // console.log(geoHash)
            const shapeId = await getShapeId()
            const moodColor = ethers.utils.formatBytes32String("fefefe")
            const message = "Hello world."


            const provider = new ethers.providers.Web3Provider(ethereum);
            const signer = provider.getSigner();
            const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);

            const waveTxn = await connectedContract.wave(
                message, geoHash, moodColor, shapeId, 1
            )
            console.log('Mining...', waveTxn.hash)
            await waveTxn.wait()
            console.log('Mined -- ', waveTxn.hash)
            toast.success('Success!Next Wave should be 15s later.');
            await updateUserInfo()
        } catch (err) {
            toast.error(err?.error?.message || err.message);
        } finally {
            setLoading(false)
        }
    }
    const claimGift = async () => {
        try {
            const provider = new ethers.providers.Web3Provider(ethereum);
            const signer = provider.getSigner();
            const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);
            const waveTxn = await connectedContract.waveGift("")
            await waveTxn.wait()
            toast.success("Claim Success");
            await updateUserInfo()
        } catch (err) {
            toast.error(err?.error?.message || err.message);
        }
    }
    const setupEventListener = () => {
        // Most of this looks the same as our function askContractToMintNft
        try {
            const {ethereum} = window;

            if (ethereum) {
                // Same stuff again
                const provider = new ethers.providers.Web3Provider(ethereum);
                const signer = provider.getSigner();
                const connectedContract = new ethers.Contract(contractAddress, contractABI, signer);

                connectedContract.on('NewUser', (addr,timestamp,tokenId)=>{
                  console.log('NewUser', addr, tokenId)
                  setUserTol(tokenId + 1)
                  toast('Welcome new user ' + shortenString(addr));
                })
                connectedContract.on('NewWave', (addr,timestamp,tokenId)=>{
                  console.log('NewWave', addr, tokenId)
                  setWaveTol(tokenId + 1)
                  toast('New wave via ' + shortenString(addr));
                })

                console.log("Setup event listener!")

            } else {
                console.log("Ethereum object doesn't exist!");
            }
        } catch (error) {
            console.log(error)
        }
    }
    const connectWallet = async () => {
        try {
            const ethereum = window.ethereum
            if (!ethereum) {
                alert('Get MetaMask!')
                return
            }
            const accounts = await ethereum.request({method: 'eth_requestAccounts'})
            console.log('Connected', accounts[0])
            // Setup listener! This is for the case where a user comes to our site
            // and ALREADY had their wallet connected + authorized.
            setupEventListener()
            const provider = new ethers.providers.Web3Provider(ethereum)
            const signer = provider.getSigner()
            const wavePortalContract = new ethers.Contract(contractAddress, contractABI, signer)
            Promise.allSettled([
                wavePortalContract.getTotalUser(),
                wavePortalContract.getTotalWaves()
            ]).then((results) => {
                // console.log("allSettled",results)
                setUserTol(results[0].status === "fulfilled" ? Number(results[0].value) : 0)
                setWaveTol(results[1].status === "fulfilled" ? Number(results[1].value) : 0)

                setCurrentAccount(accounts[0])

                updateUserInfo()
            })
        } catch (error) {
            console.log(error)
            setCurrentAccount("")
        }
    }
    const checkIfWalletIsConnected = async () => {
        try {
            const ethereum = window.ethereum

            if (!ethereum) {
                alert('Make sure you have metamask!')
                return
            } else {
                console.log('We have the ethereum object')
            }

            /*
             * Check if we're authorized to access the user's wallet
             */
            const accounts = await ethereum.request({method: 'eth_accounts'})

            if (accounts.length !== 0) {
                console.log('Found an authorized account')
                await connectWallet()
            } else {
                toast.error('No authorized account found');
                setCurrentAccount("")
            }
        } catch (error) {
            console.log(error)
        }
    }

    useEffect(() => {
        checkIfWalletIsConnected()
    }, [])

    return (
        <div className="mainContainer">
            <div className="headBar">
                <div className="headStat">
                    <span>{waveTol}</span>
                    <label>WAVES</label>
                </div>
                <div className="logoBrand">
                    <span>Wave 👋 Portal</span>
                </div>
                <div className="headStat">
                    <span>{userTol}</span>
                    <label>USERS</label>
                </div>
            </div>

            <section className="bio">
                <p>Hello, everyone! I am Mulander.</p>
                <p>Welcome to my decentralized wave portal!</p>
                <p><a href={"https://rinkeby.etherscan.io/address/" + contractAddress} target="_blank">Rinkeby:{contractAddress}</a></p>
                {userStat.isUsed && <p><strong># {userStat.id} Join At {userStat.timestamp}</strong></p>}
            </section>

            <div className="walletBox">
                {
                    currentAccount ?
                        <div className="userAccount">
                            <Jazzicon diameter={36} seed={parseInt(currentAccount.slice(2, 10))}/>
                            <strong>{shortenString(currentAccount)}</strong>
                        </div> :
                        <div className="waveButton" onClick={connectWallet}>Connect Wallet</div>
                }
            </div>

            <div className="intro">
                <p>Click on the map to handle a wave at me via blockchain.</p>
                <p>See what picture we will draw in Age.Web3.</p>
            </div>

            <div className="mapBox">
                {loading && <div className="loading">Loading</div>}
                <GoogleMapReact
                    bootstrapURLKeys={{key: defaultProps.key}}
                    defaultCenter={defaultProps.center}
                    defaultZoom={defaultProps.zoom}
                    onClick={wave}
                >
                    {
                        waves.length > 0 && waves.map(e => (
                            <MapNode
                                id={e.id} key={e.id}
                                lat={e.lat} lng={e.lon} text={e.id}
                            />
                        ))
                    }
                </GoogleMapReact>
            </div>

            {
                step !== 5 ?
                    <section className="introBottom">
                        {
                            stepList.map(item => (
                                <div className={["stepCard", step < item.index ? " deactive" : null].join(" ")}
                                     date-step={item.index} key={item.index}>
                                    <p className="stepTitle">{item.title}</p>
                                    <p>{(item.index < 4 || step === 4) ? item.content : 'Finish 3 steps to win NFT'}</p>
                                    <p className="stepTip">{item.tip}</p>
                                    {step === 4 && item.index === 4 &&
                                    <button className="waveButton" onClick={claimGift}>Claim</button>}
                                </div>
                            ))
                        }

                    </section>
                    : <section className="introBottom">
                        <div className="stepCard" date-step={nftId}>
                            <p>FestNFT is a creative NFT published by "Fest DAO"(Not Existed). Each item consists of a festival definition
                                and a festival activity, human behaviour in the new festival of the web3 era.</p>
                            <p>Your Nft tokenId <strong># {nftId}</strong></p>
                            <a href={OPENSEA_LINK + nftId} target="_blank"
                               rel="noreferrer" className="footer-text">
                                🌊 View Your NFT on OpenSea
                            </a><br/>
                            <a href={RARIBLE_LINK + nftId} target="_blank"
                               rel="noreferrer" className="footer-text">
                                💎 View Your NFT on Rarible
                            </a>
                        </div>
                    </section>
            }

            <footer>
                <span>Doc</span>
                <span>Github</span>
                <span>Discord</span>
            </footer>
        </div>
    )
}