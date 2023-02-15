const { expect } = require("chai");

describe("NGOContract", function () {
    before(async () => {
        const AdminContract = await ethers.getContractFactory("AdminContract");
        this.AdminContract = await AdminContract.deploy();

        await this.AdminContract.deployed();

        const NGOContract = await ethers.getContractFactory("NGOContract");
        this.NGOContract = await NGOContract.deploy(this.AdminContract.address);

        await this.NGOContract.deployed();
    });
    it("Successfull Deployment", async () => {
        expect(await this.NGOContract.addrs(1)).equals(
            this.AdminContract.address,
            "NGOContract doesn't have correct address of AdminContract"
        );
    });
    it("Create NGO", async () => {
        const [ owner ] = await ethers.getSigners();
        console.log(owner.address);
        let args = [
            [{
                id: owner.address,
                uid: "uid",
                reg_no: "reg_no",
                reg_date: 123,
                pan_card: "pan_card",
                addr: [{
                    place: "place",
                    city: "city",
                    state: "state",
                    pin_code: 302031
                }],
                is_verified: false,
                is_active: true
            }],
            "reg_cert",
            "act_name",
            owner.address,
            "type_of_NGO",
            "name",
            [{
                key_issues: "key_issues",
                addr: [{
                    place: "place",
                    city: "city",
                    state: "state",
                    pin_code: 302031
                }]
            }],
            [{
                is_available: true,
                reg_no: 123
            }],
            "achievements",
            [{
                addr: [{
                    place: "place",
                    city: "city",
                    state: "state",
                    pin_code: 302031
                }],
                phone_number: [{
                    code: 91,
                    phone_number: 1234567890
                }],
                alt_phone_number: [{
                    code: 91,
                    phone_number: 1234567890
                }],
                email: "mail.com",
                last_modified: 123
            }],
            "mywebsite.com"
        ]
        // console.log(args);
        console.log(...args);
        await this.NGOContract.createNGO(...args);
        console.log(owner.address);
        console.log("created");
        console.log(await this.NGOContract.NGOs[owner]);
    });
});
