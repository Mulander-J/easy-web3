const { expect } = require("chai");

describe("Factory Demo", () => {
    it("Should set the right name", async () => {
        const factory = await ethers.deployContract("factory_demo");
        const carName = "lamborghini";
        await factory.addCar(carName);
        expect(await factory.getName(0)).to.equal(carName);
    });
    it("Should act same as direct call", async () => {
        const factory = await ethers.deployContract("factory_demo");
        const carName = "lamborghini";
        await factory.addCar(carName);
        expect(await factory.getName(0)).to.equal(carName);
        const theCar = new ethers.Contract(await factory.allCars(0), [{
            "inputs": [
                {
                    "internalType": "string",
                    "name": "_name",
                    "type": "string"
                }
            ],
            "stateMutability": "nonpayable",
            "type": "constructor"
        },
        {
            "inputs": [],
            "name": "getName",
            "outputs": [
                {
                    "internalType": "string",
                    "name": "",
                    "type": "string"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        }],ethers.provider);
        expect(await theCar.getName()).to.equal(carName);
    });
    it("Should revert with invalid args", async () => {
        const factory = await ethers.deployContract("factory_demo");
        const carName = "lamborghini";
        await factory.addCar(carName);
        expect(await factory.getName(0)).to.equal(carName);
        await expect(factory.getName(1)).to.be.revertedWith(
            "_index invalid"
        );
    });
});
