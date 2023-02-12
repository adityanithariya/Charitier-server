const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { deploy } = require("../scripts/deploy");

describe("Charitier", function () {
    describe("Deployment", function () {
        beforeEach(async () => {
            await loadFixture(deploy);
        })
        it("Check if NGOContract inherited", async () => {
            const contract = await loadFixture(main.deploy);
        });
    });
});
