const { expect } = require("chai");

describe("RedPacket Demo", () => {
    it("Avg Take", async () => {
        let tol = 8;
        const count = 4;
        const part = tol / count;
        const tolAmout = ethers.parseEther(String(8));
        const contract = await ethers.deployContract(
            "redpacket_demo",
            [true, count],
            { value: tolAmout }
        );

        expect(await contract.isArg()).to.equal(true);
        expect(await contract.count()).to.equal(count);
        expect(await contract.tol()).to.equal(tolAmout);

        const [_, user, user2, user3] = await ethers.getSigners();
        const users = [_, user, user2, user3];
        for (let i = 0; i < users.length; i++) {
            const tx = await contract.connect(users[i]).take();
            await tx.wait();
            tol -= part;
            expect(await contract.checkTaken(users[i])).to.equal(true);
            expect(await contract.tol()).to.equal(ethers.parseEther(String(tol)));
        }
        expect(await contract.tol()).to.equal(0);
    });

    it("Random Take", async () => {
        const count = 4;
        const tolAmout = ethers.parseEther("8");
        const contract = await ethers.deployContract(
            "redpacket_demo",
            [false, count],
            { value: tolAmout }
        );

        expect(await contract.isArg()).to.equal(false);
        expect(await contract.count()).to.equal(count);
        expect(await contract.tol()).to.equal(tolAmout);

        const [_, user, user2, user3] = await ethers.getSigners();
        const users = [_, user, user2, user3];
        for (let i = 0; i < users.length; i++) {
            const beforeTol = await contract.tol();
            const tx = await contract.connect(users[i]).take();
            await tx.wait();
            const afterTol = await contract.tol();
            expect(await contract.checkTaken(users[i])).to.equal(true);
            console.log("Randoms:", [beforeTol, afterTol, beforeTol - afterTol]);
        }
        expect(await contract.tol()).to.equal(0);
    });

    it("Revert ReTaken", async () => {
        const MAX = 2;
        const contract = await ethers.deployContract(
            "redpacket_demo",
            [true, MAX],
            { value: ethers.parseEther("4") }
        );
        const [_, user, user2] = await ethers.getSigners();

        const tx = await contract.connect(_).take();
        await tx.wait();
        await expect(contract.connect(_).take()).to.be.revertedWith(
            "user already taken once"
        );
        const tx2 = await contract.connect(user).take();
        await tx2.wait();
        await expect(contract.connect(user2).take()).to.be.revertedWith(
            "packets is out"
        );
    });
});
