// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:onekwacha/utils/get_key_values.dart';
// import 'package:onekwacha/screens/common/confirmation_screen.dart';
// import 'package:intl/intl.dart';

// class TriageEngine {
//   //Triage
//   void triage() {}

//   //Top up method
//   void topUp(int _transactionType) {
//     GetKeyValues getKeyValues = new GetKeyValues();
//     BuildContext context;
//     double _currentBalance;
//     int _transactionType,
//         _selectedFundSource,
//         _selectedFundDestination,
//         _selectedPurpose;
//     String _date,
//         _destination,
//         _purpose,
//         _source,
//         _time,
//         _userID,
//         fullPhoneNumber,
//         _decimalValueNoCommas;
//     switch (_selectedFundSource) {
//       case 0:
//         //Top up from Mobile Money
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.rightToLeft,
//             child: ConfirmationScreen(
//               from: fullPhoneNumber,
//               to: getKeyValues.getCurrentUserLoginID(),
//               destinationType: _selectedFundDestination,
//               sourceType:
//                   getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               purpose: getKeyValues.getPurposeValue(_selectedPurpose),
//               amount: double.parse(_decimalValueNoCommas),
//               currentBalance: _currentBalance,
//               transactionType: _transactionType,
//             ),
//           ),
//         );
//         break;
//       case 1:
//         //Top up from Card
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.rightToLeft,
//             child: ConfirmationScreen(
//               from: getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               to: getKeyValues.getCurrentUserLoginID(),
//               destinationType: _selectedFundDestination,
//               sourceType:
//                   getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               purpose: getKeyValues.getPurposeValue(_selectedPurpose),
//               amount: double.parse(_decimalValueNoCommas),
//               currentBalance: _currentBalance,
//               transactionType: _transactionType,
//             ),
//           ),
//         );
//         break;
//     }
//   }

//   //Transfer method
//   void transfer(int _transactionType) {
//     BuildContext context;
//     final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
//     GetKeyValues getKeyValues = new GetKeyValues();
//     double _currentBalance, _fee, _oldBalance, _transactionAmount;
//     int _transactionType,
//         _destinationType,
//         _sourceType,
//         _selectedFundSource,
//         _selectedFundDestination,
//         _selectedPurpose;
//     String _date,
//         _destination,
//         _purpose,
//         _source,
//         _time,
//         _userID,
//         fullPhoneNumber,
//         _invoiceID,
//         _decimalValueNoCommas;
//     switch (_selectedFundSource) {
//       case 0:
//         //Top up from Mobile Money
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.rightToLeft,
//             child: ConfirmationScreen(
//               from: fullPhoneNumber,
//               to: getKeyValues.getCurrentUserLoginID(),
//               destinationType: _selectedFundDestination,
//               sourceType:
//                   getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               purpose: getKeyValues.getPurposeValue(_selectedPurpose),
//               amount: double.parse(_decimalValueNoCommas),
//               currentBalance: _currentBalance,
//               transactionType: _transactionType,
//             ),
//           ),
//         );
//         break;
//       case 1:
//         //Top up from Card
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.rightToLeft,
//             child: ConfirmationScreen(
//               from: getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               to: getKeyValues.getCurrentUserLoginID(),
//               destinationType: _selectedFundDestination,
//               sourceType:
//                   getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
//               purpose: getKeyValues.getPurposeValue(_selectedPurpose),
//               amount: double.parse(_decimalValueNoCommas),
//               currentBalance: _currentBalance,
//               transactionType: _transactionType,
//             ),
//           ),
//         );
//         break;
//     }
//   }

//   void gotoConfirmationScreen() {}
// }
