// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// import { TokenHelper } from "../helpers/TokenHelper.sol";

// import { Order } from "./models/Order.sol";

// error ZeroBalance();
// error InvalidMerchant();
// error NotSPHookInstance();
// error SettledOrder(uint256 orderId);
// error InvalidMatchingAmount(address token, uint256 amount);

// contract ProjectController is TokenHelper {
//     address public BASE_CURRENCY; // USDC or other stablecoins
//     uint256 public totalOrders;
    
//     // Mapping to store order details with a unique orderID
//     mapping(uint256 => Order) public orderRegistry;
//     mapping(address => uint256) public merchantBalances; // Keeps track of merchant revenue balances

//     event OrderCreated(uint256 indexed orderId, address indexed merchant, uint256 amount);
//     event PaymentReceived(uint256 indexed orderId, address indexed merchant, address indexed transactee, uint256 amount);
//     event RevenueWithdrawn(address indexed merchant, uint256 amount);

//     constructor(address _baseCurrency) {
//         BASE_CURRENCY = _baseCurrency;
//     }

//     // To be called by merchant
//     function _createOutstandingOrder(address merchant, uint256 amount, bytes calldata referenceId) internal returns (uint256 orderId) {
//         totalOrders++;
//         orderId = totalOrders;

//         // Create the new order and associate the merchant and transactee
//         orderRegistry[orderId] = Order({
//             merchant: merchant,
//             payee: address(0),
//             amount: amount,
//             referenceId: referenceId,
//             reviewAttestationId: 0,
//             settled: false
//         });

//         emit OrderCreated(orderId, merchant, amount);
//     }

//     function _getBaseCurrency() internal view returns(address currency) {
//         return BASE_CURRENCY;
//     }
  

//     // Function to allow merchants to withdraw their revenue
//     function withdrawRevenue() external {
//         uint256 balance = merchantBalances[msg.sender];
//         if (balance == 0) {
//             revert ZeroBalance();
//         }
//         // Reset the merchant's balance to zero
//         merchantBalances[msg.sender] = 0;
//        _transferOut(BASE_CURRENCY, msg.sender, balance);

//         emit RevenueWithdrawn(msg.sender, balance);
//     }
// }