const { expect } = require("chai");

describe("AdminContract", () => {
    before(async () => {
        const AdminContract = await ethers.getContractFactory("AdminContract");
        this.AdminContract = await AdminContract.deploy();

        await this.AdminContract.deployed();
        const [account, account2] = await ethers.getSigners();
        this.account = account;
        this.account2 = account2;
    });
    it("Successfull Deployment", async () => {
        expect(await this.AdminContract.owner()).to.equal(this.account.address);
        expect(await this.AdminContract.contracts(0)).to.equal(
            ethers.constants.AddressZero
        );
    });
    it("Set Contract Address", async () => {
        await this.AdminContract.setContractAddress(0, this.account.address);
        expect(await this.AdminContract.contracts(0)).to.equal(
            this.account.address
        );
        await expect(
            this.AdminContract.setContractAddress(
                2,
                ethers.constants.AddressZero
            )
        ).to.be.reverted;
    });
    it("Create Admin", async () => {
        await expect(
            this.AdminContract.connect(this.account2).createAdmin([
                this.account2.address,
                "uid",
                "name",
                "role",
                false,
            ])
        ).to.be.revertedWith("Unauthorized Access");
        await this.AdminContract.createAdmin([
            this.account2.address,
            "uid",
            "name",
            "role",
            false,
        ]);
        expect(
            (await this.AdminContract.Admins(this.account2.address))["id"]
        ).to.equal(this.account2.address);
        expect(
            (await this.AdminContract.Admins(this.account.address))["id"]
        ).to.equal(ethers.constants.AddressZero);
    });
    it("Edit Admin", async () => {
        await expect(
            this.AdminContract.editAdmin([
                this.account2.address,
                "uid",
                "name",
                "role",
                false,
            ])
        ).to.be.revertedWith("Unauthorized Access");
        expect(
            await this.AdminContract.connect(this.account2).editAdmin([
                this.account.address,
                "new_uid",
                "new_name",
                "new_role",
                true,
            ])
        );
        let admin = await this.AdminContract.Admins(this.account2.address);
        expect(admin["id"]).to.equal(this.account2.address);
        expect(admin["uid"]).to.equal("new_uid");
        expect(admin["name"]).to.equal("new_name");
        expect(admin["role"]).to.equal("new_role");
        expect(admin["can_verify"]).to.equal(false);
    });
    it("Get Admin List", async () => {
        expect((await this.AdminContract.getAdminList())[0]).to.equal(
            this.account2.address
        );
    });
});
