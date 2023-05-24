require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const dotenv = require("dotenv");
dotenv.config();

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const deployers =
  process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [""];


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.12",
  networks: {
    mumbai: {
      url: process.env.ALCHEMY_MUMBAI_URL || "",
      accounts: deployers,
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGONSCAN_KEY,
    },
  },
};
