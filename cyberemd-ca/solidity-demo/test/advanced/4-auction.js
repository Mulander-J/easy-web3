const { time } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Auction Demo", () => {
    it("Check Deploy", async () => {
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const [_, seller] = await ethers.getSigners();
        const contract = await ethers.deployContract(
            "auction_demo",
            [seller, endTime, 0, 0],
        );

        expect(await contract.isFinished()).to.equal(false);
        expect(await contract.endTime()).to.equal(endTime);
        expect(await contract.seller()).to.equal(seller.address);
        expect(await contract.hightestPrice()).to.equal(0);
        expect(await contract.aType()).to.equal(0);
    })
    it("Zero Bit", async () => {
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const [_, seller] = await ethers.getSigners();
        const contract = await ethers.deployContract(
            "auction_demo",
            [seller, endTime, 0, 0],
        );
        await time.increaseTo(endTime);
        await expect(contract.connect(_).close()).to.be.revertedWith(
            "no one bit"
        );
    })
    it("Fixed Bit", async () => {
        const fixedBid = 10;
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const [_, seller, user1, user2, user3] = await ethers.getSigners();
        const contract = await ethers.deployContract(
            "auction_demo",
            [seller, endTime, ethers.parseEther(String(fixedBid)), 1],
        );

        const users = [user1, user2, user3];
        let amount, base;
        for (let i = 0; i < users.length; i++) {
            base = 10 + fixedBid * i;
            amount = ethers.parseEther(String(base));
            await expect(contract.connect(users[i]).bid({ value: amount }))
                .to.emit(contract, "Bid").withArgs(users[i].address, amount);
        }
        await expect(contract.connect(user1).bid({ value: 1 })).to.be.revertedWith(
            "fixed value not match"
        );
        await expect(contract.connect(user1).bid({ value: ethers.parseEther("1000") })).to.be.revertedWith(
            "fixed value not match"
        );
        await time.increaseTo(endTime);


        await expect(contract.connect(user3).close()).to.changeEtherBalances(
            [contract, seller],
            [-amount, ethers.parseEther(String(base * .9))]
        );
    })
    it("Free Bit", async () => {
        const FIVE_MINUTE_IN_SECS = 5 * 60;
        const endTime = (await time.latest()) + FIVE_MINUTE_IN_SECS;
        const [_, seller, user1, user2, user3] = await ethers.getSigners();
        const contract = await ethers.deployContract(
            "auction_demo",
            [seller, endTime, 0, 0],
        );

        const getNewBalances = async () => ([
            await ethers.provider.getBalance(seller.address),
            await ethers.provider.getBalance(user1.address),
            await ethers.provider.getBalance(user2.address),
            await ethers.provider.getBalance(user3.address),
        ])

        const beforBalances = await getNewBalances()

        await expect(contract.connect(_).close()).to.be.revertedWith(
            "bit is ongoing"
        );
        await expect(contract.connect(user1).bid({ value: 0 })).to.be.revertedWith(
            "value should be positive"
        );

        const users = [user1, user2, user3];
        let amount, base = 10;
        for (let i = 0; i < users.length; i++) {
            base += Math.random() * 20
            amount = ethers.parseEther(String(base));
            await expect(contract.connect(users[i]).bid({ value: amount }))
                .to.emit(contract, "Bid").withArgs(users[i].address, amount);
        }

        await expect(contract.connect(user1).bid({ value: ethers.parseEther(String(base - 1)) })).to.be.revertedWith(
            "value is lt than bid"
        );
        await expect(contract.connect(_).close()).to.be.revertedWith(
            "bit is ongoing"
        );
        await time.increaseTo(endTime);
        await expect(contract.connect(user1).bid({ value: 0 })).to.be.revertedWith(
            "bit is over time"
        );
        await expect(contract.connect(_).close())
            .to.emit(contract, "Win").withArgs(user3.address, amount);

        await expect(contract.connect(_).close()).to.be.revertedWith(
            "auction is end"
        );
        await expect(contract.connect(user1).bid({ value: 0 })).to.be.revertedWith(
            "auction is end"
        );
        expect(await ethers.provider.getBalance(contract)).to.equal(0);

        const afterBalances = await getNewBalances()

        console.log("# before balance");
        console.table(beforBalances.map(e => ethers.formatEther(e)));
        console.log("# after balance");
        console.table(afterBalances.map(e => ethers.formatEther(e)));
    });
});