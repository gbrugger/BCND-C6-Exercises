var Test = require("../config/testConfig.js");

contract("ExerciseC6A", async accounts => {
  var config;
  before("setup contract", async () => {
    config = await Test.Config(accounts);
  });

  // it("contract owner can register new user", async () => {
  //   // ARRANGE
  //   let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
  //   let newUser = config.testAddresses[0];

  //   // ACT
  //   await config.exerciseC6A.registerUser(newUser, false, { from: caller });
  //   let result = await config.exerciseC6A.isUserRegistered.call(newUser);

  //   // ASSERT
  //   assert.equal(result, true, "Contract owner cannot register new user");
  // });

  it("should deactivate the contract by M-of-N", async () => {
    const caller = accounts[0];
    for (const x of Array(5).keys()) {
      await config.exerciseC6A.registerUser(accounts[x], true, {
        from: caller,
      });
    }
    for (const x of Array(3).keys()) {
      await config.exerciseC6A.setActive({ from: accounts[x] });
    }
    let active = await config.exerciseC6A.isActive();
    assert.equal(active, false, "Contract not deactivated");

    for (const x of Array(3).keys()) {
      await config.exerciseC6A.setActive({ from: accounts[x] });
    }
    active = await config.exerciseC6A.isActive();
    assert.equal(active, true, "Contract not reactivated");

    for (const x of Array(2).keys()) {
      await config.exerciseC6A.setActive({ from: accounts[x] });
    }
    active = await config.exerciseC6A.isActive();
    assert.equal(
      active,
      true,
      "Contract deactivated with less than 3 approvals"
    );
  });

  // it("should not deactivate the contract by anyone", async () => {
  //   const caller = accounts[1]; //not owner
  //   try {
  //     await config.exerciseC6A.setActive({ from: caller });
  //     assert(false); // If it doesn't throw, it must fail.
  //   } catch (err) {
  //     assert(err);
  //   }
  //   // const active = await config.exerciseC6A.isActive();
  //   // assert.equal(active, false, "Contract not deactivated");
  // });

  // it("should not register user by owner while inactive", async () => {
  //   const caller = accounts[0];
  //   const newUser = config.testAddresses[0];
  //   await config.exerciseC6A.setActive({ from: caller });
  //   let active = await config.exerciseC6A.isActive();
  //   assert.equal(active, false, "Contract not deactivated");

  //   try {
  //     await config.exerciseC6A.registerUser(newUser, false, { from: caller });
  //   } catch (error) {
  //     assert(error);
  //   }
  // });
});
