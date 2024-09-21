// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;


// import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
// import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";
// import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
// import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";
// // import { IWorldID } from "../../interfaces/IWorldID.sol";

// import { ProjectController } from "./ProjectController.sol";
// import { OneInchSwapHelper } from "./OneInchSwapHelper.sol";
// import { BoringOwnable } from "../helpers/BoringOwnable.sol";
// import { TimeLib } from "../libraries/TimeLib.sol";
// import { BytesHelperLib } from "../libraries/BytesHelperLib.sol";
// import { Order } from "./models/Order.sol";
// import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
// import { Schema } from "@ethsign/sign-protocol-evm/src/models/Schema.sol";

// error ConfirmationAddressMismatch();
// error UnsettledOrderPayment(uint256 orderId);
// error UnsettledOrder(uint256 orderId);
// error SettledOrderPayment(uint256 orderId);
// error OrderReviewed(uint256 orderId);

// /// @notice Thrown when attempting to reuse a nullifier
// error InvalidNullifier();



// contract ProjectAttestor is BoringOwnable, ProjectController,  OneInchSwapHelper {
//     using BytesHelperLib for bytes;
    
//     ISP public spInstance; // Reference address book
//     ISPHook public spHookInstance;
//     uint64 public reviewSchemaId;
//     	/// @dev The World ID instance that will be used for verifying proofs
// 	// IWorldID internal immutable worldId;

// 	/// @dev The contract's external nullifier hash
// 	// uint256 internal immutable externalNullifier;

// 	/// @dev The World ID group ID (always 1)
// 	uint256 internal immutable groupId = 1;

//      // Mappings for Review Attestations
//     mapping(uint256 => uint64 attestationId) public reviewAttestations;  // Maps an orderId to a review attestation

//     // Events
//     event Initialised(address owner, address spInstance, address spHook, address baseCurrency);
//     event OrderPaymentSettled(uint256 indexed orderId, address indexed merchant, address indexed payee, uint256 amount);
//     event ReviewAttested(uint256 indexed orderId, address indexed payee, uint64 attestationId);
    

//     constructor(address _spInstance, address _spHook, address _baseCurrency, address _aggregatorRouterV6
//     // , 
//     // address _worldId, string memory _appId,string memory _actionId
//     ) BoringOwnable(_msgSender()) ProjectController(_baseCurrency) OneInchSwapHelper(_aggregatorRouterV6) { 
//         spInstance = ISP(_spInstance);
//         spHookInstance = ISPHook(_spHook);
//         // worldId = IWorldID(_worldId);
//         // externalNullifier = abi
// 		// 	.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
// 		// 	.hashToField();

//         emit Initialised(_msgSender(), _spInstance, _spHook, _baseCurrency);
//     }


//     modifier settledOrder(uint256 orderId) {
//         if (!_isOrderSettled(orderId)) revert UnsettledOrderPayment(orderId);
//         _;
//     }

//     modifier unreviewedOrder(uint256 orderId) {
//         if(!_isOrderReviewed(orderId)) revert OrderReviewed(orderId);
//         _;
//     }


//   /*
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

//     */

//     function setSPInstance(address instance) external onlyOwner {
//         spInstance = ISP(instance);
//     }

//     function setSPHookInstance(address hookInstance) external onlyOwner {
//         spHookInstance = ISPHook(hookInstance);
//     }

//     function setReviewSchemaID(uint64 schemaId_) external onlyOwner {
//         reviewSchemaId = schemaId_;
//     }

//     // called by merchant
//     function createOrderForTransaction(address merchant, uint256 amount, bytes calldata referenceId) external onlyOwner {
//         _createOutstandingOrder(merchant, amount, referenceId);
//     }


//     function settlePaymentByAltCurrencyAndAttestReview(uint256 orderId, uint256 inputAmount, address currency, bytes calldata swapData, bytes calldata reviewData) external payable returns (uint64 reviewAttestationId) {
//         _settleOrderPayment(orderId, inputAmount, currency, swapData);
//         reviewAttestationId = _attestReview(orderId, reviewData);
//     }

//     function settlePaymentByBaseCurrencyAndAttestReview(uint256 orderId, bytes calldata reviewData) external returns (uint64 reviewAttestationId) {
//         _settleOrderPaymentByBaseCurrency(orderId);
//         reviewAttestationId = _attestReview(orderId, reviewData);
//     }

//         // Function to attest a review (called only if payment has been made prior to this)
//     function attestReview(
//         uint256 orderId,
//         bytes calldata data// Example of review data: a comment
//         // bytes calldata proof
//     ) external returns (uint64 attestationId) {
//        attestationId = _attestReview(orderId, data);
//     }

//     function _settleOrderPayment(uint256 orderId, uint256 inputAmount, address currency, bytes calldata data) internal {
//         if (currency == BASE_CURRENCY) {
//             _settleOrderPaymentByBaseCurrency(orderId);
//         } else {
//             Order memory order = orderRegistry[orderId];
//             uint256 swappedAmount;

//             if (currency == address(0)) {
//                 swappedAmount = _swapNativeToToken(data);
//             } else {
//                 swappedAmount = _swapTokenToToken(currency, inputAmount, data);
//             }
//             // Settle payment - implicit check for `swappedAmount` > `order.amount` inside function
//             _settleOrderPaymentByBaseCurrency(orderId);

//             // Check for excess amount & refund user
//             uint256 excessAmount = swappedAmount - order.amount;
//             _transferOut(currency, msg.sender, excessAmount);
//         }
//     }

//     function _settleOrderPaymentByBaseCurrency(uint256 orderId) internal {
//         Order memory order = orderRegistry[orderId];
//         if (order.settled) revert SettledOrderPayment(orderId);
        

//         _transferIn(BASE_CURRENCY, msg.sender, order.amount);

//         // Update order statuses
//         orderRegistry[orderId].payee = msg.sender;
//         orderRegistry[orderId].settled = true;
        
//         emit OrderPaymentSettled(orderId, order.merchant, msg.sender, order.amount); // Log the payment attestation
//     }


//         // Function to attest a review (called only if payment has been made prior to this)
//     function _attestReview(
//         uint256 orderId,
//         bytes calldata review
//         // bytes calldata encodedProofParams
//     ) internal settledOrder(orderId) unreviewedOrder(orderId) returns (uint64 attestationId) {
//         Order memory order = orderRegistry[orderId];
//         if (order.reviewAttestationId == 0) revert OrderReviewed(orderId);
//         		// We now verify the provided proof is valid and the user is verified by World ID

//         bytes[] memory recipients = new bytes[](2);
//         recipients[0] = abi.encode(order.merchant);
//         recipients[1] = abi.encode(order.payee);   

//         // Create a review attestation
//         Attestation memory reviewAttestation = Attestation({
//             schemaId: reviewSchemaId, // Schema for review
//             linkedAttestationId: 0,
//             attestTimestamp: uint64(block.timestamp),
//             revokeTimestamp: 0,
//             attester: msg.sender, // Transactee is the reviewer in this case
//             validUntil: 0, // No expiration for the review attestation
//             dataLocation: DataLocation.ONCHAIN,
//             revoked: false,
//             recipients: recipients,
//             data: review // Review metadata
//         });
//         // Attest to sign protocol
//         attestationId = spInstance.attest(reviewAttestation, "", "", "");
//         // Save the review attestation Id
//         orderRegistry[orderId].reviewAttestationId = attestationId;

//         emit ReviewAttested(orderId, msg.sender, attestationId); // Log the review attestation
//     }


//     /*
//             (
//             address signal,
//             uint256 root,
//             uint256 nullifierHash,
//             uint256[8] memory proof
//         ) = abi.decode(encodedParams, (address, uint256, uint256, uint256[8]));
//     */

//     function getReviewSchema() external view returns(Schema memory reviewSchema) {
//         reviewSchema = spInstance.getSchema(reviewSchemaId);

//     }
//     function getOrderReviewAttestation(uint256 orderId) external view returns(Attestation memory reviewAttestation) {
//         Order memory order = orderRegistry[orderId];
//         if (!order.settled) revert UnsettledOrder(orderId);

//         reviewAttestation = spInstance.getAttestation(order.reviewAttestationId);
//     }



//     function isOrderSettled(uint256 orderId) external view returns (bool settled) {
//         settled = _isOrderSettled(orderId);
//     }

//     function isOrderReviewed(uint256 orderId) external view returns (bool reviewed) {
//         reviewed = _isOrderReviewed(orderId);
//     }


//     function _isOrderSettled(uint256 orderId) internal view returns (bool) {
//         return orderRegistry[orderId].settled;
//     }

//     function _isOrderReviewed(uint256 orderId) internal view returns (bool) {
//         return orderRegistry[orderId].reviewAttestationId != 0;
//     }
    
// }