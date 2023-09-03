const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("ERC20 Token contract", function () {
    const ZeroAddr = '0x0000000000000000000000000000000000000000';
    async function deployTokenFixture() {
        const erc721NFT = await ethers.deployContract("ERC721");
        const [owner, addr1, addr2] = await ethers.getSigners();
        return { erc721NFT, owner, addr1, addr2 };
    }
    describe("Mint", () => {
        it("Should mint awith events", async () => {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            await expect(erc721NFT.mint(owner, 1, ethers.toUtf8Bytes('0x001')))
                .to.emit(erc721NFT, "Transfer").withArgs(ZeroAddr, owner.address, 1);
            expect(await erc721NFT.balanceOf(owner.address)).to.equal(1);

            await expect(erc721NFT.mint(addr1, 2, ethers.toUtf8Bytes('0x002')))
                .to.emit(erc721NFT, "Transfer").withArgs(ZeroAddr, addr1.address, 2);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(1);
            await expect(erc721NFT.mint(addr1, 3, ethers.toUtf8Bytes('0x003')))
                .to.emit(erc721NFT, "Transfer").withArgs(ZeroAddr, addr1.address, 3);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(2);
        });
    })
    describe("Approval", () => {
        it("Should approve tokens with events", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));
            expect(await erc721NFT.getApproved(tokenId)).to.equal(ZeroAddr);
            await expect(erc721NFT.approve(addr1.address, tokenId))
                .to.emit(erc721NFT, "Approval").withArgs(owner.address, addr1.address, tokenId);
            expect(await erc721NFT.getApproved(tokenId)).to.equal(addr1.address);
        });
        it("Should approve for all with events", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));
            expect(await erc721NFT.isApprovedForAll(owner.address, addr1.address)).to.equal(false);
            await expect(erc721NFT.setApprovalForAll(addr1.address, true))
                .to.emit(erc721NFT, "ApprovalForAll").withArgs(owner.address, addr1.address, true);
            expect(await erc721NFT.isApprovedForAll(owner.address, addr1.address)).to.equal(true);
            await expect(erc721NFT.connect(addr1).approve(addr1.address, tokenId))
                .to.emit(erc721NFT, "Approval").withArgs(owner.address, addr1.address, tokenId);
            await expect(erc721NFT.setApprovalForAll(addr1.address, false))
                .to.emit(erc721NFT, "ApprovalForAll").withArgs(owner.address, addr1.address, false);
            expect(await erc721NFT.isApprovedForAll(owner.address, addr1.address)).to.equal(false);
        });
        it("Should fail case", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));

            await expect(
                erc721NFT.connect(addr1).approve(addr1.address, tokenId)
            ).to.be.revertedWith("not owner nor approved operator");
            await expect(
                erc721NFT.connect(addr1).approve(addr1.address, tokenId + 1)
            ).to.be.revertedWith("not owner nor approved operator");
            await expect(
                erc721NFT.connect(owner).approve(owner.address, tokenId + 1)
            ).to.be.revertedWith("not owner nor approved operator");
        });

    })
    describe("TransferFrom", () => {
        it("Should transfer tokens with approval", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));

            expect(await erc721NFT.ownerOf(tokenId)).to.equal(owner.address);
            expect(await erc721NFT.balanceOf(owner.address)).to.equal(1);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(0);
            await erc721NFT.approve(addr1.address, tokenId);
            await erc721NFT.transferFrom(owner.address, addr1.address, tokenId);
            expect(await erc721NFT.ownerOf(tokenId)).to.equal(addr1.address);
            expect(await erc721NFT.balanceOf(owner.address)).to.equal(0);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(1);
        });
        it("Should transfer tokens with all-approval", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));

            expect(await erc721NFT.ownerOf(tokenId)).to.equal(owner.address);
            expect(await erc721NFT.balanceOf(owner.address)).to.equal(1);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(0);
            await erc721NFT.setApprovalForAll(addr1.address, true);
            expect(await erc721NFT.getApproved(tokenId)).to.equal(ZeroAddr);
            await erc721NFT.transferFrom(owner.address, addr1.address, tokenId);
            expect(await erc721NFT.ownerOf(tokenId)).to.equal(addr1.address);
            expect(await erc721NFT.balanceOf(owner.address)).to.equal(0);
            expect(await erc721NFT.balanceOf(addr1.address)).to.equal(1);
        });
        it("Should fail case", async function () {
            const { erc721NFT, owner, addr1 } = await loadFixture(deployTokenFixture);
            const tokenId = 1;
            await erc721NFT.mint(owner, tokenId, ethers.toUtf8Bytes('0x001'));

            await expect(
                erc721NFT.transferFrom(addr1.address, owner.address, tokenId)
            ).to.be.revertedWith("_form is not owner");
            await expect(
                erc721NFT.transferFrom(owner.address, addr1.address, tokenId + 1)
            ).to.be.revertedWith("_form is not owner");
            await expect(
                erc721NFT.connect(addr1).transferFrom(owner.address, addr1.address, tokenId)
            ).to.be.revertedWith("not owner nor approved operator");
        });

    })
});