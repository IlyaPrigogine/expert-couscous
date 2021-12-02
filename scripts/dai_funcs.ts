import {deployments, ethers, getNamedAccounts} from 'hardhat';
import {Greeter} from "../typechain";

const {execute, read} = deployments;

async function main() {

    const {owner} = await getNamedAccounts();

    const Greeter = await ethers.getContract<Greeter>('Greeter');
    console.log(`Greeter.greet(): ${await Greeter.greet()}`);
    
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
