import 'package:flutter/material.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:onekwacha/screens/invoicing/invoicing_success.dart';

class ConfirmationDialog {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();

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

  // from: MyGlobalVariables.topUpWalletDestination,
  // to: fullPhoneNumber,
  // destinationPlatform: getKeyValues
  //     .getFundDestinationValue(_selectedFundDestination),
  // purpose: getKeyValues.getPurposeValue(_selectedPurpose),
  // amount: double.parse(_decimalValueNoCommas),
  // currentBalance: _balance,
  // transactionType:
  //     getKeyValues.getTransactionType(_transactionType),

  Future<void> confirmPaymentDialog(
    QueryDocumentSnapshot document,
    BuildContext context,
    String _destination,
    _destinationType,
    _purpose,
    _source,
    _sourceType,
    _transactionTime,
    _transactionTypeName,
    _userID,
    int _transactionType,
    _selectedFundDestination,
    double _previousBalance,
    _amount,
  ) async {
    String _transactionDate;
    int _transactionDay, _transactionMonth, _transactionYear;
    UserModel userModel = new UserModel();
    TransactionModel transactionModel = new TransactionModel();
    bool _updated = false;

    double _currentBalance = await userModel.getUserBalance(_userID);

    double totalAmount = getKeyValues.calculateTotalAmount(
        _amount, getKeyValues.getTransactionType(_transactionType));

    double _availableBalance = _currentBalance - totalAmount;

    double _fee = getKeyValues.calculateFee(
        _amount, getKeyValues.getTransactionType(_transactionType));

    //Check if wallet balance is enough to process required transaction amount
    if (_availableBalance < 0) {
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
                      'Insufficient wallet balance. Please top up before performing this transaction.',
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                            currencyConvertor.format(_amount),
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
                        width: 10,
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
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Invoice ID:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Text(
                        document.id,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
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
      return showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: kDarkPrimaryColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Confirm Payment",
                style: TextStyle(color: kDarkPrimaryColor),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    new Text(
                      'Source:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      getKeyValues
                          .getFundDestinationValue(_selectedFundDestination),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      MyGlobalVariables.onekwachaWalletNumber,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      getKeyValues
                          .getFundDestinationValue(_selectedFundDestination),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      document['ReceivableUserID'],
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Purpose:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      document['Purpose'],
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Transaction Amt:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      MyGlobalVariables.zmcurrencySymbol +
                          currencyConvertor
                              .format(double.parse(document['Amount'])) +
                          '*',
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
                      'Fees:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        new Text(
                          MyGlobalVariables.zmcurrencySymbol +
                              currencyConvertor.format(_fee),
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
                      'Transaction:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new Text(
                      getKeyValues.getTransactionType(_transactionType),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Invoice ID:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new Text(
                      document.id,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Text(
                    ' *Includes transaction fees.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  )
                ]),
              ],
            ),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            //Confirm Payment Dialog
            BasicDialogAction(
              title: Text(
                "PAY",
                style: TextStyle(
                  color: kDarkPrimaryColor,
                ),
              ),
              onPressed: () async {
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
                // _settlementYear =
                //     int.parse(formatDate(DateTime.parse(_transactionDate), [
                //   yy,
                // ]));
                _transactionTime =
                    (formatDate(DateTime.parse(_transactionDate), [
                  hh,
                  ':',
                  nn,
                  ' ',
                  am,
                ]));

                //_destination = document['ReceivableUserID'];
                // _purpose = document['Purpose'];
                // _source = document['PayableUserID'];
                // _userID = document['PayableUserID'];
                //_status = 'Paid';
                _transactionTypeName =
                    getKeyValues.getTransactionType(_transactionType);

                //Create transaction
                documentRef = await transactionModel.createTransaction(
                  _availableBalance,
                  _fee,
                  _previousBalance,
                  _amount,
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
                  document.id,
                );

                if (documentRef != null) {
                  //Pay off invoice and remove it from the Payables tab by setting Status to paid
                  _updated = await userModel.updateUserBalance(
                    _userID,
                    _currentBalance,
                  );
                  if (_updated) {
                    //   //Navigate to the success screen once done
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InvoicingSuccessScreen(
                            currentBalance: _availableBalance,
                            requestFrom: _source,
                            sendTo: _destination,
                            purpose: _purpose,
                            amount: _amount,
                            fee: _fee,
                            transactionType: _transactionType,
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
              },
            ),
          ],
        ),
      );
    }
  }
}
