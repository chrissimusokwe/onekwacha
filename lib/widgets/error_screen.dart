import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/widgets/cards_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/input_formatters.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/widgets/transaction_success.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/screens/home_screen.dart';

class ErrorScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String to;
  final String destinationPlatform;
  final String purpose;
  final String errorMessage;
  final double amount;
  final double currentBalance;
  final String transactionType;
  ErrorScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.to,
    @required this.destinationPlatform,
    this.purpose,
    this.errorMessage,
    this.amount,
    this.currentBalance,
    @required this.transactionType,
  }) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Transaction status',
              style: TextStyle(
                fontSize: kAppBarFontSize,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView(
          children: getErrorFormWidget(),
        ),
      ),
    ));
  }

  List<Widget> getErrorFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(
      Container(
        decoration: BoxDecoration(
          color: kBackgroundShade,
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
                    'Transaction Failed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //decoration: TextDecoration.underline,
                      fontSize: 18.0,
                      fontFamily: 'BaiJamJuree',
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent.shade700,
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
                  //flex: 1,
                  child: new Text(
                    widget.errorMessage,
                    textAlign: TextAlign.center,
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
            // SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: new Text(
            //         'Error Details:',
            //         textAlign: TextAlign.right,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       flex: 2,
            //       child: new Text(widget.errorMessage),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );

    void onPressedConfirm() {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: HomeScreen(
              walletBalance: widget.amount + widget.currentBalance,
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
