import hre, {ethers} from 'hardhat';
import {deploy, getContractAt} from '../utils/helpers';

import {encodeClarityReview, encodeWorldcoinProof} from '../utils/sign';
import {
  SIGN_PROTOCOL_SEPOLIA,
  WORLD_ID_SEPOLIA,
  WORLD_ACTION_ID,
  WORLD_APP_ID,
  USDC_SEPOLIA,
  CLARITY_SEPOLIA,
} from '../utils/clarity';
import {MOCK_NULLIFIER_HASH, MOCK_PROOF, MOCK_ROOT, MOCK_SIGNAL} from '../utils/const';

// ABI
import {Clarity, ClaritySPHook, SP} from '../../typechain-types';

async function main() {
  const [deployer, altAccount] = await hre.ethers.getSigners();

  //   const WORLD_ID_ADDRESS = WORLD_ID_SEPOLIA; // To run deploy mock WorldID contract and store it write here
  //   const MOCK_1INCH_AGGREGATOR_V6_ADDRESS = '0xba7177535B4d9A74e7928376e8ecd9db8F689d12';

  //   // Step 1: Deploy ClaritySPHook to prepare for schema creation on Sign Protocol's SP Instance
  //   const CLARITY_SP_HOOK_CONSTRUCTOR = [WORLD_ID_ADDRESS, WORLD_APP_ID, WORLD_ACTION_ID];
  //   const claritySpHook = await deploy<ClaritySPHook>(deployer, 'ClaritySPHook', CLARITY_SP_HOOK_CONSTRUCTOR, true);

  //   console.log('Clarity Hook Deployed!');

  //   //  Step 2: Create Clarity Review schema on Sign Protocol's SP Instance & invoke ClaritySPHook address
  //   const schema = {
  //     registrant: deployer.address,
  //     revocable: false,
  //     dataLocation: 0,
  //     maxValidFor: 0,
  //     hook: claritySpHook.address,
  //     timestamp: 0,
  //     data: JSON.stringify({
  //       name: 'Clarity Sepolia',
  //       description:
  //         'An immutable schema for orders processed through the Clarity open-source system, ensuring that all transactions are verified and executed only by genuine human users via WorldID, preventing bot activity and enhancing trust and security.',
  //       data: [
  //         {name: 'ratings', type: 'uint256'},
  //         {name: 'comment', type: 'string'},
  //       ],
  //     }),
  //   };

  //   // Delegate signature (empty in this case)
  //   const delegateSignature = '0x';
  //   // Get Sign Protocol's Instance
  //   const spInstance = await getContractAt<SP>('SP', SIGN_PROTOCOL_SEPOLIA); // @ARB

  //   // Register schema on spInstance
  //   const tx = await spInstance.register(schema, delegateSignature);
  //   const receipt = await tx.wait();

  //   const schemaId = ethers.BigNumber.from(receipt.logs[0].data).toNumber();

  //   console.log('Successfully registered Schema Id:', schemaId);

  //   // Step 3: Deploy Clarity Main contract
  //   const CLARITY_CONSTRUCTOR = [
  //     schemaId,
  //     SIGN_PROTOCOL_SEPOLIA,
  //     claritySpHook.address,
  //     // '0x7BD69C4b62Fcc339Cf1E1f641074Be07E41b824E',
  //     USDC_SEPOLIA,
  //     MOCK_1INCH_AGGREGATOR_V6_ADDRESS,
  //   ];

  //   const clarity = await deploy<Clarity>(deployer, 'Clarity', CLARITY_CONSTRUCTOR, true);

  //   const TEST_MERCHANT = '0xe9ED15C9290d782268ba74A08999dba19ca367bE';
  //   const TEST_MERCHANT_2 = '0x5C15Cf4ab0A650AE95B7109a5e3315EDAd68D5c0';

  //   // Register merchants:
  //   const merchantRegisterTx1 = await clarity.registerMerchant(TEST_MERCHANT_2);
  //   const merchantRegisterReceipt1 = merchantRegisterTx1.wait();
  //   console.log(`Merchant 0 - ${TEST_MERCHANT} registered!`);

  //   const merchantRegisterTx2 = await clarity.registerMerchant(TEST_MERCHANT_2);
  //   const merchantRegisterReceipt2 = merchantRegisterTx2.wait();
  //   console.log(`Merchant 1 - ${TEST_MERCHANT_2} registered!`);

  const TEST_UUID_STRING = 'd7c2bcca-b768-41c9-947e-2ac8c8b801dE';
  const clarity = await getContractAt<Clarity>('Clarity', CLARITY_SEPOLIA);
  // Create Order
  const tx1 = await clarity.createOrderForTransaction(TEST_UUID_STRING, 0, 1000, '0x');
  const receipt1 = await tx1.wait();
  console.log('Successfully created Mock Order 1:', receipt1);

  // PAYMENT TO ORDER
  const USDC = USDC_SEPOLIA; // @ARB
  const usdc = await getContractAt('ERC20', USDC);

  console.log('Balance: ', await usdc.balanceOf(altAccount.address));
  const usdcApprovalTx = await usdc.connect(altAccount).approve(clarity.address, 100000000);
  const approvalReceipt = await usdcApprovalTx.wait();
  console.log('USDC Approval successful!');

  const paymentTx = await clarity.connect(altAccount).settlePaymentOnlyByBaseCurrency(TEST_UUID_STRING);
  const paymentReceipt = await paymentTx.wait();
  console.log('USDC Payment Successful!');

  // Attest Review to order
  const review = {
    ratings: 5,
    comment: 'Exceeded expectations! Truly impressive.',
  };

  const encodedReview = encodeClarityReview(review.ratings, review.comment);
  //   console.log('[ENCODED REVIEW]:', encodedReview);

  const encodedProof = encodeWorldcoinProof(MOCK_SIGNAL, MOCK_ROOT, MOCK_NULLIFIER_HASH, MOCK_PROOF);
  //   console.log('[ENCODED WORLDID PROOF]', encodedProof);
  // AltAccount was payee
  const attestTx = await clarity.connect(altAccount).attestReview(TEST_UUID_STRING, encodedReview, encodedProof);
  const attestReceipt = await attestTx.wait();
  console.log('Successfully attested to OrderId', TEST_UUID_STRING);
  /*
  ARBITRUM SEPOLIA

  HOOK: 0x2eDD11E4121325F8aEf1cea1bB18721Ab456C357
  https://sepolia.arbiscan.io/address/address/0x2eDD11E4121325F8aEf1cea1bB18721Ab456C357#code
  Schema Id: 0xf2
  Full Schema: onchain_evm_421614_0xf2

  CLARITY MAIN CONTRACT: 0xba7177535B4d9A74e7928376e8ecd9db8F689d12
  https://sepolia.arbiscan.io/address/address/0xba7177535B4d9A74e7928376e8ecd9db8F689d12#code
  

  Clarity Review Schema Test
  SchemaId: 0x24e
  FULL Schema ID: onchain_evm_11155111_0x24e
  https://testnet-scan.sign.global/schema/onchain_evm_11155111_0x24e

 Clarity MAIN Contract: 0x479eE4d9BF5109bF6d55211871BE775C2e95eE58
 https://sepolia.etherscan.io/address/0x479eE4d9BF5109bF6d55211871BE775C2e95eE58#code
  */

  /*
(FINAL SEPOLIA)
Clarity SP Hook: 0x3d19B632faD6Da763Ae6093CabBCA6bE75eB5013
https://sepolia.etherscan.io/address/0x3d19B632faD6Da763Ae6093CabBCA6bE75eB5013#code

  Clarity Review Schema Test
  SchemaId: 0x25D
  FULL Schema ID: onchain_evm_11155111_0x25D
  https://testnet-scan.sign.global/schema/onchain_evm_11155111_0x25D

   Clarity MAIN Contract: 0xD8ddF4B409c0CE730c1BE601cF7839Bec9446CdB
 https://sepolia.etherscan.io/address/0xD8ddF4B409c0CE730c1BE601cF7839Bec9446CdB#code
 */
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
