const { expect } = require("chai");

describe("Classic Traces", () => {
    it("Should show traces", async () => {
        const factory = await ethers.deployContract("GoodsFactory");
        const [_, addr1, addr2] = await ethers.getSigners();
        const categoryId = await factory.genCID("cola");
        await expect(factory.newCategory(categoryId))
            .to.emit(factory, "NewCategory").withArgs(_.address, categoryId);
        const goodsId = 10001;
        await expect(factory.newGoods(categoryId, goodsId))
            .to.emit(factory, "NewGoods").withArgs(_.address, goodsId);
        expect(await factory.getStatus(categoryId, goodsId)).to.equal(0);

        const works = [
            { status: 0, remark: 'create', user: _ },
            { status: 1, remark: 'transfer', user: addr1 },
            { status: 2, remark: 'shelf', user: addr2 }
        ]
        for (let i = 1; i < works.length; i++) {
            let item = works[i]
            await factory.connect(item.user).setStatus(categoryId, goodsId, item.status, item.remark);
        }

        const traces = await factory.getTraces(categoryId, goodsId);

        for (let i = 0; i < works.length; i++) {
            let item = works[i]
            expect(traces[i][0]).to.equal(item.user.address);
            expect(traces[i][2]).to.equal(item.status);
            expect(traces[i][3]).to.equal(item.remark);
        }
    });
    it("Should revert with invalid args", async () => {
        const factory = await ethers.deployContract("GoodsFactory");
        const categoryId = await factory.genCID("cola");
        await factory.newCategory(categoryId);
        await expect(factory.newCategory(categoryId)).to.be.revertedWith(
            "_categoryId exists"
        );
        const categoryId2 = await factory.genCID("cola222");
        const goodsId = 10001;
        await expect(factory.newGoods(categoryId2, goodsId)).to.be.revertedWith(
            "_categoryId not exists"
        );
        await factory.newGoods(categoryId, goodsId);
        await expect(factory.newGoods(categoryId, goodsId)).to.be.revertedWith(
            "_goodsId exists"
        );
        await expect(factory.getStatus(categoryId,  goodsId+1)).to.be.revertedWith(
            "_goodsId not exists"
        );
    });
});
