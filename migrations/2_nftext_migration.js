// Help Truffle find `NFTClone.sol` in the `/contracts` directory
const NFTClone = artifacts.require("NFTClone");

module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(NFTClone);
};