import {Contract} from 'ethers';
import hre, {ethers} from 'hardhat';

// Helpers
import {deploy, getContractAt, getTimestampInSeconds} from '../utils/helpers';

const PROJECT_ATTESTOR_SEPOLIA = '0x7fc5fD43a2A844B8E200Be4e1FbC08C2C047A55c';

async function main() {
  const [deployer, altAccount] = await hre.ethers.getSigners(); // Get signer object
  // const tokenPermit = await deploy<TokenPermit>(deployer, 'TokenPermit', [], false);
  const attestor = await getContractAt('ProjectAttestor', PROJECT_ATTESTOR_SEPOLIA);
  const owner = await attestor.owner();
  const pendingOwner = await attestor.pendingOwner();
  console.log('See Owner:', owner, pendingOwner);

  const tx = await attestor.createOrderForTransaction(deployer.address, 1, '0x');
  const receipt = await tx.wait();
  console.log('Successfully created mock order:', receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
