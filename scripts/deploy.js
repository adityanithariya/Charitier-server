const { run, network, ethers } = require("hardhat");
const {
    openSync,
    writeFileSync,
    closeSync,
    existsSync,
    mkdirSync,
} = require("fs");

async function main() {
    let obj = {};
    const AdminContract = await ethers.getContractFactory("AdminContract");
    const admin = await AdminContract.deploy();

    await admin.deployed();
    obj.AdminContract = admin.address;

    const NGOContract = await ethers.getContractFactory("NGOContract");
    const ngo = await NGOContract.deploy(admin.address);

    await ngo.deployed();
    obj.NGOContract = ngo.address;

    if (!existsSync("./scripts/cache")) mkdirSync("./scripts/cache");

    fd = openSync("./scripts/cache/address.json", "w");
    writeFileSync(fd, JSON.stringify(obj), "utf8");
    closeSync(fd);

    if (network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY) {
        verify(admin, []);
        verify(ngo, [admin.address]);
        console.log("Verified!");
    }

    obj.AdminContract = AdminContract;
    obj.NGOContract = NGOContract;

    return obj;
}

const verify = async (contract, args) => {
    await contract.deployTransaction.wait(6);
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Already Verified!");
        } else {
            console.log(error);
        }
    }
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

module.exports = {
    deploy: main,
};
