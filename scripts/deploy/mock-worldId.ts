import hre from 'hardhat';

// Deployment Helpers:
import {deploy} from '../utils/helpers';
// ABI
import {WorldID} from '../../typechain-types';

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // Sepolia
  const mockWorldId = await deploy<WorldID>(deployer, 'WorldID', [], true);

  console.log('Mock WorldID Contract Deployed!');

  /*
  SEPOLIA ADDRESS: 0xe6E854b5F1a474863791E537542A0546766f61c7
  https://sepolia.etherscan.io/address/0xe6E854b5F1a474863791E537542A0546766f61c7#code
  */
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
