import { ethers } from "hardhat";

async function main() {
  const Charitier = await ethers.getContractFactory("Charitier");
  const charitier = await Charitier.deploy();

  await charitier.deployed();

  console.log(`Deployed to ${charitier.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
