const { expect } = require("chai");

describe("Upgrade Demo", () => {
    it("Should set the right player", async () => {
        const implementationV1 = await ethers.deployContract("implementationV1");
        const proxy = await ethers.deployContract("proxy");
        const [_,addr1, addr2] = await ethers.getSigners();

        await expect(implementationV1.connect(addr1).addPlayer(addr1.address, 42)).to.be.revertedWith(
            "only owner can do"
        );
        await proxy.setImpl(implementationV1);
        const proxiedV1 = await implementationV1.attach(proxy);

        let point = 42;
        await proxiedV1.addPlayer(addr1.address , point);
        expect(await proxiedV1.points(addr1.address)).to.equal(point);
        point = 24;
        await proxiedV1.addPlayer(addr2.address , point);
        expect(await proxiedV1.connect(addr2).points(addr2.address)).to.equal(point);
    });
});
