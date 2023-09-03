const { expect } = require("chai");

describe("ERC165 Mapping Implementation", ()=> {
    it("Should return boolean by interfaceID", async function () {
        const erc165 = await ethers.deployContract("ERC165MappingImplementation");
        expect(await erc165.supportsInterface('0x01ffc9a7')).to.equal(true);
        expect(await erc165.supportsInterface('0xffffffff')).to.equal(false);
    });
});