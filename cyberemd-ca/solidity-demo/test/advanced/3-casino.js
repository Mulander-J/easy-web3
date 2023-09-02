const { time } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Casino Demo", () => {
    it("Check Deploy", async () => {
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const contract = await ethers.deployContract(
            "casino_demo",
            [endTime],
        );
        const [_] = await ethers.getSigners();

        expect(await contract.isFinished()).to.equal(false);
        expect(await contract.endTime()).to.equal(endTime);
        expect(await contract.owner()).to.equal(_.address);
    })
    it("Play Game", async () => {
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const contract = await ethers.deployContract(
            "casino_demo",
            [endTime],
        );
        const [_, user, user2, user3, user4] = await ethers.getSigners();
        const users = [user, user2, user3, user4];

        const beforBalances = [
            await ethers.provider.getBalance(contract),
            await ethers.provider.getBalance(user.address),
            await ethers.provider.getBalance(user2.address),
            await ethers.provider.getBalance(user3.address),
            await ethers.provider.getBalance(user4.address),
        ]

        await expect(contract.connect(user).bet(true, { value: 0 })).to.be.revertedWith(
            "val should be positive"
        );

        for (let i = 0; i < users.length; i++) {
            const choice = i % 2 == 0;
            const amount = ethers.parseEther('10');
            await expect(contract.connect(users[i]).bet(choice, { value: amount }))
                .to.emit(contract, "Bet").withArgs(users[i].address, amount, choice);
        }

        await expect(contract.connect(_).open()).to.be.revertedWith(
            "time is not end"
        );
        await time.increaseTo(endTime);
        await expect(contract.connect(user).bet(true, { value: ethers.parseEther('10') })).to.be.revertedWith(
            "time is end"
        );
        await expect(contract.connect(_).open())
            .to.emit(contract, "Open");
        await expect(contract.connect(user).bet(true, { value: ethers.parseEther('10') })).to.be.revertedWith(
            "bet is finished"
        );
        expect(await ethers.provider.getBalance(contract)).to.equal(
            ethers.parseEther(String((10 + 10) * 10 / 100))
        );

        const afterBalances = [
            await ethers.provider.getBalance(contract),
            await ethers.provider.getBalance(user.address),
            await ethers.provider.getBalance(user2.address),
            await ethers.provider.getBalance(user3.address),
            await ethers.provider.getBalance(user4.address),
        ]

        console.log("# before balance");
        console.table(beforBalances.map(e => ethers.formatEther(e)));
        console.log("# after balance");
        console.table(afterBalances.map(e => ethers.formatEther(e)));
    });
});