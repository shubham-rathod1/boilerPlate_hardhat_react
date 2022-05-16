async function main() {
  const [deployer] = await ethers.getSigners();

  console.log('Deploying contracts with the account:', deployer.address);
  console.log('Account balance:', (await deployer.getBalance()).toString());

  // deploy contracts here:

  const myNft = await ethers.getContractFactory('MyNft');
  const mynft = await myNft.deploy();

  const BazaarContract = await ethers.getContractFactory("Bazaar");
  const bazaar = await BazaarContract.deploy(5);

  console.log('mynft deployed at', mynft.address);
  console.log('bazaar deployed at', bazaar.address);

  // mynft deployed at 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
  // bazaar deployed at 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
  // For each contract, pass the deployed contract and name to this function to save a copy of the contract ABI and address to the front end.
  saveFrontendFiles(mynft, 'MyNft');
  saveFrontendFiles(bazaar, 'Bazaar');

}

function saveFrontendFiles(contract, name) {
  const fs = require('fs');
  const contractsDir = __dirname + '/../../frontend/contractsData';

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + `/${name}-address.json`,
    JSON.stringify({ address: contract.address }, undefined, 2)
  );

  const contractArtifact = artifacts.readArtifactSync(name);

  fs.writeFileSync(
    contractsDir + `/${name}.json`,
    JSON.stringify(contractArtifact, null, 2)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
