import hre from 'hardhat';

// Deployment Helpers:
import {deploy} from '../utils/helpers';
// ABI
import {Clarity, ClaritySPHook} from '../../typechain-types';
import {ZERO_ADDRESS} from '../utils/const';
import {WORLD_ID_SEPOLIA, WORLD_ACTION_ID, WORLD_APP_ID} from '../utils/clarity';

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // Sepolia
  const WORLD_ID_ADDRESS = WORLD_ID_SEPOLIA; // To run deploy mock WorldID contract and store it write here

  // Step 1: Deploy ClaritySPHook to prepare for schema creation on Sign Protocol's SP Instance
  const CLARITY_SP_HOOK_CONSTRUCTOR = [WORLD_ID_ADDRESS, WORLD_APP_ID, WORLD_ACTION_ID];
  const claritySpHook = await deploy<ClaritySPHook>(deployer, 'ClaritySPHook', CLARITY_SP_HOOK_CONSTRUCTOR, true);

  console.log('Clarity Hook Deployed!');

  /*
    Latest: 0x586B5D5C9E715963F848EE7b20297D14f6746f53

    Schema: onchain_evm_11155111_0x24e

  */
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
