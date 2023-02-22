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
        const [account] = await ethers.getSigners();
        this.account = account;
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
                this.account.address,
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
            this.account.address,
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
        const ngo = await this.NGOContract.NGOs(this.account.address);

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
    it("isNGO Modifier Revert", async () => {
        [account, other_account] = await ethers.getSigners();
        await expect(
            this.NGOContract.connect(other_account).editNGO(
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
            )
        ).to.be.revertedWith("Account doesn't exist");
    });
    it("Edit Details", async () => {
        await this.NGOContract.editNGO(
            "reg_cert_edit",
            "act_name_edit",
            "type_of_NGO_edit",
            "name_of_NGO_edit",
            [
                "key_issues_edit",
                ["place_edit", "city_edit", "state_edit", 302031],
            ],
            [false, 0],
            "achievements_edit",
            [
                ["place_edit", "city_edit", "state_edit", 302031],
                [91, 1234567890],
                [91, 1234567890],
                "mailedit.com",
                123,
            ],
            "website_url_edit"
        );
        let edited = await this.NGOContract.NGOs(this.account.address);
        expect(edited["website_url"]).to.equal("website_url_edit");
    });
    it("Edit String Details", async () => {
        await this.NGOContract.editstrNGODetail(BigNumber.from("0"), "new_uid");
        let edited = await this.NGOContract.NGOs(this.account.address);
        expect(edited[0][1]).to.equal("new_uid");
    });
    it("Toggle Status", async () => {
        let ngo = await this.NGOContract.NGOs(this.account.address);
        await this.NGOContract.toggleNGOStatus();
        let ngo_new = await this.NGOContract.NGOs(this.account.address);
        expect(ngo[0]["is_active"]).to.equal(!ngo_new[0]["is_active"]);
    });
    it("Verify Revert", async () => {
        await expect(
            this.NGOContract.verifyNGO(this.account.address)
        ).to.be.revertedWith("Unauthorized Access");
    });
    it("Edit Addresses", async () => {
        for (let index = 0; index < 2; index++) {
            if (index == 0) detail = "sector";
            else detail = "contact_details";
            await this.NGOContract.editNGOAddress(index, [
                "new_" + detail + "_place",
                "new_" + detail + "_city",
                "new_" + detail + "_state",
                302001,
            ]);
            ngo_new = await this.NGOContract.NGOs(this.account.address);
            expect(ngo_new[detail]["addr"]["place"]).to.equal(
                "new_" + detail + "_place"
            );
            expect(ngo_new[detail]["addr"]["city"]).to.equal(
                "new_" + detail + "_city"
            );
            expect(ngo_new[detail]["addr"]["state"]).to.equal(
                "new_" + detail + "_state"
            );
            expect(ngo_new[detail]["addr"]["pincode"]).to.equal(302001);
        }
    });
    it("Edit PhoneNumbers", async () => {
        for (let index = 0; index < 2; index++) {
            await this.NGOContract.editNGOPhoneNumber(index, [91, 5678901234]);
            ngo_new = await this.NGOContract.NGOs(this.account.address);
            expect(
                ngo_new["contact_details"][
                    index ? "alt_phone_number" : "phone_number"
                ]["phone_number"]
            ).to.equal(5678901234);
        }
    });
    it("Edit FCRA Details", async () => {
        await this.NGOContract.editNGOFCRA(true, 123456);
        ngo_new = await this.NGOContract.NGOs(this.account.address);
        expect(ngo_new["FCRA_details"]["is_available"]).to.equal(true);
        expect(Number(ngo_new["FCRA_details"]["reg_no"]._hex)).to.equal(123456);
    });
    it("Add Member", async () => {
        await this.NGOContract.addNGOMember(
            "name",
            "role",
            "pan_card",
            "aadhaar_card"
        );
        let member = await this.NGOContract.readNGOMember(0);
        expect(member["name"]).to.equal("name");
        expect(member["role"]).to.equal("role");
        expect(member["pan_card"]).to.equal("pan_card");
        expect(member["aadhar_card"]).to.equal("aadhaar_card");
        expect(member["does_exist"]).to.equal(true);
    });
    it("Edit Member", async () => {
        for (let index = 0; index < 4; index++) {
            await this.NGOContract.editNGOMember(0, index, "new_val");
            expect((await this.NGOContract.readNGOMember(0))[index]).to.equal(
                "new_val"
            );
        }
    });
    it("Remove Member", async () => {
        await this.NGOContract.removeNGOMember(0);
        expect((await this.NGOContract.readNGOMember(0))[4]).to.equal(false);
    });
    it("Get Total Members", async () => {
        [account, other_account] = await ethers.getSigners();

        await expect(this.NGOContract.getNGOTotals(this.account.address, -1)).to
            .be.reverted;
        await expect(
            this.NGOContract.getNGOTotals(other_account.address, 0)
        ).to.be.revertedWith("NGO doesn't exists");
        expect(
            await this.NGOContract.getNGOTotals(this.account.address, 0)
        ).to.equal(1);
    });
    it("Add Source", async () => {
        await this.NGOContract.addNGOSource(
            "dept_name",
            "source_type",
            [2022, 2023],
            200000,
            "purpose"
        );
        let source = await this.NGOContract.readNGOSource(0);
        expect(source["dept_name"]).to.equal("dept_name");
        expect(source["source_type"]).to.equal("source_type");
        expect(Number(source["financial_year"][0]._hex)).to.equal(2022);
        expect(Number(source["financial_year"][1]._hex)).to.equal(2023);
        expect(Number(source["amount"]._hex)).to.equal(200000);
        expect(source["purpose"]).to.equal("purpose");
        expect(source["does_exist"]).to.equal(true);
    });
    it("Edit Source", async () => {
        await this.NGOContract.editNGOSource(0, 0, "new_dept_name");
        await this.NGOContract.editNGOSource(0, 1, "new_source_type");
        await this.NGOContract.editNGOSource(0, 2, "new_purpose");

        let source = await this.NGOContract.readNGOSource(0);
        expect(source["dept_name"]).to.equal("new_dept_name");
        expect(source["source_type"]).to.equal("new_source_type");
        expect(source["purpose"]).to.equal("new_purpose");
    });
    it("Edit Source Amount", async () => {
        expect(
            Number((await this.NGOContract.readNGOSource(0))["amount"]._hex)
        ).to.equal(200000);
        await this.NGOContract.editNGOSourceAmt(0, 500000);
        expect(
            Number((await this.NGOContract.readNGOSource(0))["amount"]._hex)
        ).to.equal(500000);
    });
    it("Edit Source Financial Year", async () => {
        let source = await this.NGOContract.readNGOSource(0);
        expect(source["financial_year"][0]).to.equal(2022);
        expect(source["financial_year"][1]).to.equal(2023);

        await this.NGOContract.editNGOSourceFY(0, [2021, 2022]);

        source = await this.NGOContract.readNGOSource(0);
        expect(source["financial_year"][0]).to.equal(2021);
        expect(source["financial_year"][1]).to.equal(2022);
    });
    it("Remove Source", async () => {
        expect(
            (await this.NGOContract.readNGOSource(0))["does_exist"]
        ).to.equal(true);
        await this.NGOContract.removeNGOSource(0);
        expect(
            (await this.NGOContract.readNGOSource(0))["does_exist"]
        ).to.equal(false);
    });
    it("Restore Source", async () => {
        expect(
            (await this.NGOContract.readNGOSource(0))["does_exist"]
        ).to.equal(false);
        await this.NGOContract.restoreNGOAttrs(1, 0);
        await expect(this.NGOContract.restoreNGOAttrs(1, 1)).to.be.revertedWith(
            "Source not found!"
        );
        expect(
            (await this.NGOContract.readNGOSource(0))["does_exist"]
        ).to.equal(true);
    });
    it("Get Total Sources", async () => {
        [account, other_account] = await ethers.getSigners();

        await expect(this.NGOContract.getNGOTotals(this.account.address, -1)).to
            .be.reverted;
        await expect(
            this.NGOContract.getNGOTotals(other_account.address, 0)
        ).to.be.revertedWith("NGO doesn't exists");

        expect(
            await this.NGOContract.getNGOTotals(this.account.address, 1)
        ).to.equal(1);
    });
});
