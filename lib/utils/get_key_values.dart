import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/bank_details.dart';

class GetKeyValues {
  static Map<int, String> _purpose = {
    0: 'Business',
    1: 'Entertainment',
    2: 'Education',
    3: 'Family & Friends Support',
    4: 'Groceries',
    5: 'Travel',
  };

  static Map<int, String> _bank = {
    0: 'Absa',
    1: 'Access',
    2: 'Ecobank',
    3: 'FNB',
    4: 'Stanchart',
    5: 'Zanaco',
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
    2: 'Invoicing',
    3: 'Marketplace',
  };

  static String getPurposeValue(int index) {
    String value = _purpose[index];
    return value;
  }

  static String getBankListValue(int index) {
    String value = _bank[index];
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

  //Need to dynamically pull this from user's profile
  static String onekwachaWalletNumber = '+260987456321';
  static double newInvoiceFee = 50.0;

  static List<DropdownMenuItem<int>> purposeList = [];

  static void loadPuporseList() {
    purposeList = [];
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.clock,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(0),
        ),
      ),
      value: 0,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.video,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(1),
        ),
      ),
      value: 1,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.department,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(2),
        ),
      ),
      value: 2,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.user,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(3),
        ),
      ),
      value: 3,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.add_shopping_cart,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(4),
        ),
      ),
      value: 4,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.globe_earth,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getPurposeValue(5),
        ),
      ),
      value: 5,
    ));
  }

  static List<DropdownMenuItem<int>> fundSourceList = [];

  static void loadFundSourceList() {
    fundSourceList = [];
    fundSourceList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.money,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getFundSourceValue(0),
        ),
      ),
      value: 0,
    ));
    fundSourceList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          Icons.credit_card,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getFundSourceValue(1),
        ),
      ),
      value: 1,
    ));
  }

  static List<DropdownMenuItem<int>> fundDestinationList = [];

  static void loadFundDestinationList() {
    fundDestinationList = [];
    fundDestinationList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.wallet_app,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getFundDestinationValue(0),
        ),
      ),
      value: 0,
    ));
    fundDestinationList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.money,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getFundDestinationValue(1),
        ),
      ),
      value: 1,
    ));
    fundDestinationList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.bank_building,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getFundDestinationValue(2),
        ),
      ),
      value: 2,
    ));
  }

  static List<DropdownMenuItem<int>> bankList = [];

  static void loadBankList() {
    bankList = [];
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(0),
        title: Text(
          getBankListValue(0),
        ),
      ),
      value: 0,
    ));
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(1),
        title: Text(
          getBankListValue(1),
        ),
      ),
      value: 1,
    ));
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(2),
        title: Text(
          getBankListValue(2),
        ),
      ),
      value: 2,
    ));
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(3),
        title: Text(
          getBankListValue(3),
        ),
      ),
      value: 3,
    ));
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(4),
        title: Text(
          getBankListValue(4),
        ),
      ),
      value: 4,
    ));
    bankList.add(DropdownMenuItem(
      child: ListTile(
        leading: BankUtils.getBankIcon(5),
        title: Text(
          getBankListValue(5),
        ),
      ),
      value: 5,
    ));
  }
}
