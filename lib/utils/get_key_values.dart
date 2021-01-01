import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class GetKeyValues {
  static Map<int, String> _purpose = {
    0: 'Business',
    1: 'Entertainment',
    2: 'Education',
    3: 'Family & Friends Support',
    4: 'Groceries',
    5: 'Travel',
  };

  static Map<int, String> _fundSource = {
    0: 'Mobile Money',
    1: 'Card',
  };

  static Map<int, String> _fundDestination = {
    0: 'OneKwacha Wallet',
    1: 'Mobile Money',
    2: 'Bank Account',
  };
  static Map<int, String> _transactionType = {
    0: 'Top up',
    1: 'Transfer',
    2: 'Marketplace',
  };

  static String getPurposeValue(int index) {
    String value = _purpose[index];
    return value;
  }

  static String getFundSourceValue(int index) {
    String value = _fundSource[index];
    return value;
  }

  static String getFundDestinationValue(int index) {
    String value = _fundDestination[index];
    return value;
  }

  static String getTransactionTypeValue(int index) {
    String value = _transactionType[index];
    return value;
  }
}
