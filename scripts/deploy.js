const hre = require("hardhat");

async function main() {
  const Cmytoken = await hre.ethers.getContractFactory("CMYToken");
  const cmytoken = await Cmytoken.deploy(10000000, 12);
  await cmytoken.deployed();

  console.log("CMY token deployed in goerli: ", cmytoken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
