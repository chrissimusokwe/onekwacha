import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/screens/common/cards_details_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/screens/common/success_screen.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:date_format/date_format.dart';

class ConfirmationScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String sourceType;
  final String to;
  final int destinationType;
  final String purpose;
  final double amount;
  final double currentBalance;
  final int transactionType;
  final String accountName;
  final int accountNumber;
  final int brankCode;
  final String bankName;
  final QueryDocumentSnapshot document;
  ConfirmationScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.sourceType,
    @required this.to,
    @required this.destinationType,
    this.purpose,
    @required this.amount,
    this.currentBalance,
    @required this.transactionType,
    this.accountName,
    this.accountNumber,
    this.brankCode,
    this.bankName,
    this.document,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
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
    _destinationType =
        getKeyValues.getFundDestinationValue(widget.destinationType);
    _destination = widget.to;
    _source = widget.from;
    _sourceType = widget.sourceType;
    //_document = widget.document;

    return Form(
        child: Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Confirm transaction',
              style: TextStyle(
                fontSize: kAppBarFontSize,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
        child: ListView(
          children: getConfirmationFormWidget(),
        ),
      ),
      // bottomNavigationBar: BottomNavigation(
      //   incomingData: _selectedIndex,
      // ),
    ));
  }

  List<Widget> getConfirmationFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(
      Card(
        elevation: 5,
        color: kDefaultPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: kDefaultPrimaryColor,
            //borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Transaction Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 18.0,
                        fontFamily: 'BaiJamJuree',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Source:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      _sourceType,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Source #:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      _source,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Destination:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(_destinationType),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Destination #:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(_destination),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Purpose:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      _purpose,
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Amount:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      MyGlobalVariables.zmcurrencySymbol +
                          currencyConvertor.format(widget.amount),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Fees:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      MyGlobalVariables.zmcurrencySymbol +
                          currencyConvertor.format(_fee),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Transaction Total:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        new Text(
                          MyGlobalVariables.zmcurrencySymbol +
                              currencyConvertor.format(_totalAmount) +
                              '*',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Transaction:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(_transactionTypeString),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '*Will appear on your transaciton history.',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );

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

    void onPressedConfirm() async {
      String _cardFundSource = getKeyValues.getTopUpFundSourceValue(1);
      //_destination = document['ReceivableUserID'];
      // _purpose = document['Purpose'];
      // _source = document['PayableUserID'];
      // _userID = document['PayableUserID'];
      //_status = 'Paid';
      _transactionTypeName = getKeyValues.getTransactionType(_transactionType);
      _invoiceID = 'Non-Invoice';

      //Get user's current balance
      _currentBalance = await userModel.getUserBalance(_userID);

      //Compute what the new balance will be
      _newWalletBalance = getKeyValues.calculateNewWalletBalance(
          widget.transactionType, _fee, _totalAmount, _currentBalance);

      //Check that OneKwacha destination wallet is not the same as source
      if (_source == _destination || _sourceType == _destinationType) {
        return showPlatformDialog(
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
                    'Unsuccessful',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Center(
                      child: Text(
                        'Destination wallet is the same as source',
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Source:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        Row(
                          children: [
                            new Text(
                              _sourceType,
                              style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Source #:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        Row(
                          children: [
                            new Text(
                              _source,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Destination:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        Row(
                          children: [
                            new Text(
                              _destinationType,
                              style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Destination #:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        Row(
                          children: [
                            new Text(
                              _destination,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Transaction Amount:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        new Text(
                          MyGlobalVariables.zmcurrencySymbol +
                              currencyConvertor.format(_totalAmount),
                          style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
      } else {
        //Check that balance does not go into negative
        if (_newWalletBalance < 0) {
          //Insufficient wallet balance
          return showPlatformDialog(
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
                      'Unsuccessful',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Center(
                        child: Text(
                          'Insufficient wallet balance. Please top up before conducting this transaction.',
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          new Text(
                            'Transaction Amount:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize),
                          ),
                          SizedBox(
                            width: MyGlobalVariables.sizedBoxWidth,
                          ),
                          new Text(
                            MyGlobalVariables.zmcurrencySymbol +
                                currencyConvertor.format(_totalAmount),
                            style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MyGlobalVariables.sizedBoxHeight,
                      ),
                      Row(
                        children: [
                          new Text(
                            'Available Wallet Balance:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize),
                          ),
                          SizedBox(
                            width: MyGlobalVariables.sizedBoxWidth,
                          ),
                          Row(
                            children: [
                              new Text(
                                MyGlobalVariables.zmcurrencySymbol +
                                    currencyConvertor.format(_currentBalance),
                                style: TextStyle(
                                    fontSize: MyGlobalVariables.dialogFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
        } else {
          //Enough amount in wallet for transaction to proceed

          //Check if fund source is Card
          if (widget.from.toLowerCase() == _cardFundSource.toLowerCase()) {
            //To Card Screen
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: CardScreen(
                  from: widget.from,
                  to: widget.to,
                  sourceType: _sourceType,
                  destinationType: widget.destinationType,
                  purpose: widget.purpose,
                  amount: _amount,
                  totalAmount: _totalAmount,
                  fee: _fee,
                  currentBalance: widget.currentBalance,
                  transactionType: widget.transactionType,
                ),
              ),
            );
          } else {
            DocumentReference documentRef;
            _transactionDate = DateTime.now().toString();

            _transactionDay =
                int.parse(formatDate(DateTime.parse(_transactionDate), [
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

            //print('Now creating transaction');
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
              //Update users balance
              _updated = await userModel.updateUserBalance(
                documentRef.id,
                _userID,
                _newWalletBalance,
              );

              bool _credited = false;

              if (_updated &&
                  _transactionTypeString == 'Transfer' &&
                  _destinationType == 'OneKwacha Wallet') {
                //Credit destination user's OneKwacha wallet
                _credited = await userModel.creditDestinationUserBalance(
                    documentRef.id, _destination, _amount);
                if (_credited) {
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
                //Transaction is not Transfer
                if (_updated) {
                  //print('Now going to success screen');
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
              }
            } else {
              _connectionErrorDialog(context);
            }
          }
        }
      }
    }

    void onPressedCancel() {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: HomeScreen(
              walletBalance: widget.currentBalance,
            ),
            type: PageTransitionType.fade,
          ),
          (route) => false);
    }

    formWidget.add(
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Transaction Confirmation button
              new RaisedButton(
                color: kDefaultPrimaryColor,
                textColor: kTextPrimaryColor,
                child: new Text(
                  MyGlobalVariables.processTranscation.toUpperCase(),
                  style: TextStyle(
                    fontSize: kSubmitButtonFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BaiJamJuree',
                  ),
                ),
                onPressed: () {
                  onPressedConfirm();
                },
              ),

              //Transaction Cancellation button
              new RaisedButton(
                  color: kDefaultPrimaryColor,
                  textColor: kTextPrimaryColor,
                  child: new Text(
                    MyGlobalVariables.cancelTranscation.toUpperCase(),
                    style: TextStyle(
                      fontSize: kSubmitButtonFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BaiJamJuree',
                    ),
                  ),
                  onPressed: onPressedCancel),
            ],
          ),
        ],
      ),
    );
    return formWidget;
  }
}
