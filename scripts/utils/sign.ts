// Import ethers v6
import {ethers} from 'ethers';

// Define the ABI types and values to encode
const types = ['string', 'uint256', 'bool'];
const values = ['Hello World', 123, true];

// Encode the data
export function encodeData(types: string[], values: any[]): string {
  const encodedData = ethers.utils.defaultAbiCoder.encode(types, values);
  console.log('ABI Encoded Data:', encodedData);
  return encodedData;
}

// Schema for Payment
/*
[
  {
    "name": "orderId",
    "type": "uint256"
  },
  {
    "name": "referenceId",
    "type": "string" // Misc. optional field for merchants to include any relevant reference identifier
  }
]
*/

// Schema for Review
/*
[
  {
    "name": "overallSatisfaction",
    "type": "uint256"
  },
  {
    "name": "serviceQuality",
    "type": "uint256"
  },
  {
    "name": "wouldRecommend",
    "type": "uint256"
  },
  {
    "name": "remarks",
    "type": "string"
  }
]
*/
