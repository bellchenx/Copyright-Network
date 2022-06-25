/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-truffle5");
require("@nomiclabs/hardhat-waffle");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
   const accounts = await hre.ethers.getSigners();
   for (const account of accounts) {
     console.log(account.address);
   }
 });

module.exports = {
  solidity: "0.8.15",
  paths: {
    artifacts: "./src/backend/artifacts",
    sources: "./src/backend/contracts",
    cache: "./src/backend/cache",
    tests: "./src/backend/test"
  },
  defaultNetwork: "localhost",
   networks: {
      hardhat: {
        // blockGasLimit: 0x1fffffffffffff,
        // allowUnlimitedContractSize: true,
      },
      /*
      mumbai: {
         url: process.env.API_URL_MUMBAI,
         accounts: [process.env.PRIVATE_KEY],
      }
      */
   },
};
