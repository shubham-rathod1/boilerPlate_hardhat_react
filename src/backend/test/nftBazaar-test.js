const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('nft bazaar', () => {
  let mynft, bazaar, deployer, addr1, addr2;
  let commision = 5;
  beforeEach(async () => {
    const MyNft = await ethers.getContractFactory('MyNft');
    const Bazaar = await ethers.getContractFactory('Bazaar');
    mynft = await MyNft.deploy();
    bazaar = await Bazaar.deploy(commision);
    [deployer, addr1, addr2] = await ethers.getSigners();
  });

  it('name should be name', async () => {
    const name = await mynft.name();
    expect(name).to.equal('name');
  });

  it('should check commision address and commison percentage', async () => {
    const commision = await bazaar.s_commision();
    const address = await bazaar.s_commisionAccount();
    expect(commision).to.equal(5);
    expect(address).to.equal(deployer.address);
  });
});
