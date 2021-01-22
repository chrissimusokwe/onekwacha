import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/bank_details.dart';

class GetKeyValues {
  Map<int, String> _purpose = {
    0: 'Business',
    1: 'Entertainment',
    2: 'Education',
    3: 'Family & Friends',
    4: 'Merchant',
    5: 'Travel',
  };

  Map<String, IconData> _transactionTypeIcons = {
    'Top up': CustomIcons.plus,
    'Transfer': CustomIcons.initiate_money_transfer,
    'Invoicing': CustomIcons.bill,
    'Marketplace': CustomIcons.shopping_cart,
    'Cash out': CustomIcons.wallet_app,
  };

  Map<String, IconData> _purposeIcons = {
    'Business': CustomIcons.clock,
    'Entertainment': CustomIcons.video,
    'Education': CustomIcons.department,
    'Family & Friends': CustomIcons.user,
    'Merchant': CustomIcons.add_shopping_cart,
    'Travel': CustomIcons.globe_earth,
  };

  Map<int, String> _bank = {
    0: 'Absa',
    1: 'Access',
    2: 'Ecobank',
    3: 'FNB',
    4: 'Stanchart',
    5: 'Zanaco',
  };

  Map<int, String> _topUpfundSource = {
    0: 'Mobile Money',
    1: 'Card',
  };

  Map<int, String> _gender = {
    0: 'Male',
    1: 'Female',
  };
  Map<String, int> _genderNumber = {
    'Male': 0,
    'Female': 1,
  };

  Map<int, String> _transferFundSource = {
    0: 'Mobile Money',
    1: 'Card',
    2: 'OneKwacha Wallet',
  };

  Map<int, String> _fundDestination = {
    0: 'OneKwacha Wallet',
    1: 'Mobile Money',
    2: 'Bank Account',
    3: 'Merchant',
  };

  Map<String, double> _transactionTypeRate = {
    'Top up': 1.5,
    'Transfer': 1,
    'Invoicing': 2.5,
    'Marketplace': 0,
    'Cash out': 5,
  };
  Map<int, String> _transactionType = {
    0: 'Top up',
    1: 'Transfer',
    2: 'Invoicing',
    3: 'Marketplace',
    4: 'Cash out',
  };

  String getCurrentUserLoginID() {
    String value;
    value = '+260987456321';
    return value;
  }

  // String getGenderString(int _selectedGenderValue) {
  //   String value = _gender[_selectedGenderValue];
  //   return value;
  // }

  double calculateNewWalletBalance(
    int transactionType,
    double fee,
    transactionTotal,
    currentBalance,
  ) {
    double value;
    switch (transactionType) {
      case 0:
        //top up
        value = currentBalance + (transactionTotal - fee);
        break;
      case 1:
        //Tranfers
        value = currentBalance - (transactionTotal);
        break;
      case 2:
        //Invoicing
        value = currentBalance - (transactionTotal);
        break;
      case 3:
        //Marketplace
        value = currentBalance - (transactionTotal - fee);
        break;
      case 4:
        //Cash out
        value = currentBalance - (transactionTotal);
        break;
    }

    return value;
  }

  double calculateTotalAmount(
      double transacationAmount, String transactionType) {
    double value =
        transacationAmount + calculateFee(transacationAmount, transactionType);
    return value;
  }

  double calculateFee(double transacationAmount, String transactionType) {
    double value = transacationAmount * (getFeeRate(transactionType) / 100);
    return value;
  }

  double getFeeRate(String transactionType) {
    double value = _transactionTypeRate[transactionType];
    return value;
  }

  IconData getTransactionTypeIcons(String transactionType) {
    IconData value = _transactionTypeIcons[transactionType];
    return value;
  }

  String getBankListValue(int index) {
    String value = _bank[index];
    return value;
  }

  String getPurposeValue(int index) {
    String value = _purpose[index];
    return value;
  }

  IconData getPurposeIcons(String purpose) {
    IconData value = _purposeIcons[purpose];
    return value;
  }

  String getGenderString(int _selectedGenderValue) {
    String value = _gender[_selectedGenderValue];
    return value;
  }

  int getGenderValue(String value) {
    int index = _genderNumber[value];
    return index;
  }

  String getTransferFundSourceValue(int index) {
    String value = _transferFundSource[index];
    return value;
  }

  String getTopUpFundSourceValue(int index) {
    String value = _topUpfundSource[index];
    return value;
  }

  String getFundDestinationValue(int index) {
    String value = _fundDestination[index];
    return value;
  }

  String getTransactionType(int index) {
    String value = _transactionType[index];
    return value;
  }

  //static List<DropdownMenuItem<int>> purposeIcons = [];

  List<DropdownMenuItem<int>> purposeList = [];

  void loadPuporseList() {
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

  List<DropdownMenuItem<int>> fundSourceList = [];

  void loadFundSourceList() {
    fundSourceList = [];
    fundSourceList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.money,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          getTopUpFundSourceValue(0),
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
          getTopUpFundSourceValue(1),
        ),
      ),
      value: 1,
    ));
  }

  List<DropdownMenuItem<int>> fundDestinationList = [];

  List<DropdownMenuItem<int>> genderList = [];

  void loadGenderList() {
    genderList = [];
    genderList.add(DropdownMenuItem(
      child: Text(
        'Male',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      value: 0,
    ));
    genderList.add(DropdownMenuItem(
      child: Text(
        'Female',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      value: 1,
    ));
  }

  void loadFundDestinationList() {
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

  List<DropdownMenuItem<int>> bankList = [];

  void loadBankList() {
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

  String formatPhoneNumberWithSpaces(String number) {
    String part1;
    String part2;
    String part3;
    String part4;
    String result;

    part1 = number.substring(0, 4);
    part2 = number.substring(4, 7);
    part3 = number.substring(7, 10);
    part4 = number.substring(10, 13);
    result = part1 + ' ' + part2 + ' ' + part3 + ' ' + part4;
    return result;
  }
}
