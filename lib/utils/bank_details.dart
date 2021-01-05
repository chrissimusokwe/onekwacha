import 'package:flutter/material.dart';
import 'package:onekwacha/utils/get_key_values.dart';

class BankDetails {
  String accountName;
  int branchCode;
  int accountNumber;
  String bankName;

  BankDetails(
      {this.accountName, this.branchCode, this.accountNumber, this.bankName});

  @override
  String toString() {
    return '[Account Name: $accountName, Branch Code: $branchCode, Account Number: $accountNumber, Bank: $bankName]';
  }
}

class BankUtils {
  static Widget getBankIcon(int _selectedBank) {
    String img = "";
    Icon icon;
    switch (_selectedBank) {
      case 0:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
      case 1:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
      case 2:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
      case 3:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
      case 4:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
      case 5:
        img = GetKeyValues.getBankListValue(_selectedBank) + '.png';
        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = new Image.asset(
        'assets/images/$img',
        width: 25.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }
}
