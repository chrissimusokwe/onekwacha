import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/screens/invoicing/invoices_screen.dart';

class InvoicingSuccessScreen extends StatefulWidget {
  final String requestFrom;
  final String sendTo;
  final String purpose;
  final double amount;
  final String transactionType;
  InvoicingSuccessScreen({
    Key key,
    this.requestFrom,
    this.sendTo,
    this.purpose,
    this.amount,
    this.transactionType,
  }) : super(key: key);

  @override
  _InvoicingSuccessScreenState createState() => _InvoicingSuccessScreenState();
}

class _InvoicingSuccessScreenState extends State<InvoicingSuccessScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  String _receivableUserID;
  String _payableUserID;
  String _purpose;
  double _amount;
  String _transactionType;

  //int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _receivableUserID = widget.sendTo;
    _payableUserID = widget.requestFrom;
    _purpose = widget.purpose;
    _amount = widget.amount;
    _transactionType = widget.transactionType.toString();
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

    formWidget.add(
      Card(
        elevation: 5,
        color: kDefaultPrimaryColor,
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
                    child: new Text(
                      'SUCCESS!',
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
            ],
          ),
        ),
      ),
    );

    void onPressedConfirm() {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: InvoicingScreen(
              incomingData: 0,
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
                    MyGlobalVariables.successTranscation.toUpperCase(),
                    style: TextStyle(
                      fontSize: kSubmitButtonFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BaiJamJuree',
                    ),
                  ),
                  onPressed: onPressedConfirm),
            ],
          ),
        ],
      ),
    );
    return formWidget;
  }
}
