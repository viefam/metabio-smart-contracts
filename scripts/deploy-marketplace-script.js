// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Deploy marketplace
  const MetaBioMarketPlace = await hre.ethers.getContractFactory(
    "MetaBioMarketPlace"
  );
  const marketplace = await MetaBioMarketPlace.deploy();

  await marketplace.deployed();

  console.log("MetaBioMarketPlace deployed to:", marketplace.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
