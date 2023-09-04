const { expect } = require("chai");

describe("Upgrade Demo", () => {
    describe("Master-Slave", () => {
        it("Should set the right age", async () => {
            const logic = await ethers.deployContract("ageSlave");
            const main = await ethers.deployContract("ageMaster", [logic]);
            let age = 42;
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
            age = 24;
            await logic.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
        });
        it("Should upgrade success", async () => {
            const logic = await ethers.deployContract("ageSlave");
            const main = await ethers.deployContract("ageMaster", [logic]);
            let age = 42;
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
            const logic2 = await ethers.deployContract("ageSlave");
            await main.upgrade(logic2);
            expect(await main.getAge()).to.equal(0);
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
        });
    })
    describe("Master-Slave Interface", () => {
        it("Should set the right age", async () => {
            const logic = await ethers.deployContract("ageSlaveImp");
            const main = await ethers.deployContract("ageMasterImp", [logic]);
            let age = 42;
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
            age = 24;
            await logic.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
        });
        it("Should upgrade success", async () => {
            const logic = await ethers.deployContract("ageSlaveImp");
            const main = await ethers.deployContract("ageMasterImp", [logic]);
            let age = 42;
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
            const logic2 = await ethers.deployContract("ageSlaveImp");
            await main.upgrade(logic2);
            expect(await main.getAge()).to.equal(0);
            await main.setAge(age);
            expect(await main.getAge()).to.equal(age);
            expect(await logic.getAge()).to.equal(age);
        });
    })
});
