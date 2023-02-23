const { expect } = require("chai");

describe("FamilyContract", () => {
    before(async () => {
        const AdminContract = await ethers.getContractFactory("AdminContract");
        this.AdminContract = await AdminContract.deploy();

        await this.AdminContract.deployed();

        const FamilyContract = await ethers.getContractFactory(
            "FamilyContract"
        );
        this.FamilyContract = await FamilyContract.deploy(
            this.AdminContract.address
        );

        await this.FamilyContract.deployed();
        const [account] = await ethers.getSigners();
        this.account = account;
    });
    it("Successfull Deployment", async () => {
        expect(await this.FamilyContract.addrs(1)).to.equal(
            this.AdminContract.address,
            "FamilyContract doesn't have correct address of AdminContract"
        );
    });
    it("Change Admin Contract Address Revert", async () => {
        [_, account2] = await ethers.getSigners();
        await expect(
            this.FamilyContract.connect(account2).setAdminCtr(
                this.account.address
            )
        ).to.be.reverted;
    });
    it("Create Family", async () => {
        const args = [
            [
                this.account.address,
                "uid",
                "reg_no",
                123,
                "pan_card",
                ["place", "city", "state", 302031],
                false,
                true,
            ],
            [
                ["place", "city", "state", 302031],
                [91, 1234567890],
                [91, 1234567890],
                "mail@gmail.com",
                123,
            ],
        ];
        await this.FamilyContract.createFamily(...args);
        let family = await this.FamilyContract.Families(this.account.address);
        expect(family["reg_details"]["id"]).to.equal(this.account.address);
        expect(family["reg_details"]["uid"]).to.equal("uid");
        expect(family["reg_details"]["reg_no"]).to.equal("reg_no");
        expect(family["reg_details"]["addr"]["place"]).to.equal("place");
        expect(family["reg_details"]["addr"]["city"]).to.equal("city");
        expect(family["reg_details"]["addr"]["state"]).to.equal("state");
        expect(family["reg_details"]["addr"]["pincode"]).to.equal(302031);
        expect(family["reg_details"]["is_verified"]).to.equal(false);
        expect(family["reg_details"]["is_active"]).to.equal(true);
        expect(family["contact_details"]["addr"]["place"]).to.equal("place");
        expect(family["contact_details"]["addr"]["city"]).to.equal("city");
        expect(family["contact_details"]["addr"]["state"]).to.equal("state");
        expect(family["contact_details"]["addr"]["pincode"]).to.equal(302031);
        expect(
            Number(family["contact_details"]["phone_number"][0]._hex)
        ).to.equal(91);
        expect(
            Number(family["contact_details"]["phone_number"][1]._hex)
        ).to.equal(1234567890);
        expect(
            Number(family["contact_details"]["alt_phone_number"][0]._hex)
        ).to.equal(91);
        expect(
            Number(family["contact_details"]["alt_phone_number"][1]._hex)
        ).to.equal(1234567890);
        expect(family["contact_details"]["email"]).to.equal("mail@gmail.com");
    });
    it("Get Family List", async () => {
        expect(await this.FamilyContract.getFamilyList(0)).to.equal(
            this.account.address
        );
    });
    it("isFamily Modifier Revert", async () => {
        [_, other_account] = await ethers.getSigners();
        await expect(
            this.FamilyContract.connect(other_account).editFamilyRegDetails(
                "new_uid",
                "new_reg_no",
                "new_pan_card",
                ["new_place", "new_city", "new_state", 302001]
            )
        ).to.be.revertedWith("Account doesn't exists");
    });
    it("Edit Reg Details", async () => {
        await this.FamilyContract.editFamilyRegDetails(
            "new_uid",
            "new_reg_no",
            "new_pan_card",
            ["new_place", "new_city", "new_state", 302001]
        );
        let family = await this.FamilyContract.Families(this.account.address);
        expect(family["reg_details"]["uid"]).to.equal("new_uid");
        expect(family["reg_details"]["reg_no"]).to.equal("new_reg_no");
        expect(family["reg_details"]["pan_card"]).to.equal("new_pan_card");
        expect(family["reg_details"]["addr"]["place"]).to.equal("new_place");
        expect(family["reg_details"]["addr"]["city"]).to.equal("new_city");
        expect(family["reg_details"]["addr"]["state"]).to.equal("new_state");
        expect(family["reg_details"]["addr"]["pincode"]).to.equal(302001);
    });
    it("Edit Contact Details", async () => {
        await this.FamilyContract.editFamilyContactDetails(
            ["new_place", "new_city", "new_state", 302001],
            [91, 6789012345],
            [91, 6789012345],
            "new_mail@gmail.com"
        );
        let family = await this.FamilyContract.Families(this.account.address);
        expect(family["contact_details"]["addr"]["place"]).to.equal(
            "new_place"
        );
        expect(family["contact_details"]["addr"]["city"]).to.equal("new_city");
        expect(family["contact_details"]["addr"]["state"]).to.equal(
            "new_state"
        );
        expect(family["contact_details"]["addr"]["pincode"]).to.equal(302001);
        expect(family["contact_details"]["phone_number"]["code"]).to.equal(91);
        expect(
            Number(
                family["contact_details"]["phone_number"]["phone_number"]._hex
            )
        ).to.equal(6789012345);
        expect(family["contact_details"]["alt_phone_number"]["code"]).to.equal(
            91
        );
        expect(
            Number(
                family["contact_details"]["alt_phone_number"]["phone_number"]
                    ._hex
            )
        ).to.equal(6789012345);
        expect(family["contact_details"]["email"]).to.equal(
            "new_mail@gmail.com"
        );
    });
    it("Add Member", async () => {
        await this.FamilyContract.addFamilyMember([
            "name",
            "image",
            "role",
            "pan_card",
            "aadhar_card",
            true,
        ]);
        let family = await this.FamilyContract.readFamilyMember(
            this.account.address,
            0
        );
        expect(family["name"]).to.equal("name");
        expect(family["image"]).to.equal("image");
        expect(family["role"]).to.equal("role");
        expect(family["pan_card"]).to.equal("pan_card");
        expect(family["aadhar_card"]).to.equal("aadhar_card");
        expect(family["does_exist"]).to.equal(true);
    });
    it("Edit Member", async () => {
        await this.FamilyContract.editFamilyMember(0, 0, "new_name");
        expect(
            (
                await this.FamilyContract.readFamilyMember(
                    this.account.address,
                    0
                )
            )["name"]
        ).to.equal("new_name");
    });
    it("Get Total Members", async () => {
        expect(
            await this.FamilyContract.getFamilyTotalMembers(
                this.account.address
            )
        ).to.equal(1);
    });
    it("Remove Family Member", async () => {
        expect(
            (
                await this.FamilyContract.readFamilyMember(
                    this.account.address,
                    0
                )
            )["does_exist"]
        ).to.equal(true);
        await this.FamilyContract.removeFamilyMember(0);
        expect(
            (
                await this.FamilyContract.readFamilyMember(
                    this.account.address,
                    0
                )
            )["does_exist"]
        ).to.equal(false);
    });
    it("Restore Family Member", async () => {
        expect(
            (
                await this.FamilyContract.readFamilyMember(
                    this.account.address,
                    0
                )
            )["does_exist"]
        ).to.equal(false);
        await this.FamilyContract.restoreFamilyMember(0);
        expect(
            (
                await this.FamilyContract.readFamilyMember(
                    this.account.address,
                    0
                )
            )["does_exist"]
        ).to.equal(true);
    });
});
