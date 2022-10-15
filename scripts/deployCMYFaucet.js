const hre = require("hardhat");

async function main() {
  const CmyFaucet = await hre.ethers.getContractFactory("CMYFaucet");
  const cmyfaucet = await CmyFaucet.deploy(
    "0x625775D61ea906abB808e18269c1Aeaca3Cde1DE"
  );
  await cmyfaucet.deployed();

  console.log("CMY Faucet deployed in goerli: ", cmyfaucet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// 0x85105612FC719c11E1a5D20c6Af723ff10C108bB
