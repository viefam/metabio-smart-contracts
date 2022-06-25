// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers, upgrades } = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const MetaBioAudit = await ethers.getContractFactory("MetaBioAudit");
  const votingDelay = 0; // seconds
  const votingPeriod = 120; // seconds
  const proposalThreshold = 100; // tokens
  const quorumFaction = 30; // %

  const metaBioAudit = await upgrades.deployProxy(
    MetaBioAudit,
    [
      "MetaBioAuditors",
      "https://stag.proxy.viefam.com/nfpot/XGyYwclMAq",
      [
        "0x6ed5429a8A73947d7aE4264D9484B43537BCB200",
        "0x53E66b4a3af5392a228891455082232b07903C3D",
      ],
      "0x833cFF7b30b1EB55fF59aC81fd9879d5dCF5A836",
      votingDelay,
      votingPeriod,
      proposalThreshold,
      quorumFaction,
    ],
    {
      initializer: "initialize",
    }
  );

  await metaBioAudit.deployed();

  console.log("MetaBioAudit deployed to:", metaBioAudit.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
