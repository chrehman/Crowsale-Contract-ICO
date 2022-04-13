
import { ethers } from "hardhat";

async function main() {
  // const PakoToken = await ethers.getContractFactory("PakoToken");
  // const pakoToken = await PakoToken.deploy(1000000);

  // await pakoToken.deployed();

  // console.log("Pako Token deployed to:", pakoToken.address);
  console.log("Ethers",ethers.utils.formatEther("1").toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
