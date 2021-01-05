import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:intl/intl.dart';

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
  TransactionSuccessScreen({
    Key key,
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
  }) : super(key: key);

  @override
  _TransactionSuccessScreenState createState() =>
      _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

  //int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
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

    formWidget.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
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
                      fontSize: 20.0,
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
                    'From:',
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: new Text(
                    widget.from,
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
                    'Destination:',
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: new Text(widget.destinationPlatform),
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
                  child: new Text(widget.to),
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
                    widget.purpose,
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
                    'Wallet Balance:',
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
                        currencyConvertor.format(widget.currentBalance),
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
                    'Transaction:',
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: new Text(widget.transactionType),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    void onPressedConfirm() {
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
    );
    return formWidget;
  }
}
