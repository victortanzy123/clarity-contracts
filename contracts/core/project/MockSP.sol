// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";
import { Schema } from "@ethsign/sign-protocol-evm/src/models/Schema.sol";

contract SP {
    //  /**
//      * @notice Registers a Schema.
//      * @dev Emits `SchemaRegistered`.
//      * @param schema See `Schema`.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise.
//      * @return schemaId The assigned ID of the registered schema.
//      */
    function register(Schema memory schema, bytes calldata delegateSignature) external returns (uint64 schemaId) {
        return 1;
    }
}
//  /**
//      * @notice Registers a Schema.
//      * @dev Emits `SchemaRegistered`.
//      * @param schema See `Schema`.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise.
//      * @return schemaId The assigned ID of the registered schema.
//      */
//     function register(Schema memory schema, bytes calldata delegateSignature) external returns (uint64 schemaId);

//     /**
//      * @notice Makes an attestation.
//      * @dev Emits `AttestationMade`.
//      * @param attestation See `Attestation`.
//      * @param indexingKey Used by the frontend to aid indexing.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise.
//      * @param extraData This is forwarded to the resolver directly.
//      * @return attestationId The assigned ID of the attestation.
//      */
//     function attest(
//         Attestation calldata attestation,
//         string calldata indexingKey,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         returns (uint64 attestationId);

//     /**
//      * @notice Makes an attestation where the schema hook expects ETH payment.
//      * @dev Emits `AttestationMade`.
//      * @param attestation See `Attestation`.
//      * @param resolverFeesETH Amount of funds to send to the hook.
//      * @param indexingKey Used by the frontend to aid indexing.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise.
//      * @param extraData This is forwarded to the resolver directly.
//      * @return attestationId The assigned ID of the attestation.
//      */
//     function attest(
//         Attestation calldata attestation,
//         uint256 resolverFeesETH,
//         string calldata indexingKey,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         payable
//         returns (uint64 attestationId);

//     /**
//      * @notice Makes an attestation where the schema hook expects ERC20 payment.
//      * @dev Emits `AttestationMade`.
//      * @param attestation See `Attestation`.
//      * @param resolverFeesERC20Token ERC20 token address used for payment.
//      * @param resolverFeesERC20Amount Amount of funds to send to the hook.
//      * @param indexingKey Used by the frontend to aid indexing.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise.
//      * @param extraData This is forwarded to the resolver directly.
//      * @return attestationId The assigned ID of the attestation.
//      */
//     function attest(
//         Attestation calldata attestation,
//         IERC20 resolverFeesERC20Token,
//         uint256 resolverFeesERC20Amount,
//         string calldata indexingKey,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         returns (uint64 attestationId);

//     /**
//      * @notice Timestamps an off-chain data ID.
//      * @dev Emits `OffchainAttestationMade`.
//      * @param offchainAttestationId The off-chain data ID.
//      * @param delegateAttester An optional delegated attester that authorized the caller to attest on their behalf if
//      * this is a delegated attestation. Use `address(0)` otherwise.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated attestation. Use `""` or `0x`
//      * otherwise. Use `""` or `0x` otherwise.
//      */
//     function attestOffchain(
//         string calldata offchainAttestationId,
//         address delegateAttester,
//         bytes calldata delegateSignature
//     )
//         external;

//     /**
//      * @notice Revokes an existing revocable attestation.
//      * @dev Emits `AttestationRevoked`. Must be called by the attester.
//      * @param attestationId An existing attestation ID.
//      * @param reason The revocation reason. This is only emitted as an event to save gas.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated revocation.
//      * @param extraData This is forwarded to the resolver directly.
//      */
//     function revoke(
//         uint64 attestationId,
//         string calldata reason,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external;

//     /**
//      * @notice Revokes an existing revocable attestation where the schema hook expects ERC20 payment.
//      * @dev Emits `AttestationRevoked`. Must be called by the attester.
//      * @param attestationId An existing attestation ID.
//      * @param reason The revocation reason. This is only emitted as an event to save gas.
//      * @param resolverFeesETH Amount of funds to send to the hook.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated revocation.
//      * @param extraData This is forwarded to the resolver directly.
//      */
//     function revoke(
//         uint64 attestationId,
//         string calldata reason,
//         uint256 resolverFeesETH,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         payable;

//     /**
//      * @notice Revokes an existing revocable attestation where the schema hook expects ERC20 payment.
//      * @dev Emits `AttestationRevoked`. Must be called by the attester.
//      * @param attestationId An existing attestation ID.
//      * @param reason The revocation reason. This is only emitted as an event to save gas.
//      * @param resolverFeesERC20Token ERC20 token address used for payment.
//      * @param resolverFeesERC20Amount Amount of funds to send to the hook.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated revocation.
//      * @param extraData This is forwarded to the resolver directly.
//      */
//     function revoke(
//         uint64 attestationId,
//         string calldata reason,
//         IERC20 resolverFeesERC20Token,
//         uint256 resolverFeesERC20Amount,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external;

//     /**
//      * @notice Revokes an existing offchain attestation.
//      * @dev Emits `OffchainAttestationRevoked`. Must be called by the attester.
//      * @param offchainAttestationId An existing attestation ID.
//      * @param reason The revocation reason. This is only emitted as an event to save gas.
//      * @param delegateSignature An optional ECDSA delegateSignature if this is a delegated revocation.
//      */
//     function revokeOffchain(
//         string calldata offchainAttestationId,
//         string calldata reason,
//         bytes calldata delegateSignature
//     )
//         external;

//     /**
//      * @notice Batch attests.
//      */
//     function attestBatch(
//         Attestation[] calldata attestations,
//         string[] calldata indexingKeys,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         returns (uint64[] calldata attestationIds);

//     /**
//      * @notice Batch attests where the schema hook expects ETH payment.
//      */
//     function attestBatch(
//         Attestation[] calldata attestations,
//         uint256[] calldata resolverFeesETH,
//         string[] calldata indexingKeys,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         payable
//         returns (uint64[] calldata attestationIds);

//     /**
//      * @notice Batch attests where the schema hook expects ERC20 payment.
//      */
//     function attestBatch(
//         Attestation[] calldata attestations,
//         IERC20[] calldata resolverFeesERC20Tokens,
//         uint256[] calldata resolverFeesERC20Amount,
//         string[] calldata indexingKeys,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         returns (uint64[] calldata attestationIds);

//     /**
//      * @notice Batch timestamps off-chain data IDs.
//      */
//     function attestOffchainBatch(
//         string[] calldata offchainAttestationIds,
//         address delegateAttester,
//         bytes calldata delegateSignature
//     )
//         external;

//     /**
//      * @notice Batch revokes revocable on-chain attestations.
//      */
//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external;

//     /**
//      * @notice Batch revokes revocable on-chain attestations where the schema hook expects ETH payment.
//      */
//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         uint256[] calldata resolverFeesETH,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external
//         payable;

//     /**
//      * @notice Batch revokes revocable on-chain attestations where the schema hook expects ERC20 payment.
//      */
//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         IERC20[] calldata resolverFeesERC20Tokens,
//         uint256[] calldata resolverFeesERC20Amount,
//         bytes calldata delegateSignature,
//         bytes calldata extraData
//     )
//         external;

//     /**
//      * @notice Batch revokes off-chain attestations.
//      */
//     function revokeOffchainBatch(
//         string[] calldata offchainAttestationIds,
//         string[] calldata reasons,
//         bytes calldata delegateSignature
//     )
//         external;

//     /**
//      * @notice Returns the specified `Schema`.
//      */
//     function getSchema(uint64 schemaId) external view returns (Schema calldata);

//     /**
//      * @notice Returns the specified `Attestation`.
//      */
//     function getAttestation(uint64 attestationId) external view returns (Attestation calldata);

//     /**
//      * @notice Returns the specified `OffchainAttestation`.
//      */
//     function getOffchainAttestation(string calldata offchainAttestationId)
//         external
//         view
//         returns (OffchainAttestation calldata);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated registration.
//      */
//     function getDelegatedRegisterHash(Schema memory schema) external pure returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated attestation.
//      */
//     function getDelegatedAttestHash(Attestation calldata attestation) external pure returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated batch attestation.
//      */
//     function getDelegatedAttestBatchHash(Attestation[] calldata attestations) external pure returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated offchain attestation.
//      */
//     function getDelegatedOffchainAttestHash(string calldata offchainAttestationId) external pure returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated batch offchain attestation.
//      */
//     function getDelegatedOffchainAttestBatchHash(string[] calldata offchainAttestationIds)
//         external
//         pure
//         returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated revocation.
//      */
//     function getDelegatedRevokeHash(uint64 attestationId, string memory reason) external pure returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated batch revocation.
//      */
//     function getDelegatedRevokeBatchHash(
//         uint64[] memory attestationIds,
//         string[] memory reasons
//     )
//         external
//         pure
//         returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated offchain revocation.
//      */
//     function getDelegatedOffchainRevokeHash(
//         string memory offchainAttestationId,
//         string memory reason
//     )
//         external
//         pure
//         returns (bytes32);

//     /**
//      * @notice Returns the hash that will be used to authorize a delegated batch offchain revocation.
//      */
//     function getDelegatedOffchainRevokeBatchHash(
//         string[] memory offchainAttestationIds,
//         string[] memory reasons
//     )
//         external
//         pure
//         returns (bytes32) {
//             return bytes
//         };

//     /**
//      * @notice Returns the current schema counter. This is incremented for each `Schema` registered.
//      */
//     function schemaCounter() external view returns (uint64);

//     /**
//      * @notice Returns the current on-chain attestation counter. This is incremented for each `Attestation` made.
//      */
//     function attestationCounter() external view returns (uint64) {
//         return 0;
//     };
// }