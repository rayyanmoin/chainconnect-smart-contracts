
/** @format */

const hre = require("hardhat");

async function main() {
	const provider = ethers.provider;

	const [alice, bob] = await ethers.getSigners();

	// Get bob wallet's ethers balance
	let bobBalance = await provider.getBalance(bob.address);
	console.log("Bob Balance: ", ethers.utils.formatEther(bobBalance));

	const ChainConnect = await hre.ethers.getContractFactory("ChainConnect", bob);
	const chainConnect = await ChainConnect.deploy("Chain Connect", "CC", bob.address, "0x5FbDB2315678afecb367f032d93F642f64180aa3");
	await chainConnect.deployed();
	console.log("Contract Deployed To: ", chainConnect.address);
}

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();
