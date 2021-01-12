import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/screens/home_screen.dart';

class InvoicingSuccessScreen extends StatefulWidget {
  final double currentBalance;
  final String requestFrom;
  final String sendTo;
  final String purpose;
  final double amount;
  final double fee;
  final int transactionType;
  final String documentID;
  InvoicingSuccessScreen({
    Key key,
    this.currentBalance,
    this.requestFrom,
    this.sendTo,
    this.purpose,
    this.amount,
    this.fee,
    this.transactionType,
    this.documentID,
  }) : super(key: key);

  @override
  _InvoicingSuccessScreenState createState() => _InvoicingSuccessScreenState();
}

class _InvoicingSuccessScreenState extends State<InvoicingSuccessScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  String _receivableUserID;
  String _payableUserID;
  String _purpose;
  double _fee;
  double _totalAmount;
  int _transactionType;
  String _transactionID;

  @override
  Widget build(BuildContext context) {
    _receivableUserID = widget.sendTo;
    _payableUserID = widget.requestFrom;
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
            'Invoice status',
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
                    child: new Text(
                        getKeyValues.getTransactionType(_transactionType)),
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
