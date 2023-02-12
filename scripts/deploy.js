const { run, network } = require("hardhat");

async function main() {
    const Charitier = await ethers.getContractFactory("Charitier");
    const charitier = await Charitier.deploy();

    await charitier.deployed();

    if (network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY) {
        await charitier.deployTransaction.wait(6);
        verify(charitier.address, []);
        console.log("Verified!");
    }

    return charitier;
}

async function verify(contractAddress, args) {
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
}

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
