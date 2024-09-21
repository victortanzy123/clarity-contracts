import {Contract} from 'ethers';
import hre, {ethers} from 'hardhat';

// Helpers
import {deploy, getContractAt, getTimestampInSeconds} from '../utils/helpers';
import {CLARITY_SEPOLIA} from '../utils/clarity';
import {encodeClarityReview, encodeWorldcoinProof} from '../utils/sign';

// Constants
import {MOCK_NULLIFIER_HASH, MOCK_PROOF, MOCK_ROOT, MOCK_SIGNAL} from '../utils/const';

async function main() {
  const [deployer, altAccount] = await hre.ethers.getSigners(); // Get signer object
  // const tokenPermit = await deploy<TokenPermit>(deployer, 'TokenPermit', [], false);
  const clarity = await getContractAt('Clarity', CLARITY_SEPOLIA);

  //   const TEST_UUID_STRING = 'd7c2bcca-b768-41c9-947e-2ac8c8b801dE';

  const TEST_UUID_STRING = 'd7c2bcca-b768-41c9-947e-2ac8c8b801dE';
  const TEST_UUID_STRING_2 = 'd7edee1b-1e05-4aca-86d9-ec10ac23289e';

  const review = {
    ratings: 5,
    comment: 'hello world',
  };
  const encodedReview = encodeClarityReview(review.ratings, review.comment);
  console.log('[ENCODED REVIEW]:', encodedReview);

  const encodedProof = encodeWorldcoinProof(MOCK_SIGNAL, MOCK_ROOT, MOCK_NULLIFIER_HASH, MOCK_PROOF);
  console.log('[ENCODED WORLDID PROOF]', encodedProof);
  // AltAccount was payee
  const tx = await clarity.connect(altAccount).attestReview(TEST_UUID_STRING, encodedReview, encodedProof);
  const receipt = await tx.wait();
  console.log('Successfully attested to OrderId', TEST_UUID_STRING);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


/*
SEPOLIA

CLARITY MAIN CONTRACT: 0x1aa205ea73e9df203ad794f295b488ef97bfd434
https://sepolia.etherscan.io/address/0x1aa205ea73e9df203ad794f295b488ef97bfd434#readContract


SCHEMA: onchain_evm_11155111_0x24e
https://testnet-scan.sign.global/schema/onchain_evm_11155111_0x24e

CLARITY SP HOOK: 0x586b5d5c9e715963f848ee7b20297d14f6746f53
https://sepolia.etherscan.io/address/0x586b5d5c9e715963f848ee7b20297d14f6746f53#readContract

SUBGRAPH: https://api.studio.thegraph.com/query/46716/clarity-test/version/latest
*/