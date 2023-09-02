// @ts-nocheck
const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const nftContractFactory = await hre.ethers.getContractFactory("FestNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract FestNFT deployed to:", nftContract.address);

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveTxn = await waveContract.setFestNFT(nftContract.address);
  await waveTxn.wait();
  waveTxn = await waveContract.connect(randomPerson).waveGift("");
  await waveTxn.wait();
  waveTxn = await waveContract.connect(randomPerson).getWinnerNftId();
  console.log(Number(waveTxn));
  // let waveCount, userCount, allCount;
  // let userStat;
  // waveCount = await waveContract.getTotalWaves();
  // userCount = await waveContract.getAllShapes();
  // allCount = await waveContract.getTotalBatch();
  // userStat = await waveContract.getUserStat();
  // console.log("[userCount]", userCount);
  // console.log("[allCount1]", allCount);
  // console.log("[userStat1]", userStat);

  // let waveTxn = await waveContract.wave(
  //   "hello world",
  //   "XKUIPI",
  //   hre.ethers.utils.formatBytes32String("060506"),
  //   0,
  //   1
  // );
  // await waveTxn.wait();
  
  // waveCount = await waveContract.getTotalWaves();
  // userCount = await waveContract.getAllShapes();
  // allCount = await waveContract.getTotalBatch();
  // userStat = await waveContract.getUserStat();
  // console.log("[userCount]", userCount);
  // console.log("[allCount1]", allCount);
  // console.log("[userStat1]", userStat);


  // let waveTxn = await waveContract.connect(randomPerson).addLayer("Mars");
  // await waveTxn.wait();
  // allCount = await waveContract.getTotalBatch();
  // console.log("[allCount1]", allCount);

  // waveCount = await waveContract.getTotalWaves();
  // userCount = await waveContract.getTotalUser();
  // allCount = await waveContract.getTotalBatch();
  // userStat = await waveContract.getUserStat();
  // console.log("[allCount2]", allCount);
  // console.log("[userStat2]", userStat);

  // waveTxn = await waveContract.wave(
  //   "hello world2",
  //   "XKOIPI",
  //   hre.ethers.utils.formatBytes32String("060506"),
  //   1,
  //   1
  // );
  // await waveTxn.wait();

  // waveCount = await waveContract.getTotalWaves();
  // userCount = await waveContract.getTotalUser();
  // allCount = await waveContract.getTotalBatch();
  // userStat = await waveContract.getUserStat();
  // console.log("[allCount2]", allCount);
  // console.log("[userStat2]", userStat);

  // waveTxn = await waveContract
  //   .connect(randomPerson)
  //   .wave(
  //     "hello world3",
  //     "XKOIPI",
  //     hre.ethers.utils.formatBytes32String("060506"),
  //     0,
  //     0
  //   );
  // await waveTxn.wait();

  // waveCount = await waveContract.getTotalWaves();
  // userCount = await waveContract.getTotalUser();
  // allCount = await waveContract.getTotalBatch();
  // userStat = await waveContract.connect(randomPerson).getUserStat();
  // console.log("[allCount3]", allCount);
  // console.log("[userStat3]", userStat);

  // const allWaves = await waveContract.getAllWaves();
  // console.log("[allWaves]", allWaves);

  // let contractBalance = await hre.ethers.provider.getBalance(
  //   waveContract.address
  // );
  // console.log(
  //   "Contract balance:",
  //   hre.ethers.utils.formatEther(contractBalance)
  // );
  // waveTxn = await waveContract.waveGift();
  // await waveTxn.wait();
  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  // console.log(
  //   "Contract balance:",
  //   hre.ethers.utils.formatEther(contractBalance)
  // );
  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
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
