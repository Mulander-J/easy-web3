const main = async () => {
  const tld = "ssr";

  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy(tld);
  await domainContract.deployed();

  console.log("Contract deployed to:", domainContract.address);

  // console.log("Sleeping.....");
  // // Wait for etherscan to notice that the contract has been deployed
  // await sleep(30000);

  // // Verify the contract after deploying
  // await hre.run("verify:verify",  {
  //   address: domainContract.address,
  //   constructorArguments: [tld],
  // });

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

  const name = "ssr";

  await tryTx("register", domainContract.register, name, {
    value: hre.ethers.utils.parseEther("0.1"),
  });
  console.log(`Minted domain ${name}.${tld}`);

  await tryTx(
    "setRecord",
    domainContract.setRecord,
    name,
    "Am I a banana or a ninja??"
  );
  console.log(`Set record for ${name}.${tld}`);

  const address = await domainContract.getAddress(name);
  console.log(`Owner of domain ${name}:`, address);

  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
};


// function sleep(ms) {
//   return new Promise((resolve) => setTimeout(resolve, ms));
// }

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
