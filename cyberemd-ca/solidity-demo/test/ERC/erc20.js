const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("ERC20 Token contract", function () {
    const ZeroAddr = '0x0000000000000000000000000000000000000000';
    const InitialAmount = 1000;
    async function deployTokenFixture() {
        const erc20Token = await ethers.deployContract("ERC20", ["TestToken", "TT", 18]);
        const [owner, addr1, addr2] = await ethers.getSigners();
        return { erc20Token, owner, addr1, addr2 };
    }
    describe("Mint", () => {
        it("Should mint and update totalSupply with events", async () => {
            const { erc20Token, owner, addr1 } = await loadFixture(deployTokenFixture);
            await expect(erc20Token.mint(owner, String(InitialAmount)))
                .to.emit(erc20Token, "Transfer").withArgs(ZeroAddr, owner.address, InitialAmount);
            expect(await erc20Token.balanceOf(owner.address)).to.equal(InitialAmount);
            expect(await erc20Token.totalSupply()).to.equal(InitialAmount);

            await expect(erc20Token.mint(addr1, String(50)))
                .to.emit(erc20Token, "Transfer").withArgs(ZeroAddr, addr1.address, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(50);
            expect(await erc20Token.totalSupply()).to.equal(InitialAmount + 50);
        });
    })
    describe("Transfer", () => {
        it("Should transfer tokens between accounts", async function () {
            const { erc20Token, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
            await erc20Token.mint(owner, String(InitialAmount));
            // Transfer 50 tokens from owner to addr1
            await erc20Token.transfer(addr1.address, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(50);

            // Transfer 50 tokens from addr1 to addr2
            await erc20Token.connect(addr1).transfer(addr2.address, 50)
            expect(await erc20Token.balanceOf(addr2.address)).to.equal(50);
        });
        it("Should emit Transfer events", async function () {
            const { erc20Token, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
            await erc20Token.mint(owner, String(InitialAmount));
            // Transfer 50 tokens from owner to addr1
            await expect(erc20Token.transfer(addr1.address, 50))
                .to.emit(erc20Token, "Transfer").withArgs(owner.address, addr1.address, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(50);

            // Transfer 50 tokens from addr1 to addr2
            await expect(erc20Token.connect(addr1).transfer(addr2.address, 50))
                .to.emit(erc20Token, "Transfer").withArgs(addr1.address, addr2.address, 50);
            expect(await erc20Token.balanceOf(addr2.address)).to.equal(50);
        });
        it("Should fail case", async function () {
            const { erc20Token, owner, addr1 } = await loadFixture(deployTokenFixture);
            await erc20Token.mint(owner, String(InitialAmount));

            await expect(
                erc20Token.connect(addr1).transfer(ZeroAddr, 1)
            ).to.be.revertedWith("address is zero");

            await expect(
                erc20Token.connect(addr1).transfer(owner.address, 0)
            ).to.be.revertedWith("_value must > 0");

            // Try to send 1 token from addr1 (0 tokens) to owner.
            // `require` will evaluate false and revert the transaction.
            await expect(
                erc20Token.connect(addr1).transfer(owner.address, 1)
            ).to.be.revertedWith("balance not enough");

            // Owner balance shouldn't have changed.
            expect(await erc20Token.balanceOf(owner.address)).to.equal(
                InitialAmount
            );
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(0);
        });
        
    })
    describe("TransferFrom", () => {
        it("Should transfer tokens between accounts", async function () {
            const { erc20Token, addr1, addr2 } = await loadFixture(deployTokenFixture);
            await erc20Token.mint(addr1, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(50);
            await erc20Token.connect(addr1).approve(addr2.address, 50);
            expect(await erc20Token.allowance(addr1.address, addr2.address)).to.equal(50);
            await erc20Token.connect(addr2).transferFrom(addr1.address, addr2.address, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(0);
            expect(await erc20Token.balanceOf(addr2.address)).to.equal(50);
        });
        it("Should fail case", async function () {
            const { erc20Token, addr1, addr2 } = await loadFixture(deployTokenFixture);
            await erc20Token.mint(addr1, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(50);

            await expect(
                erc20Token.connect(addr2).transferFrom(addr1.address, addr2.address, 0)
            ).to.be.revertedWith("_value must > 0");
            await expect(
                erc20Token.connect(addr2).transferFrom(ZeroAddr, addr2.address, 1)
            ).to.be.revertedWith("address is zero");
            await expect(
                erc20Token.connect(addr2).transferFrom(addr1.address, ZeroAddr, 1)
            ).to.be.revertedWith("address is zero");
            await expect(
                erc20Token.connect(addr2).transferFrom(addr1.address, addr2.address, 100)
            ).to.be.revertedWith("balance not enough");
            await expect(
                erc20Token.connect(addr2).transferFrom(addr1.address, addr2.address, 50)
            ).to.be.revertedWith("allowance not enough");

            await erc20Token.connect(addr1).approve(addr2.address, 50);
            expect(await erc20Token.allowance(addr1.address, addr2.address)).to.equal(50);
            await erc20Token.connect(addr2).transferFrom(addr1.address, addr2.address, 50);
            expect(await erc20Token.balanceOf(addr1.address)).to.equal(0);
            expect(await erc20Token.balanceOf(addr2.address)).to.equal(50);
        });
        
    })

});