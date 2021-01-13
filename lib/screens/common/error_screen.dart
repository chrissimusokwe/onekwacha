import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
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
  final QueryDocumentSnapshot document;
  ErrorScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.to,
    @required this.destinationPlatform,
    @required this.purpose,
    @required this.errorMessage,
    @required this.amount,
    this.currentBalance,
    @required this.transactionType,
    this.document,
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
      Card(
        elevation: 5,
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: kBackgroundShade,
            borderRadius: BorderRadius.circular(10),
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
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        new Text(
                          'Transaction Failed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            fontSize: 18.0,
                            fontFamily: 'BaiJamJuree',
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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
              SizedBox(
                height: 35,
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
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
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
      ),
    );

    // formWidget.add(
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       //Transaction Confirmation button
    //       new RaisedButton(
    //           color: Colors.grey.shade100,
    //           textColor: kTextPrimaryColor,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(16.0),
    //             side: BorderSide(
    //               color: Colors.red,
    //               width: 3,
    //             ),
    //           ),
    //           child: new Text(
    //             MyGlobalVariables.successTranscation.toUpperCase(),
    //             style: TextStyle(
    //               fontSize: kSubmitButtonFontSize,
    //               fontWeight: FontWeight.bold,
    //               fontFamily: 'BaiJamJuree',
    //             ),
    //           ),
    //           onPressed: onPressedConfirm),
    //     ],
    //   ),
    // );
    return formWidget;
  }
}
