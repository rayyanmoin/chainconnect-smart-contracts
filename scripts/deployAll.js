
/** @format */

async function main() {
	const [owner, anotherOwner] = await ethers.getSigners(); // Get multiple signers

	// Deploy the first contract with the first signer
	const ChainConnectToken = await ethers.getContractFactory("ChainConnectToken", owner);
	const chainConnectToken = await ChainConnectToken.deploy();
	await chainConnectToken.deployed();
	console.log("ChainConnectToken Deployed To: ", chainConnectToken.address);

	// Deploy the second contract with a different signer
	const ChainConnect = await ethers.getContractFactory("ChainConnect", anotherOwner);
	const chainConnect = await ChainConnect.deploy("Chain Connect", "CC", anotherOwner.address, chainConnectToken.address);
	await chainConnect.deployed();
	console.log("ChainConnect Deployed To: ", chainConnect.address);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
