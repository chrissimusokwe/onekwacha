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
  final String source;
  final String sourceType;
  final String destination;
  final String destinationType;
  final String purpose;
  final double amount;
  final double currentBalance;
  final String transactionType;
  final String cardName;
  final String cardNumber;
  final int cardCvv;
  final int cardMonth;
  final int cardYear;
  final String documentID;
  final double fee;
  TransactionSuccessScreen({
    Key key,
    this.incomingData,
    @required this.source,
    @required this.sourceType,
    @required this.destination,
    @required this.destinationType,
    @required this.purpose,
    this.amount,
    this.currentBalance,
    @required this.transactionType,
    this.cardName,
    this.cardNumber,
    this.cardCvv,
    this.cardMonth,
    this.cardYear,
    this.documentID,
    @required this.fee,
  }) : super(key: key);

  @override
  _TransactionSuccessScreenState createState() =>
      _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  String _destination;
  String _source;
  String _purpose;
  double _fee;
  double _totalAmount;
  String _transactionType;
  String _transactionID;

  //int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _destination = widget.destination;
    _source = widget.source;
    _purpose = widget.purpose;
    _transactionType = widget.transactionType;
    _transactionID = widget.documentID;
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
            child: HomeScreen(),
            type: PageTransitionType.fade,
          ),
          (route) => false);
    }

    formWidget.add(
      Card(
        elevation: 5,
        color: Colors.grey.shade100,
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
                          color: kDefaultPrimaryColor,
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
                            fontSize: 25.0,
                            fontFamily: 'BaiJamJuree',
                            fontWeight: FontWeight.bold,
                            color: kDefaultPrimaryColor,
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
                height: 10,
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
                    child: new Text(
                      _destination,
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
                      'Transaction Amt:',
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
                      'Receipt:',
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
                    elevation: 5,
                    color: Colors.grey.shade100,
                    textColor: kTextPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: kDefaultPrimaryColor,
                        width: 3,
                      ),
                    ),
                    child: new Text(
                      MyGlobalVariables.successTranscation.toUpperCase(),
                      style: TextStyle(
                        fontSize: kSubmitButtonFontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BaiJamJuree',
                        color: kTextPrimaryColor,
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
