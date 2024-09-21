// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;


// import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
// import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";
// import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
// import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";
// import { IController } from "../../interfaces/IController.sol";

// import { ProjectController } from "./ProjectController.sol";
// import { BoringOwnable } from "../helpers/BoringOwnable.sol";
// import { TimeLib } from "../libraries/TimeLib.sol";
// import { Order } from "./models/Order.sol";
// import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
// import { Schema } from "@ethsign/sign-protocol-evm/src/models/Schema.sol";

// error ConfirmationAddressMismatch();
// error UnsettledOrderPayment(uint256 orderId);
// error UnsettledOrderReview(uint256 orderId);
// error UnsettledOrder(uint256 orderId);
// error SettledOrderPayment(uint256 orderId);
// error SettledOrderReview(uint256 orderId);

// contract ProjectAttestor is BoringOwnable, ProjectController {
//     ISP public spInstance; // Reference address book
//     ISPHook public spHookInstance;
//     uint64 public paymentSchemaId;
//     uint64 public reviewSchemaId;

//     // mapping(uint256 orderId => Order order) public orderRegistry;

//      // Mappings for Review Attestations
//     mapping(uint256 => uint64 attestationId) public paymentAttestations;  // Maps an orderId to a payment attestation
//     mapping(uint256 => uint64 attestationId) public reviewAttestations;  // Maps an orderId to a review attestation

//     // Events for logging the attestation creation
//     event PaymentAttested(uint256 indexed orderId, address indexed merchant, uint64 attestationId);
//     event ReviewAttested(uint256 indexed orderId, address indexed transactee, uint64 attestationId);


//     event TransactionComplete(address merchant, address transactee, uint64 attestationId);
//     constructor(address _spInstance, address _hook, address _baseCurrency) BoringOwnable(_msgSender()) ProjectController(_baseCurrency) { 
//         spInstance = ISP(_spInstance);
//         spHookInstance = ISPHook(_hook);
//     }

//     function setSPInstance(address instance) external onlyOwner {
//         spInstance = ISP(instance);
//     }

//     function setSPHookInstance(address hookInstance) external onlyOwner {
//         spHookInstance = ISPHook(hookInstance);
//     }

//     function setPaymentSchemaID(uint64 schemaId_) external onlyOwner {
//         paymentSchemaId = schemaId_;
//     }

//     function setReviewSchemaID(uint64 schemaId_) external onlyOwner {
//         reviewSchemaId = schemaId_;
//     }


//     // called by merchant
//     function setTransactionForAttestation(uint256 amount) external onlyOwner {
//         _createOutstandingOrder(amount);

//     }


//     function completePaymentAndReviewAttestationByETH() external {}



//     function completePaymentAndReviewAttestationByCurrency() external {

//         }



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

//     function attestPaymentByNativeETH(
//         uint256 orderId,
//         uint256 amount,
//         bytes calldata data // Extra data for proof of payment
//     ) external payable {
//         _attestPaymentByNativeETH(orderId, amount, data);
//     }

//     // Function to create a payment attestation
//     function attestPaymentByCurrency(
//         uint256 orderId,
//         uint256 amount,
//         bytes calldata data // Extra data for proof of payment
//     ) external {
//         _attestPaymentByCurrency(orderId, amount, data);
//     }

//    function _attestPaymentByNativeETH(        
//         uint256 orderId,
//         uint256 amount,
//         bytes calldata data // Extra data for proof of payment
//     ) internal returns (uint64 attestationId) {
//         Order memory order = orderRegistry[orderId];
//         if (order.paymentAttestationId != 0) revert SettledOrderPayment(orderId);


//         bytes[] memory recipients = new bytes[](2);
//         recipients[0] = abi.encode(order.merchant);
//         recipients[1] = abi.encode(order.transactee);   

//         // Create a payment attestation
//         Attestation memory paymentAttestation = Attestation({
//             schemaId: paymentSchemaId, // Schema for payment (could be different for reviews)
//             linkedAttestationId: 0, // Not linked to another attestation
//             attestTimestamp: uint64(block.timestamp),
//             revokeTimestamp: 0,
//             attester: msg.sender, // Transactee is the attester in this case
//             validUntil: 0, // No expiration for the payment attestation
//             dataLocation: DataLocation.ONCHAIN,
//             revoked: false,
//             recipients: recipients,
//             data: data // Payment metadata or proof
//         });
//         // Transfer ETH
//         payable(msg.sender).transfer(amount);
//         // Attest to sign protocol
//         attestationId = spInstance.attest(paymentAttestation, amount, "", "", "");
//         // Save the attestation
//         orderRegistry[orderId].transactee = msg.sender;
//         orderRegistry[orderId].paymentAttestationId = attestationId;

//         emit PaymentAttested(orderId, msg.sender, attestationId); // Log the payment attestation
//     }

//     function _attestPaymentByCurrency(        
//         uint256 orderId,
//         uint256 amount,
//         bytes calldata data // Extra data for proof of payment
//     ) internal returns (uint64 attestationId) {
//         Order memory order = orderRegistry[orderId];
//         if (order.paymentAttestationId != 0) revert SettledOrderPayment(orderId);

//         bytes[] memory recipients = new bytes[](2);
//         recipients[0] = abi.encode(order.merchant);
//         recipients[1] = abi.encode(order.transactee);   

//         IERC20 currency = IERC20(_getBaseCurrency());
//         // Create a payment attestation
//         Attestation memory paymentAttestation = Attestation({
//             schemaId: paymentSchemaId, // Schema for payment (could be different for reviews)
//             linkedAttestationId: 0, // Not linked to another attestation
//             attestTimestamp: uint64(block.timestamp),
//             revokeTimestamp: 0,
//             attester: msg.sender, // Transactee is the attester in this case
//             validUntil: 0, // No expiration for the payment attestation
//             dataLocation: DataLocation.ONCHAIN,
//             revoked: false,
//             recipients: recipients,
//             data: data // Payment metadata or proof
//         });
//         // Attest to sign protocol
//         attestationId = spInstance.attest(paymentAttestation, currency, amount, "", "", "");
//         // Save the attestation
//         orderRegistry[orderId].transactee = msg.sender;
//         orderRegistry[orderId].paymentAttestationId = attestationId;

//         emit PaymentAttested(orderId, msg.sender, attestationId); // Log the payment attestation
//     }

//     function attestPaymentAndReview(uint256 orderId, uint256 amount,bytes calldata paymentData, bytes calldata reviewData) external returns (uint64 paymentAttestationId, uint64 reviewAttestationId) {
//         paymentAttestationId = _attestPaymentByCurrency(orderId, amount, paymentData);
//         reviewAttestationId = _attestReview(orderId, reviewData);
//     }

//     // Function to attest a review (called only if payment has been made prior to this)
//     function attestReview(
//         uint256 orderId,
//         bytes calldata data // Example of review data: a comment
//     ) external returns (uint64 attestationId) {
//        attestationId = _attestReview(orderId, data);
//     }

//         // Function to attest a review (called only if payment has been made prior to this)
//     function _attestReview(
//         uint256 orderId,
//         bytes calldata review // Example of review data: a comment
//     ) internal returns (uint64 attestationId) {
//         Order memory order = orderRegistry[orderId];
//         if (order.paymentAttestationId != 0) revert UnsettledOrderPayment(orderId);
//         if (order.reviewAttestationId == 0) revert SettledOrderReview(orderId);

//         bytes[] memory recipients = new bytes[](2);
//         recipients[0] = abi.encode(order.merchant);
//         recipients[1] = abi.encode(order.transactee);   

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

//     function getOrderSchemas() external view returns(Schema memory paymentSchema, Schema memory reviewSchema) {
//         paymentSchema = spInstance.getSchema(paymentSchemaId);
//         reviewSchema = spInstance.getSchema(reviewSchemaId);

//     }
//     function getOrderAttestations(uint256 orderId) external view returns(Attestation memory paymentAttestation, Attestation memory reviewAttestation) {
//         Order memory order = orderRegistry[orderId];
//         if (!order.settled) revert UnsettledOrder(orderId);

//         paymentAttestation = spInstance.getAttestation(order.paymentAttestationId);
//         reviewAttestation = spInstance.getAttestation(order.reviewAttestationId);
//     }


//     function _getBaseCurrency() internal view returns(address currency) {
//         return BASE_CURRENCY;
//     }

//     function isOrderSettled(uint256 orderId) external view returns (bool) {
//         return orderRegistry[orderId].settled;
//     }
    
// }