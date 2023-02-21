const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { writeFileSync, existsSync, mkdirSync } = require("fs");

describe("NGOContract", function () {
    before(async () => {
        const AdminContract = await ethers.getContractFactory("AdminContract");
        this.AdminContract = await AdminContract.deploy();

        await this.AdminContract.deployed();

        const NGOContract = await ethers.getContractFactory("NGOContract");
        this.NGOContract = await NGOContract.deploy(this.AdminContract.address);

        await this.NGOContract.deployed();
        const [owner] = await ethers.getSigners();
        this.owner = owner;
    });
    it("Successfull Deployment", async () => {
        expect(await this.NGOContract.addrs(1)).to.equal(
            this.AdminContract.address,
            "NGOContract doesn't have correct address of AdminContract"
        );
    });
    it("Create NGO", async () => {
        const args = [
            [
                this.owner.address,
                "uid",
                "reg_no",
                123,
                "pan_card",
                ["place", "city", "state", 302031],
                false,
                true,
            ],
            "reg_cert",
            "act_name",
            this.owner.address,
            "type_of_NGO",
            "name",
            ["key_issues", ["place", "city", "state", 302031]],
            [true, 123],
            "achievements",
            [
                ["place", "city", "state", 302031],
                [91, 1234567890],
                [91, 1234567890],
                "mail.com",
                123,
            ],
            "mywebsite.com",
        ];
        await this.NGOContract.createNGO(...args);
        const ngo = await this.NGOContract.NGOs(this.owner.address);

        for (let i = 0; i < args.length; i++) {
            if (typeof args[i] === "object") {
                for (let j = 0; j < args[i].length; j++) {
                    if (typeof args[i][j] === "object") {
                        for (let k = 0; k < args[i][j].length; k++) {
                            if (typeof args[i][j][k] !== "number")
                                expect(args[i][j][k]).to.equal(ngo[i][j][k]);
                        }
                    } else if (typeof args[i][j] !== "number")
                        expect(args[i][j]).to.equal(ngo[i][j]);
                }
            } else expect(args[i]).to.equal(ngo[i]);
        }
    });
    it("Another User Edit Access Revert", async () => {
        [owner, other] = await ethers.getSigners();
        await expect(this.NGOContract.connect(other).editNGO(
            "reg_cert",
            "act_name",
            "type_of_NGO",
            "name_of_NGO",
            ["key_issues", ["place", "city", "state", 302031]],
            [false, 0],
            "achievements",
            [
                ["place", "city", "state", 302031],
                [91, 1234567890],
                [91, 1234567890],
                "mail.com",
                123,
            ],
            "website_url"
        )).to.be.revertedWith("Account doesn't exist");
    });
});
