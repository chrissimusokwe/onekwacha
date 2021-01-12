import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/utils/get_key_values.dart';

class TransactionSuccessScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String to;
  final String destinationPlatform;
  final String purpose;
  final double amount;
  final double currentBalance;
  final String transactionType;
  final String cardName;
  final String cardNumber;
  final int cardCvv;
  final int cardMonth;
  final int cardYear;
  final QueryDocumentSnapshot document;
  final String fee;
  TransactionSuccessScreen(
      {Key key,
      this.incomingData,
      @required this.from,
      @required this.to,
      @required this.destinationPlatform,
      @required this.purpose,
      this.amount,
      this.currentBalance,
      @required this.transactionType,
      this.cardName,
      this.cardNumber,
      this.cardCvv,
      this.cardMonth,
      this.cardYear,
      this.document,
      @required this.fee})
      : super(key: key);

  @override
  _TransactionSuccessScreenState createState() =>
      _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  String _receivableUserID;
  String _payableUserID;
  String _purpose;
  String _fee;
  double _totalAmount;
  String _transactionType;
  String _transactionID;

  //int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _receivableUserID = widget.to;
    _payableUserID = widget.from;
    _purpose = widget.purpose;
    _transactionType = widget.transactionType;
    _transactionID = widget.document.id.toString();
    _fee = widget.fee;
    _totalAmount = widget.amount;
    return Form(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Transaction status',
            style: TextStyle(
              fontSize: kAppBarFontSize,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
        child: ListView(
          children: getConfirmationFormWidget(),
        ),
      ),
    ));
  }

  List<Widget> getConfirmationFormWidget() {
    List<Widget> formWidget = new List();

    void onPressedConfirm() {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: HomeScreen(
              //incomingData: 0,
              walletBalance: widget.currentBalance,
            ),
            type: PageTransitionType.fade,
          ),
          (route) => false);
    }

    formWidget.add(
      Card(
        elevation: 5,
        color: kDarkPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
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
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: kDarkPrimaryColor,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        new Text(
                          'Transaction Successful!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            fontSize: 18.0,
                            fontFamily: 'BaiJamJuree',
                            fontWeight: FontWeight.bold,
                            color: kDarkPrimaryColor,
                          ),
                        ),
                      ],
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
                      'Request from:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      _payableUserID,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Send to:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(
                      _receivableUserID,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Total Amt:',
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
                          currencyConvertor.format(_totalAmount) +
                          '*',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                    child: new Text(_transactionType),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new Text(
                      'Transaction ID:',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: new Text(_transactionID.toString()),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Expanded(
                  child: Center(
                    child: Text(
                      ' *Includes transaction fees.',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Transaction Confirmation button
                  new RaisedButton(
                    color: Colors.grey.shade100,
                    textColor: kTextPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: kDarkPrimaryColor,
                        width: 3,
                      ),
                    ),
                    child: new Text(
                      MyGlobalVariables.successTranscation.toUpperCase(),
                      style: TextStyle(
                        fontSize: kSubmitButtonFontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BaiJamJuree',
                        color: kDarkPrimaryColor,
                      ),
                    ),
                    onPressed: onPressedConfirm,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return formWidget;
  }
}
