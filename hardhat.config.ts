import {task} from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy';
import '@typechain/hardhat';
import {HardhatUserConfig} from 'hardhat/types';
import "solidity-coverage";
import "@nomiclabs/hardhat-etherscan";

const secret = require("./secret.json");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: "0.8.4",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100000
                    }
                }
            }
        ],
    },
    namedAccounts: {
        owner: 0,
        user1: 1
    },
    networks: {
        bsc_test: {
            url: secret.url,
            accounts: [secret.key],
            timeout: 120000
        },
        kovan: {
            url: secret.url_kovan,
            accounts: [secret.key],
            timeout: 120000
        },
        ropsten: {
            url: secret.url_ropsten,
            accounts: [secret.key],
            timeout: 120000,
            gas: 2100000,
            gasPrice: 8000000000
        },
    },
    etherscan: {
        apiKey: secret.apiKey
    },
}
export default config;

