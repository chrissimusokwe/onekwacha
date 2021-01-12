import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/models/InvoicingModel.dart';
import 'package:onekwacha/screens/invoicing/invoicing_success.dart';

class InvoicingConfirmationScreen extends StatefulWidget {
  final String requestFrom;
  final String purpose;
  final double amount;
  //final double fee;
  final int transactionType;
  InvoicingConfirmationScreen({
    Key key,
    this.requestFrom,
    this.purpose,
    this.amount,
    //this.fee,
    this.transactionType,
  }) : super(key: key);

  @override
  _InvoicingConfirmationScreenState createState() =>
      _InvoicingConfirmationScreenState();
}

class _InvoicingConfirmationScreenState
    extends State<InvoicingConfirmationScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  String _receivableUserID;
  String _payableUserID;
  String _purpose;
  String _transactionTypeString;
  double _amount = 0;
  double _totalAmount = 0;
  int _transactionType;
  double _fee = 0;

  @override
  Widget build(BuildContext context) {
    _receivableUserID = MyGlobalVariables.onekwachaWalletNumber;
    _payableUserID = widget.requestFrom;
    _purpose = widget.purpose;
    _amount = widget.amount;
    _transactionType = widget.transactionType;
    _transactionTypeString = getKeyValues.getTransactionType(_transactionType);
    _fee = getKeyValues.calculateFee(_amount, _transactionTypeString);
    _totalAmount = _fee + _amount;

    return Form(
        child: Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Confirm invoice',
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
                      'Invoice Details',
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
                      'Requested Amt:',
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
                          currencyConvertor.format(_amount),
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
                      'Total Amount:',
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
                          currencyConvertor.format(_totalAmount),
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
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );

    void onPressedCancel() {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: HomeScreen(
                //walletBalance: widget.currentBalance,
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
                  onPressed: () async {
                    //Create New Invoice
                    DocumentReference document;
                    document = await InvoicingModel.createInvoice(
                      _totalAmount.toString(),
                      _fee.toString(),
                      _purpose,
                      _payableUserID,
                      _receivableUserID,
                    );

                    //Navigate to the success screen once done
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InvoicingSuccessScreen(
                            requestFrom: _payableUserID,
                            sendTo: _receivableUserID,
                            purpose: _purpose,
                            amount: _totalAmount,
                            fee: _fee,
                            transactionType: _transactionType,
                            documentID: document.id,
                          ),
                        ),
                        (route) => false);
                  }),

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
