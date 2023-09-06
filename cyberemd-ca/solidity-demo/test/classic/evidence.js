const { expect } = require("chai");

describe("Classic Evidence", () => {
    it("Should fullfill signs", async () => {
        const [_, addr1, addr2, addr3] = await ethers.getSigners();
        const users = [addr1, addr2, addr3]
        const factory = await ethers.deployContract("EvidenceFactory", [users.map(e => e.address)]);
        const eviKey = "lamborghini";
        const eviData = "god send me a lamborghini"

        await factory.connect(addr1).addEvidence(eviKey, eviData)
        expect(await factory.getSignersLen()).to.equal(3);
        expect(await factory.getSigner(0)).to.equal(addr1.address);
        const evis = await factory.getEvidence(eviKey);
        expect(evis[0]).to.equal(eviData);

        expect(await factory.getIsAllSigned(eviKey)).to.equal(false);
        for (let i = 0; i < users.length; i++) {
            await expect(factory.connect(users[i]).sign(eviKey))
                .to.emit(factory, "Sign").withArgs(users[i].address, eviKey);
        }
        expect(await factory.getIsAllSigned(eviKey)).to.equal(true);
    });
    it("Should revert with invalid args", async () => {
        const [_, addr1, addr2, addr3] = await ethers.getSigners();
        const users = [addr1, addr2]
        const factory = await ethers.deployContract("EvidenceFactory", [users.map(e => e.address)]);
        const eviKey = "lamborghini";
        const eviData = "god send me a lamborghini"

        await expect(factory.addEvidence(eviKey, eviData)).to.be.revertedWith(
            "invalid signer"
        );
        await factory.connect(addr1).addEvidence(eviKey, eviData)
        await expect(factory.sign(eviKey)).to.be.revertedWith(
            "invalid signer"
        );
        factory.connect(addr1).sign(eviKey)
        await expect(factory.connect(addr3).sign(eviKey)).to.be.revertedWith(
            "invalid signer"
        );
    });
});
