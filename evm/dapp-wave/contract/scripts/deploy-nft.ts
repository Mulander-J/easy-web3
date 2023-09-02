// @ts-nocheck
const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const nftContractFactory = await hre.ethers.getContractFactory("FestNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract FestNFT deployed to:", nftContract.address);

  // for (let i = 0; i < 10; i++) {
  //   // Call the function.
  //   txn = await nftContract.mintFest(deployer, i % 2 === 0 ? "t9ywrp" : "");
  //   // Wait for it to be mined.
  //   await txn.wait();
  // }
  // console.log("10 FestNFT Minted");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
