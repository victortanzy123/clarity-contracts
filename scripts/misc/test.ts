import {Contract} from 'ethers';
import hre, {ethers} from 'hardhat';

// Helpers
import {deploy, getContractAt, getTimestampInSeconds} from '../utils/helpers';
import {encodeData} from '../utils/sign';
import {CLARITY_ARB_SEPOLIA, CLARITY_SPHOOK_ARB_SEPOLIA, USDC_ARB_SEPOLIA} from '../utils/clarity';

const PROJECT_ATTESTOR_SEPOLIA = '0x7fc5fD43a2A844B8E200Be4e1FbC08C2C047A55c';

function stringToBytes32(source) {
  // Convert the string into bytes
  let bytes = ethers.utils.toUtf8Bytes(source);

  if (bytes.length === 0) {
    // If the string is empty, return a zero-filled bytes32
    return ethers.utils.hexZeroPad('0x', 32);
  }

  if (bytes.length > 32) {
    // If the bytes array is longer than 32 bytes, truncate it
    bytes = bytes.slice(0, 32);
  } else if (bytes.length < 32) {
    // If the bytes array is shorter than 32 bytes, pad it with zeros
    const padding = new Uint8Array(32 - bytes.length);
    bytes = ethers.utils.concat([bytes, padding]);
  }

  // Convert the padded/truncated bytes array to a hex string and return it
  return ethers.utils.hexlify(bytes);
}

async function main() {
  const [deployer, altAccount] = await hre.ethers.getSigners(); // Get signer object
  // const tokenPermit = await deploy<TokenPermit>(deployer, 'TokenPermit', [], false);
  const review = {
    ratings: 5,
    comment: 'hello world',
  };
  const encodedReview = encodeData(['uint256', 'string'], [review.ratings, review.comment]);
  const CLARITY_ADDRESS = CLARITY_ARB_SEPOLIA;
  const TEST_SP_HOOK = CLARITY_SPHOOK_ARB_SEPOLIA;

  const USDC_ADDRESS = USDC_ARB_SEPOLIA;
  const usdc = await getContractAt('ERC20', USDC_ADDRESS);
  const clarity = await getContractAt('Clarity', CLARITY_ADDRESS);

  const claritySpHook = await getContractAt('ClaritySPHook', TEST_SP_HOOK);

  const worldId = await claritySpHook.worldId();
  console.log('See world ID:', worldId);

  const externalNullifier = await claritySpHook.externalNullifier();
  console.log('External Nullifier:', externalNullifier);

  //   const approvalTx = await usdc.approve(CLARITY_ADDRESS, 10000000000);
  //   const approvalReceipt = await approvalTx.wait();
  //   console.log('[APPROVAL TX]:', approvalReceipt);

  const UUID_1 = '"d7c2bcca-b768-41c9-947e-2ac8c8b801db"';
  const orderIdBytes = stringToBytes32(UUID_1); // 0x36613639366131632d303930642d343864362d623264372d6431633465653533
  console.log('See ORDER ID BYTES:', orderIdBytes); // Correct: 0x64376332626363612D623736382D343163392D393437652D3261633863386238

  // Total byte length required: 340 bytes
  const emptyBytes = ethers.utils.hexZeroPad('0x', 340);
  console.log('EMPTY BYTES:', emptyBytes);
  //   const paymentTx = await clarity.settlePaymentByBaseCurrencyAndAttestReview(orderIdBytes);

  //   const owner = await attestor.owner();
  //   const pendingOwner = await attestor.pendingOwner();
  //   console.log('See Owner:', owner, pendingOwner);

  //   const tx = await attestor.createOrderForTransaction(deployer.address, 1, '0x');
  //   const receipt = await tx.wait();
  //   console.log('Successfully created mock order:', receipt);

  const order = await clarity.orderRegistry(orderIdBytes);
  console.log('[ORDER]', order);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
