const { expect } = require("chai");

describe("Bank Demo", () => {
  const BANK_NAME = "MyBank";
  let bank

  beforeEach(async function () {
    bank = await ethers.deployContract("bank_demo", [BANK_NAME]);
  });

  it("Should set the right name", async () => {
    expect(await bank.bankName()).to.equal(BANK_NAME);
  });

  describe("Deposit", () => {
    it("Multi Deposit", async () => {
      const [_, user, user2] = await ethers.getSigners();

      const userIns = bank.connect(user);

      // first deposit
      const amount = ethers.parseEther("10");
      const tx = await userIns.deposit(amount, { value: amount });
      await tx.wait();
      expect(await bank.balanceOf(user)).to.equal(amount);
      expect(await bank.tol()).to.equal(amount);

      // second deposit
      const amount2 = ethers.parseEther("8.2");
      const tx2 = await userIns.deposit(amount2, { value: amount2 });
      await tx2.wait();
      expect(await bank.balanceOf(user)).to.equal(amount + amount2);
      expect(await bank.tol()).to.equal(amount + amount2);
      expect(await bank.balanceOf(user2)).to.equal(0);   
    });

    it("Revert Deposit", async ()=> {
      const [_, user] = await ethers.getSigners();
      const userIns = bank.connect(user);
      const amount = ethers.parseEther("10");
      const amount2 = ethers.parseEther("8.2");

      await expect(userIns.deposit(0, {value: amount2})).to.be.revertedWith("amount should lg than 0");
      await expect(userIns.deposit(amount, {value: amount2})).to.be.revertedWith("amount should equal amount");
    })
  });

  describe("Withdraw", () => {
    it("Multi Withdraw", async function () {
      const bank = await ethers.deployContract("bank_demo", [BANK_NAME]);
      const [_, user] = await ethers.getSigners();

      // deposit
      const amount = ethers.parseEther("10");
      const tx = await bank.connect(user).deposit(amount, { value: amount });
      await tx.wait();
      const amount2 = ethers.parseEther("8");
      const tx2 = await bank.connect(user).deposit(amount2, { value: amount2 });
      await tx2.wait();
      expect(await bank.balanceOf(user)).to.equal(amount + amount2);

      // withdraw
      const tx3 = await bank.connect(user).withdraw(amount);
      await tx3.wait();
      expect(await bank.balanceOf(user)).to.equal(amount2);
      expect(await bank.tol()).to.equal(amount2);
    });
    it("Revert Withdraw", async ()=> {
      const [_, user] = await ethers.getSigners();
      const userIns = bank.connect(user);
      const amount = ethers.parseEther("10");

      await expect(userIns.withdraw(0)).to.be.revertedWith("amount should lg than 0");
      await expect(userIns.withdraw(amount)).to.be.revertedWith("amount is not enough");
    })
  });

  describe("Transfer", () => {
    it("Multi Withdraw", async function () {
      const bank = await ethers.deployContract("bank_demo", [BANK_NAME]);
      const [_, user, user2] = await ethers.getSigners();

      // user1 deposit
      const amount = ethers.parseEther("10");
      const tx = await bank.connect(user).deposit(amount, { value: amount });
      await tx.wait();
      expect(await bank.balanceOf(user)).to.equal(amount);
      // user2 deposit
      const amount2 = ethers.parseEther("8");
      const tx2 = await bank.connect(user2).deposit(amount2, { value: amount2 });
      await tx2.wait();
      expect(await bank.balanceOf(user2)).to.equal(amount2);

      // transfer
      const tx3 = await bank.connect(user).transfer(user2, amount);
      await tx3.wait();
      expect(await bank.balanceOf(user)).to.equal(0);
      expect(await bank.balanceOf(user2)).to.equal(amount + amount2);
      expect(await bank.tol()).to.equal(amount + amount2);
    });
    it("Revert Transfer", async ()=> {
      const [_, user, user2] = await ethers.getSigners();
      const userIns = bank.connect(user);
      const amount = ethers.parseEther("10");

      await expect(userIns.transfer(user2, 0)).to.be.revertedWith("amount should lg than 0");
      await expect(userIns.transfer(user2, amount)).to.be.revertedWith("amount is not enough");
    })
  });
});
