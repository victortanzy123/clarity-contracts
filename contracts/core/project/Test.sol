
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ClarityController } from "./ClarityController.sol";
import { OneInchSwapHelper } from "./OneInchSwapHelper.sol";
import { BoringOwnable } from "../helpers/BoringOwnable.sol";

// Interfaces
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";

// Models
import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";
import { Order } from "./models/Order.sol";
import { Schema } from "@ethsign/sign-protocol-evm/src/models/Schema.sol";

// Libraries
import { TimeLib } from "../libraries/TimeLib.sol";
import { BytesHelperLib } from "../libraries/BytesHelperLib.sol";
import { StringHelperLib } from "../libraries/StringHelperLib.sol";

/// @title Clarity Contract
/// @notice Contract for managing payments and reviews with attestation and verification logic.
contract Test {
    using BytesHelperLib for bytes;
    using StringHelperLib for string;

    ISP public spInstance; // Reference address book
    uint64 public reviewSchemaId;

      constructor(
        address _spInstance
    ) 
    { 
        spInstance = ISP(_spInstance);
        reviewSchemaId = 0x253;

    }



    function attestReview(
        bytes calldata data
    ) 
        external 
        returns (uint64 attestationId) 
    {
        attestationId = _attestReview(data);
    }


    function attestReviewTest1(
        bytes calldata data
    ) 
        external 
        returns (uint64 attestationId) 
    {
        attestationId = _attestReviewTest1(data);
    }

    function viewTest(bytes memory extraData) external pure returns (    address signal,
            uint256 root,
            uint256 nullifierHash,
            uint256[8] memory proof) {
                (
             signal,
            root,
            nullifierHash,
            proof
        ) = abi.decode(extraData, (address, uint256, uint256, uint256[8]));
    }


    function _attestReview(
        bytes calldata review
    ) internal returns (uint64 attestationId) {
        		// We now verify the provided proof is valid and the user is verified by World ID
        bytes[] memory recipients = new bytes[](2);
        recipients[0] = abi.encode(address(0));
        recipients[1] = abi.encode(address(0));   

        // Create a review attestation
        Attestation memory reviewAttestation = Attestation({
            schemaId: reviewSchemaId, // Schema for review
            linkedAttestationId: 0,
            attestTimestamp: uint64(block.timestamp),
            revokeTimestamp: 0,
            attester: msg.sender, // Transactee is the reviewer in this case
            validUntil: 0, // No expiration for the review attestation
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: review // Review metadata
        });

        bytes memory emptyData = new bytes(0);

        // Attest to sign protocol
        attestationId = spInstance.attest(reviewAttestation, "", emptyData, emptyData); // extraData for hook callback
    }



    function _attestReviewTest1(
        bytes calldata review
    ) internal returns (uint64 attestationId) {
        		// We now verify the provided proof is valid and the user is verified by World ID
        bytes[] memory recipients = new bytes[](2);
        recipients[0] = abi.encode(address(0));
        recipients[1] = abi.encode(address(0));   

        // Create a review attestation
        Attestation memory reviewAttestation = Attestation({
            schemaId: reviewSchemaId, // Schema for review
            linkedAttestationId: 0,
            attestTimestamp: uint64(block.timestamp),
            revokeTimestamp: 0,
            attester: address(this), // Transactee is the reviewer in this case
            validUntil: 0, // No expiration for the review attestation
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: review // Review metadata
        });

        bytes memory emptyData = new bytes(0);

        // Attest to sign protocol
        attestationId = spInstance.attest(reviewAttestation, "", emptyData, emptyData); // extraData for hook callback
    }
    
}