// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
// const hre = require("hardhat");

const main = async () => {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const tld = "ssr";

  const [owner, randomPerson] = await hre.ethers.getSigners();
  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy(tld);
  await domainContract.deployed();
  console.log("Contract deployed to:", domainContract.address);
  console.log("Contract deployed by:", owner.address);

  let txn;

  const tryTx = async (title, cmd, ...args) => {
    console.log(`\n# ${title} \n`);
    try {
      txn = await cmd(...args);
      await txn.wait();
    } catch (err) {
      console.log(err.message || "Tx Error");
    }
  };

  const name = "yamahaha";

  await tryTx("register", domainContract.register, name, {
    value: hre.ethers.utils.parseEther("0.1"),
  });

  const domainAddress = await domainContract.getAddress(name);
  console.log(`Owner of domain ${name}:`, domainAddress);

  // How much money is in here?
  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));

  // Quick! Grab the funds from the contract! (as superCoder)
  await tryTx("withdraw", domainContract.connect(randomPerson).withdraw);
  console.log("Could not rob contract");

  // Let's look in their wallet so we can compare later
  let ownerBalance = await hre.ethers.provider.getBalance(owner.address);
  console.log(
    "Balance of owner before withdrawal:",
    hre.ethers.utils.formatEther(ownerBalance)
  );

  // Oops, looks like the owner is saving their money!
  await tryTx("withdraw", domainContract.connect(owner).withdraw);
  await txn.wait();

  // Fetch balance of contract & owner
  const contractBalance = await hre.ethers.provider.getBalance(
    domainContract.address
  );
  ownerBalance = await hre.ethers.provider.getBalance(owner.address);

  console.log(
    "Contract balance after withdrawal:",
    hre.ethers.utils.formatEther(contractBalance)
  );
  console.log(
    "Balance of owner after withdrawal:",
    hre.ethers.utils.formatEther(ownerBalance)
  );

  await tryTx("register", domainContract.register, name, {
    value: hre.ethers.utils.parseEther("0.1"),
  });

  await tryTx(
    "setRecord",
    domainContract.connect(randomPerson).setRecord,
    name,
    "Haha my domain now!"
  );

  // const balance = await hre.ethers.provider.getBalance(domainContract.address);
  // console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
