// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";
// import { IWorldID } from "../../interfaces/IWorldID.sol";
// import { BytesHelperLib } from "../libraries/BytesHelperLib.sol";

// contract ProjectSPHook is ISPHook {

//     struct Review{
//         orde
//     }
//     using BytesHelperLib for bytes;

//     	/// @notice Thrown when attempting to reuse a nullifier
// 	error InvalidNullifier();

// 	/// @dev The World ID instance that will be used for verifying proofs
// 	IWorldID internal immutable worldId;

// 	/// @dev The contract's external nullifier hash
// 	uint256 internal immutable externalNullifier;

// 	/// @dev The World ID group ID (always 1)
// 	uint256 internal immutable groupId = 1;

//     	/// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
// 	mapping(uint256 => uint256) internal attestationIdToNullifierHashRegistry;

//     	/// @param _worldId The WorldID instance that will verify the proofs
// 	/// @param _appId The World ID app ID
// 	/// @param _actionId The World ID action ID
// 	constructor(
// 		IWorldID _worldId,
// 		string memory _appId,
// 		string memory _actionId
// 	) {
// 		worldId = _worldId;
// 		externalNullifier = abi
// 			.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
// 			.hashToField();
// 	}



//     function didReceiveAttestation(address attester, uint64 schemaId, uint64 attestationId, bytes calldata extraData) external payable {
//         // Decode the parameters from the bytes input
//         (
//             address signal,
//             uint256 root,
//             uint256 nullifierHash,
//             uint256[8] memory proof
//         ) = abi.decode(extraData, (address, uint256, uint256, uint256[8]));
        
//         attestationIdToNullifierHashRegistry[attestationId] = nullifierHash;
//         // // @TO_DO: verifyProof
//         worldId.verifyProof(
//             root,
//             groupId,
//             abi.encodePacked(signal).hashToField(),
//             nullifierHash,
//             externalNullifier,
//             proof
//         );
//         // _swapNativeToToken(extraData);
//     }

//     function didReceiveAttestation(address attester, uint64 schemaId, uint64 attestationId, IERC20 resolverFeeERC20Token, uint256 resolverFeeERC20Amount, bytes calldata extraData) external {
//         // For ERC20 payment

//         // @TO_DO: Swap
//         // _swapTokenToToken(resolverFeeERC20Token.address(), resolverFeeERC20Amount, extraData);
//     }

//     function didReceiveRevocation(address attester, uint64 schemaId, uint64 attestationId, bytes calldata extraData) external payable {
//         // ETH Payment
//     }

//     function didReceiveRevocation(address attester, uint64 schemaId, uint64 attestationId, IERC20 resolverFeeERC20Token, uint256 resolverFeeERC20Amount, bytes calldata extraData) external {
//         // ERC20 payment
//     }
// }