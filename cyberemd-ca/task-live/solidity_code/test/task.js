const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("Task Contract", function () {
    it("Should fullfill all status of task", async () => {
        // deplot & intial token
        const InitialNat = 1e18;
        const InitialEther = ethers.parseEther(String(InitialNat));
        const erc20Token = await ethers.deployContract("ERC20", ["TaskToken", "TskT", 18]);
        const task = await ethers.deployContract("Task", [erc20Token]);

        // mint token to task contract
        await erc20Token.mint(task, InitialEther);
        expect(await erc20Token.balanceOf(task)).to.equal(InitialEther);

        // get accounts
        const [_, addr1, addr2] = await ethers.getSigners();

        // register
        const RegisterNat = 100;
        const RegisterAmount = ethers.parseEther(String(RegisterNat));
        // register
        await task.register(addr1.address);
        expect(await erc20Token.balanceOf(addr1.address)).to.equal(RegisterAmount);

        // issue task
        const bonus = RegisterAmount / 10n;
        const intro = 'First Task';
        const index = 0;
        await expect(task.connect(addr1).issue(bonus, intro))
            .to.emit(task, "NewTask").withArgs(addr1.address, index, intro, bonus);

        // take task
        await expect(task.connect(addr2).take(index))
            .to.emit(task, "TaskUpdate").withArgs(addr2.address, index, 1);

        // take task
        await expect(task.connect(addr2).commit(index))
            .to.emit(task, "TaskUpdate").withArgs(addr2.address, index, 2);

        // approve token
        await erc20Token.connect(addr1).approve(task, bonus);
        //  settled task
        await expect(task.connect(addr1).settled(index, "", true))
            .to.emit(task, "TaskUpdate").withArgs(addr1.address, index, 3);
        expect(await erc20Token.balanceOf(addr2.address)).to.equal(bonus);
    });
});