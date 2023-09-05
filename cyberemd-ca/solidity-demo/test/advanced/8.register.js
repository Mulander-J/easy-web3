const { expect } = require("chai");

describe("Register Demo", () => {
    it("Should set the right contract", async () => {
        const factory = await ethers.deployContract("factory_demo");
        const carName = "lamborghini";
        await factory.addCar(carName);
        expect(await factory.getName(0)).to.equal(carName);
        const register = await ethers.deployContract("register_demo");
        const [_] = await ethers.getSigners();
        const inputs = ["factory", factory, "0.0.1"];
        const outputs = [_.address, inputs[1].target, inputs[2]];
        await register.register(...inputs);
        const info = await register.getInfo(inputs[0]);
        outputs.forEach((e, i) => {
            expect(e).to.equal(info[i]);
        })

    });
});
