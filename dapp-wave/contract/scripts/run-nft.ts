// @ts-nocheck
const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const nftContractFactory = await hre.ethers.getContractFactory("FestNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract FestNFT deployed to:", nftContract.address);
  console.log("Contract FestNFT deployed by:", owner.address);
  const contractURI = await nftContract.contractURI();
  console.log("contractURI", contractURI);
  // let txn;
  // for (let i = 0; i < 10; i++) {
  //   // Call the function.
  //   txn = await nftContract.mintFest("");
  //   // Wait for it to be mined.
  //   await txn.wait();
  // }
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
