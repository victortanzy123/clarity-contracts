import hre from 'hardhat';

// Deployment Helpers:
import {deploy} from '../utils/helpers';
// ABI
import {ProjectAttestor} from '../../typechain-types';
import {ZERO_ADDRESS} from '../utils/const';

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('[DEPLOYER ADDRESS]:', deployer.address);
  // Sepolia
  const SIGN_PROTOCOL_SEPOLIA = '0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5';
  const USDC_SEPOLIA = '0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238';
  const PLACEHOLDER_ADDRESS = '0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7237';
  const attestor = await deploy<ProjectAttestor>(
    deployer,
    'ProjectAttestor',
    [SIGN_PROTOCOL_SEPOLIA, ZERO_ADDRESS, USDC_SEPOLIA, SIGN_PROTOCOL_SEPOLIA],
    true,
  );

  console.log('Project Attestor Deployed!');

  const owner = await attestor.owner();
  console.log('Owner: ', owner);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
