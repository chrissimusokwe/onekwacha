import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/utils/bank_details.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String to;
  final String destinationPlatform;
  final String purpose;
  final double amount;
  final double currentBalance;
  final String transactionType;
  BankDetailsScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.to,
    @required this.destinationPlatform,
    @required this.purpose,
    this.amount,
    this.currentBalance,
    @required this.transactionType,
  }) : super(key: key);

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  int _selectedBank = 0;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _accountName = new TextEditingController();
  TextEditingController _accountNumber = new TextEditingController();
  TextEditingController _branchCode = new TextEditingController();
  GetKeyValues getKeyValues = new GetKeyValues();
  // AutovalidateMode _autoValidate;

  BankDetails _bankDetail = BankDetails();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getKeyValues.loadBankList();
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(
                'Bank details',
                style: TextStyle(fontSize: kAppBarFontSize),
              ),
            ],
          ),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: new Form(
              key: _formKey,
              autovalidateMode:
                  AutovalidateMode.disabled, //  autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),

                  //Name on card
                  new TextFormField(
                    controller: _accountName,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: const Icon(
                        CustomIcons.user,
                        color: kDarkPrimaryColor,
                        size: 25.0,
                      ),
                      //hintText: 'As written your card',
                      labelText: 'Account Name',
                    ),
                    onSaved: (String value) {
                      _bankDetail.accountName = value;
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? MyGlobalVariables.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),

                  //Branch Code
                  new TextFormField(
                    controller: _branchCode,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: const Icon(
                        CustomIcons.bank_building,
                        color: kDarkPrimaryColor,
                      ),
                      //hintText: '3 digit number behind your card',
                      labelText: 'Branch code',
                    ),
                    //validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    validator: (String value) =>
                        value.isEmpty ? MyGlobalVariables.fieldReq : null,
                    onSaved: (value) {
                      _bankDetail.branchCode = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),

                  //Account Number
                  new TextFormField(
                    controller: _accountNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(15),
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: const Icon(
                        CustomIcons.bank_building,
                        color: kDarkPrimaryColor,
                      ),
                      //hintText: '3 digit number behind your card',
                      labelText: 'Account Number',
                    ),
                    validator: (String value) =>
                        value.isEmpty ? MyGlobalVariables.fieldReq : null,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _bankDetail.accountNumber = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),

                  //Bank Name
                  new Text(
                    'Bank Name',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700
                        //fontFamily: 'BaiJamJuree',
                        ),
                  ),
                  new DropdownButton(
                    hint: Text('Select bank'),
                    value: _selectedBank,
                    items: getKeyValues.bankList,
                    onChanged: (value) {
                      setState(() {
                        _selectedBank = value;
                      });
                    },
                    isExpanded: true,
                  ),

                  new SizedBox(
                    height: 20.0,
                  ),
                  new Text(
                    "IMPORTANT: Funds sent to incorrect banking details can't be reversed. Ensure that the above details are correct before submitting.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  //Submit button
                  new Container(
                    alignment: Alignment.center,
                    child: _getSubmitButton(),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Validating form inputs
  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        //_autoValidate = true; // Start validating on every change.
      });
      //_showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      //_showInSnackBar('Payment card is valid');
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ConfirmationScreen(
            from: MyGlobalVariables.topUpWalletDestination,
            to: getKeyValues.getBankListValue(_selectedBank) +
                ' - ' +
                _branchCode.text +
                ' - ' +
                _accountNumber.text,
            destinationPlatform: widget.destinationPlatform,
            purpose: widget.purpose,
            amount: widget.amount,
            currentBalance: widget.currentBalance,
            transactionType: widget.transactionType,
            accountName: _accountName.text,
            accountNumber: int.parse(_accountNumber.text),
            brankCode: int.parse(_branchCode.text),
            bankName: getKeyValues.getBankListValue(_selectedBank),
          ),
        ),
      );
    }
  }

  //Submit button
  Widget _getSubmitButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
        child: const Text(
          MyGlobalVariables.cardDetailsSubmit,
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return new RaisedButton(
        onPressed: _validateInputs,
        color: kDefaultPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
        textColor: kTextPrimaryColor,
        child: new Text(
          MyGlobalVariables.cardDetailsSubmit.toUpperCase(),
          style: const TextStyle(
            fontSize: kSubmitButtonFontSize,
          ),
        ),
      );
    }
  }

  // void _showInSnackBar(String value) {
  //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(value),
  //     duration: new Duration(seconds: 3),
  //   ));
  // }
}
