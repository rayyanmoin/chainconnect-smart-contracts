
/** @format */

const { ethers } = require("hardhat");

async function main() {
	const provider = ethers.provider;

	const [alice] = await ethers.getSigners();

	// Get alice wallet's ethers balance
	let aliceBalance = await provider.getBalance(alice.address);
	console.log("Owner Balance: ", ethers.utils.formatEther(aliceBalance));

	const ChainConnectToken = await ethers.getContractFactory("ChainConnectToken", alice);
	const chainConnectToken = await ChainConnectToken.deploy();
	await chainConnectToken.deployed();
	console.log("Contract Deployed To: ", chainConnectToken.address);
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
