const { expect } = require("chai");

const ZeroAddr = '0x0000000000000000000000000000000000000000';

describe("Classic Marriage", () => {
    describe("Marriage Factory", () => {
        it("Should fullfill signs", async () => {
            const [_, addr1, addr2] = await ethers.getSigners();
            const users = [addr1, addr2]
            const factory = await ethers.deployContract("MarriageFactory");
            const eviKey = "love";
            const eviData = "god send me a wife"

            await factory.addEvidence(eviKey, eviData, addr1.address, addr2.address);
            const evis = await factory.getEvidence(eviKey);
            expect(evis[0]).to.equal(eviData);

            expect(await factory.isAllSigned(eviKey)).to.equal(false);
            for (let i = 0; i < users.length; i++) {
                await factory.connect(users[i]).sign(eviKey)
            }
            expect(await factory.isAllSigned(eviKey)).to.equal(true);
        });
        it("Should revert with invalid args", async () => {
            const [_, addr1, addr2, addr3] = await ethers.getSigners();
            const factory = await ethers.deployContract("MarriageFactory");
            const eviKey = "love";
            const eviData = "god send me a wife"

            await expect(factory.connect(addr1).addEvidence(eviKey, eviData, addr1.address, addr2.address)).to.be.revertedWith(
                "sender can't be verifier"
            );
            await expect(factory.connect(addr1).addEvidence(eviKey, eviData, ZeroAddr, addr2.address)).to.be.revertedWith(
                "invalid zero addreess"
            );
            await expect(factory.connect(addr1).addEvidence(eviKey, eviData, addr1.address, ZeroAddr)).to.be.revertedWith(
                "invalid zero addreess"
            );
            await factory.addEvidence(eviKey, eviData, addr1.address, addr2.address);
            factory.connect(addr1).sign(eviKey)
            await expect(factory.connect(addr3).sign(eviKey)).to.be.revertedWith(
                "invalid signer"
            );
        });
    })
    describe("Marriage Mixed", () => {
        it("Should fullfill signs", async () => {
            const [_, addr1, addr2] = await ethers.getSigners();
            const users = [addr1, addr2]
            const factory = await ethers.deployContract("marriage_demo");
            const eviKey = "love";
            const eviData = "god send me a wife"

            await factory.issueEvidence(eviKey, eviData, addr1.address, addr2.address);
            const evis = await factory.getEvidence(eviKey);
            expect(evis[0]).to.equal(eviData);

            expect(await factory.isAllSigned(eviKey)).to.equal(false);
            for (let i = 0; i < users.length; i++) {
                await factory.connect(users[i]).sign(eviKey)
            }
            expect(await factory.isAllSigned(eviKey)).to.equal(true);
        });
        it("Should revert with invalid args", async () => {
            const [_, addr1, addr2, addr3] = await ethers.getSigners();
            const factory = await ethers.deployContract("marriage_demo");
            const eviKey = "love";
            const eviData = "god send me a wife"

            await expect(factory.connect(addr1).issueEvidence(eviKey, eviData, addr1.address, addr2.address)).to.be.revertedWith(
                "not witness"
            );
            await expect(factory.connect(_).issueEvidence(eviKey, eviData, _.address, addr2.address)).to.be.revertedWith(
                "sender can't be verifier"
            );
            await expect(factory.connect(_).issueEvidence(eviKey, eviData, ZeroAddr, addr2.address)).to.be.revertedWith(
                "invalid zero addreess"
            );
            await expect(factory.connect(_).issueEvidence(eviKey, eviData, addr1.address, ZeroAddr)).to.be.revertedWith(
                "invalid zero addreess"
            );
            await factory.issueEvidence(eviKey, eviData, addr1.address, addr2.address);
            factory.connect(addr1).sign(eviKey)
            await expect(factory.connect(addr3).sign(eviKey)).to.be.revertedWith(
                "invalid signer"
            );
        });
    })
});
