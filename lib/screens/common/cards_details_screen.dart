import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/utils/input_formatters.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/common/success_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:date_format/date_format.dart';
import 'package:onekwacha/utils/get_key_values.dart';

class CardScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String to;
  final String destinationType;
  final String sourceType;
  final String purpose;
  final double amount;
  final double totalAmount;
  final double currentBalance;
  final int transactionType;
  final double fee;
  CardScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.to,
    @required this.destinationType,
    @required this.sourceType,
    @required this.purpose,
    @required this.amount,
    @required this.totalAmount,
    this.currentBalance,
    @required this.transactionType,
    @required this.fee,
  }) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  //int _selectedIndex = 2;
  //FocusNode _focusNode = new FocusNode();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController numberController = new TextEditingController();
  PaymentCard _paymentCard = PaymentCard();
  //bool _autoValidate = false;
  PaymentCard _card = new PaymentCard();
  GetKeyValues getKeyValues = new GetKeyValues();
  String _invoiceID;
  double _amount = 0;
  double _totalAmount = 0;
  double _fee = 0;
  double _newWalletBalance = 0;
  //double _previousBalance = 0;
  double creditAmount = 0;
  double debitAmount = 0;
  //double _availableBalance = 0;
  double _currentBalance = 0;
  String _transactionTypeString;
  String _transactionDate,
      _transactionTime,
      _destination,
      _destinationType,
      _sourceType,
      _purpose,
      _source,
      _transactionTypeName,
      _userID;
  int _transactionType, _transactionDay, _transactionMonth, _transactionYear;
  UserModel userModel = new UserModel();
  TransactionModel transactionModel = new TransactionModel();
  bool _updated = false;

  @override
  void initState() {
    super.initState();
    //_focusNode = FocusNode();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  // void _requestFocus() {
  //   setState(() {
  //     FocusScope.of(context).requestFocus(_focusNode);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _purpose = widget.purpose;
    _transactionType = widget.transactionType;
    _amount = widget.amount;
    _transactionTypeString =
        getKeyValues.getTransactionType(widget.transactionType);
    _fee = getKeyValues.calculateFee(_amount, _transactionTypeString);
    _totalAmount =
        getKeyValues.calculateTotalAmount(_amount, _transactionTypeString);
    _userID = getKeyValues.getCurrentUserLoginID();
    _destinationType = widget.destinationType;
    _destination = widget.to;
    _source = widget.from;
    _sourceType = widget.sourceType;

    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(
                'Card details',
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
                  AutovalidateMode.always, //autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),

                  //Name on card
                  new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: const Icon(
                        CustomIcons.user,
                        color: kDarkPrimaryColor,
                        size: 25.0,
                      ),
                      hintText: 'As written your card',
                      labelText: 'Name on Card',
                    ),
                    onSaved: (String value) {
                      _card.name = value;
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? MyGlobalVariables.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //Card number
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(16),
                      new CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: CardUtils.getCardIcon(_paymentCard.type),
                      hintText: '16 digit number behind your card',
                      labelText: 'Card Number',
                    ),
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //CVV Number
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: new Image.asset(
                        'assets/images/card_cvv.png',
                        width: 25.0,
                        color: kDarkPrimaryColor,
                      ),
                      hintText: '3 digit number behind your card',
                      labelText: 'CVV',
                    ),
                    validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _paymentCard.cvv = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //Card expiry date
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      new CardMonthInputFormatter()
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      //filled: true,
                      icon: new Image.asset(
                        'assets/images/calender.png',
                        width: 25.0,
                        color: kDarkPrimaryColor,
                      ),
                      hintText: 'MM/YY',
                      labelText: 'Expiry Date',
                    ),
                    validator: CardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),

                  //Submit button
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    //_focusNode.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _connectionErrorDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
          title: Center(
              child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Connection Error',
                style: TextStyle(color: Colors.red),
              ),
            ],
          )),
          content: Text(
            'Transaction encountered a connection error. Please try again later.',
            style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: kDarkPrimaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  void _notPaidDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
          title: Center(
              child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Transaction Unsuccessful',
                style: TextStyle(color: Colors.red),
              ),
            ],
          )),
          content: Text(
            'Transaction was not processed. Please try again later',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: kDarkPrimaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  void _validateInputs() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        //_autoValidate = true; // Start validating on every change.
      });
      //_showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      //Check for card detail success, otherwise redirect to error screen
      //Once payment card details to payment gateway are confirmed,
      //record the transaction in the database and on

      _transactionTypeName = getKeyValues.getTransactionType(_transactionType);
      _invoiceID = 'Non-Invoice';

      //Get user's current balance
      _currentBalance = await userModel.getUserBalance(_userID);

      //Compute what the new balance will be
      _newWalletBalance = getKeyValues.calculateNewWalletBalance(
          widget.transactionType, _fee, _totalAmount, _currentBalance);

      DocumentReference documentRef;
      _transactionDate = DateTime.now().toString();

      _transactionDay = int.parse(formatDate(DateTime.parse(_transactionDate), [
        dd,
      ]));
      _transactionMonth =
          int.parse(formatDate(DateTime.parse(_transactionDate), [
        mm,
      ]));
      _transactionYear =
          int.parse(formatDate(DateTime.parse(_transactionDate), [
        yy,
      ]));
      _transactionTime = (formatDate(DateTime.parse(_transactionDate), [
        hh,
        ':',
        nn,
        ' ',
        am,
      ]));

      //Pay off invoice and remove it from the Payables tab by setting Status to paid
      _updated = await userModel.updateUserBalance(
        _userID,
        _newWalletBalance,
      );

      //Create transaction
      documentRef = await transactionModel.createTransaction(
        _newWalletBalance,
        _fee,
        _currentBalance,
        _totalAmount,
        _transactionDay,
        _transactionMonth,
        _transactionYear,
        _transactionTypeName,
        _destinationType,
        _sourceType,
        _transactionDate,
        _destination,
        _purpose,
        _source,
        _transactionTime,
        _userID,
        _invoiceID,
      );

      if (documentRef != null) {
        if (_updated) {
          //To Success Screen
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: TransactionSuccessScreen(
                  source: _source,
                  sourceType: _sourceType,
                  destination: _destination,
                  destinationType: _destinationType,
                  purpose: _purpose,
                  amount: _totalAmount,
                  fee: _fee,
                  currentBalance: _currentBalance,
                  transactionType: _transactionTypeString,
                  documentID: documentRef.id,
                ),
              ),
              (route) => false);
        } else {
          _notPaidDialog(context);
        }
      } else {
        _connectionErrorDialog(context);
      }

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     PageTransition(
      //       type: PageTransitionType.rightToLeft,
      //       child: TransactionSuccessScreen(
      //           source: widget.from,
      //           sourceType: 'Card',
      //           destination: widget.to,
      //           destinationType: widget.destinationType,
      //           purpose: widget.purpose,
      //           amount: widget.amount,
      //           currentBalance: widget.currentBalance,
      //           transactionType: _transactionTypeString,
      //           fee: _fee,
      //           cardName: _card.name,
      //           cardNumber: _paymentCard.number,
      //           cardCvv: _paymentCard.cvv,
      //           cardMonth: _paymentCard.month,
      //           cardYear: _paymentCard.year),
      //     ),
      //     (route) => false);
    }
  }

  Widget _getPayButton() {
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
        //splashColor: Colors.deepPurple,
        // shape: RoundedRectangleBorder(
        //   borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
        // ),
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
