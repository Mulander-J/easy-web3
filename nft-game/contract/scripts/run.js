const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const gameContractFactory = await hre.ethers.getContractFactory('EpicGame');
  const gameContract = await gameContractFactory.deploy(
    // Names
    ["Black Express", "Armor", "Renji","Hope"],
    // Images
    [
      "https://i.imgur.com/pKd5Sdk.png",
      "https://i.imgur.com/xVu4vFL.png", 
      "https://i.imgur.com/WMB6g9u.png",
      "https://i.imgur.com/WMB6g9u.png"
    ],
    // Intros
    [
      "The Boss",
      "Role1Intro",
      "Role2Intro",
      "Role3Intro"
    ]
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn, resGet;
  // Get All Genesis Characters.
  // resGet = await gameContract.getCharacters();
  // console.log("getCharacters:", resGet);
  // Update Characters
  // txn = await gameContract.updateChar(1,"Name","URI","INTRO");
  // await txn.wait();
  // try{
  //   txn = await gameContract.connect(randomPerson).updateChar(8,"Name","URI","INTRO");
  //   await txn.wait();
  // }catch(err){
  //   console.log('[ err ] >', err)
  // }
  // try{
  //   txn = await gameContract.updateChar(8,"Name","URI","INTRO");
  //   await txn.wait();
  // }catch(err){
  //   console.log('[ err ] >', err)
  // }
  // resGet = await gameContract.getCharacters();
  // console.log("getCharacters:", resGet);
  txn = await gameContract.mintCharacterNFT(3);
  await txn.wait();
  console.log(1);
  //  mint NFT
  // for(let i = 0;i<5;i++){
  //   txn = await gameContract.mintCharacterNFT(2);
  //   await txn.wait();
  // }
  // resGet = await gameContract.tokenURI(4);
  // console.log("tokenURI:", resGet);

  // resGet = await gameContract.charList(0);
  // console.log("getHeors:", resGet);

  txn = await gameContract.attackBoss(0);
  await txn.wait();
  console.log(2);

  // txn = await gameContract.attackBoss(1);
  // await txn.wait();

  txn = await gameContract.attackBoss(2);
  await txn.wait();
  console.log(3);

  // resGet = await gameContract._round();
  // console.log("round:", resGet);

  resGet = await gameContract.getTheHero();
  console.log("getTheHero:", resGet);

  resGet = await gameContract.genesisBoss();
  console.log("getBoss:", resGet);


  // resGet = await gameContract.playerList();
  // console.log("getHeors:", resGet);

  // txn = await gameContract.attackBoss();
  // await txn.wait();

  // txn = await gameContract.attackBoss();
  // await txn.wait();

  // // Get the value of the NFT's URI.
  // let returnedTokenUri = await gameContract.tokenURI(1);
  // console.log("Token URI:", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();