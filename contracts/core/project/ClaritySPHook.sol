// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ClarityERC20 } from "./ClarityERC20.sol";



// Interfaces
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";
import { IWorldID } from "../../interfaces/IWorldID.sol";
import { IEntropyConsumer } from "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import { IEntropy } from "@pythnetwork/entropy-sdk-solidity/IEntropy.sol";

// Libraries
import { BytesHelperLib } from "../libraries/BytesHelperLib.sol";


/// @notice Thrown when attempting to reuse a nullifier
error InvalidNullifier();
error ZeroAddress();


contract ClaritySPHook is ISPHook, ClarityERC20 {
    using BytesHelperLib for bytes;

    // IEntropy public immutable entropy;

	/// @dev The World ID instance that will be used for verifying proofs
	IWorldID public immutable worldId;

	/// @dev The contract's external nullifier hash
	uint256 public immutable externalNullifier;

	/// @dev The World ID group ID (always 1)
	uint256 public immutable GROUP_ID = 1;

    uint256 public counter;

    /// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
	mapping(uint256 => uint256) internal attestationIdToNullifierHashRegistry;
    
    /// @dev Maps a nullifier hash to a specific points amount. Used to track points associated with a nullifier hash.
    mapping( uint256 nullifierHash => uint256 amount) internal nullifierHashToPointsRegistry;

    /// @param _worldId The WorldID instance that will verify the proofs
	/// @param _appId The World ID app ID
	/// @param _actionId The World ID action ID
	constructor(
        // address _entropy,
		address _worldId,
		string memory _appId,
		string memory _actionId
	) {
        if (_worldId == address(0)) revert ZeroAddress();

		worldId = IWorldID(_worldId);
        // entropy = IEntropy(_entropy);
		externalNullifier = abi
			.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
			.hashToField();
	}



    function didReceiveAttestation(address attester, uint64 schemaId, uint64 attestationId, bytes calldata extraData) external payable {
        // Decode the parameters from the bytes input
        (
            address signal,
            uint256 root,
            uint256 nullifierHash,
            uint256[8] memory proof
        ) = abi.decode(extraData, (address, uint256, uint256, uint256[8]));
        
        attestationIdToNullifierHashRegistry[attestationId] = nullifierHash;

        // Verify humanhood via worldId contract
        worldId.verifyProof(
            root,
            GROUP_ID,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );
        
        // Once verified can do a gacha
    }

    function didReceiveAttestation(address attester, uint64 schemaId, uint64 attestationId, IERC20 resolverFeeERC20Token, uint256 resolverFeeERC20Amount, bytes calldata extraData) external {}

    function didReceiveRevocation(address attester, uint64 schemaId, uint64 attestationId, bytes calldata extraData) external payable {
        // Revocation is only possible via the same attestor address (validated at the SP Instance)
        // Remove attestationId to nulliflierHash
        attestationIdToNullifierHashRegistry[attestationId] = 0;
        
        // Remove points
        uint256 nullifierHash = attestationIdToNullifierHashRegistry[attestationId];
        _revokeReviewRewards(nullifierHash);
    }

    function didReceiveRevocation(address attester, uint64 schemaId, uint64 attestationId, IERC20 resolverFeeERC20Token, uint256 resolverFeeERC20Amount, bytes calldata extraData) external {
        // ERC20 payment
    }

    function mockVerifyProof(uint256 newCounter, address signal,uint256 root, uint256 nullifierHash, uint256[8] memory proof)external {
        worldId.verifyProof(
            root,
            GROUP_ID,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        counter = newCounter;
    }


        /// @notice Retrieves the nullifier hash associated with a given attestation ID.
    /// @param attestationId The ID of the attestation to query.
    /// @return nullifierHash The nullifier hash associated with the specified attestation ID.
    function getNullifierHashForAttestationId(uint256 attestationId) 
        external 
        view 
        returns (uint256 nullifierHash) 
    {
        nullifierHash = attestationIdToNullifierHashRegistry[attestationId];
    }

    /// @notice Retrieves the points amount associated with a given nullifier hash.
    /// @param nullifierHash The nullifier hash to query.
    /// @return pointsAmount The amount of points associated with the specified nullifier hash.
    function getPointsForNullifierHash(uint256 nullifierHash) 
        external 
        view 
        returns (uint256 pointsAmount) 
    {
        pointsAmount = nullifierHashToPointsRegistry[nullifierHash];
    }

    function _mintReviewReward(uint256 nullifierHash) internal {
        nullifierHashToPointsRegistry[nullifierHash] += 1;
    }

    function _revokeReviewRewards(uint256 nullifierHash) internal {
         nullifierHashToPointsRegistry[nullifierHash] -= 1;
    }
}