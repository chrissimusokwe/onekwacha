// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:onekwacha/utils/get_key_values.dart';
// import 'package:onekwacha/utils/global_strings.dart';

class TriageEngine {
  final int incomingData;
  final String from;
  final String to;
  final String destinationPlatform;
  final String purpose;
  final double amount;
  final double currentBalance;
  final String transactionType;
  final String accountName;
  final int accountNumber;
  final int brankCode;
  final String bankName;

  TriageEngine({
    this.incomingData,
    this.from,
    this.to,
    this.destinationPlatform,
    this.purpose,
    this.amount,
    this.currentBalance,
    this.transactionType,
    this.accountName,
    this.accountNumber,
    this.brankCode,
    this.bankName,
  });

  void triage(int _transaction) {
    switch (_transaction) {
      //Top up
      case 0:

      //Transfer
      case 1:

      //Invoicing
      case 2:

      //Marketplace
      case 3:
    }
  }

  void gotoConfirmationScreen() {}
}
