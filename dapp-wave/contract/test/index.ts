import { expect } from "chai";
import { ethers } from "hardhat";

describe("FestNFT", function () {
  it("Should return the new tokenId once it's minted", async function () {
    const FestNFT = await ethers.getContractFactory("FestNFT");
    const _festNFT = await FestNFT.deploy();
    await _festNFT.deployed();

    expect(await _festNFT.mintFest()).to.equal(0);

    expect(await _festNFT.mintFest()).to.equal(1);
  });
});
