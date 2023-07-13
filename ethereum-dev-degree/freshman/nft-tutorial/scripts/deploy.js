// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

// Import ethers from Hardhat package
const { ethers } = require("hardhat");

async function main() {
  /*
    A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
    so nftContract here is a factory for instances of our GameItem contract.
  */
  const nftContract = await ethers.getContractFactory("GameItem");

  // here we deploy the contract
  const deployedNFTContract = await nftContract.deploy();

  // print the address of the deployed contract
  console.log("NFT Contract Address:", deployedNFTContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });