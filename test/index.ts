import { expect } from "chai";
import { ethers } from "hardhat";

describe("Greeter", () => {

  it("Crowdsale Contract has 75% token and owner has 25% totalSupply of PakoToken", async function () {
    const [owner, user1] = await ethers.getSigners();
    const PakoToken = await ethers.getContractFactory("PakoToken");
    const pakoToken = await PakoToken.connect(owner).deploy(1000);
    await pakoToken.deployed();

    const Crowdsale = await ethers.getContractFactory("Crowdsale");
    const crowdsale = await Crowdsale.connect(owner).deploy("10000000000000000", pakoToken.address);
    await crowdsale.deployed();

    await pakoToken.transfer(crowdsale.address, ethers.utils.parseEther("750"));
    const crowdSaleBalance=await (await pakoToken.balanceOf(crowdsale.address));
    expect(crowdSaleBalance).to.equal(ethers.utils.parseEther("750"));
    const ownerBalance=await pakoToken.balanceOf(owner.address);

    expect(ownerBalance).to.equal(ethers.utils.parseEther("250"));

  });
});
