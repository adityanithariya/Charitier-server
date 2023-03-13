require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.17",
    paths: {
        artifacts:
            process.env.ENVIRONMENT === "develop"
                ? "./artifacts"
                : "../client/artifacts/",
    },
    defaultNetwork: "localhost",
    networks: {
        goerli: {
            url: "https://goerli.infura.io/v3/" + process.env.INFURA_API_KEY,
            accounts: [process.env.PRIVATE_KEY],
            chainId: 5,
        },
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY,
    },
};
