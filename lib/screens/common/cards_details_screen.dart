import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/input_formatters.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/common/success_screen.dart';

class CardScreen extends StatefulWidget {
  final int incomingData;
  final String from;
  final String to;
  final String destinationPlatform;
  final String purpose;
  final double amount;
  final double currentBalance;
  final String transactionType;
  final String fee;
  CardScreen({
    Key key,
    this.incomingData,
    @required this.from,
    @required this.to,
    @required this.destinationPlatform,
    @required this.purpose,
    @required this.amount,
    this.currentBalance,
    @required this.transactionType,
    @required this.fee,
  }) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  //int _selectedIndex = 2;
  //FocusNode _focusNode = new FocusNode();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController numberController = new TextEditingController();
  PaymentCard _paymentCard = PaymentCard();
  //bool _autoValidate = false;
  PaymentCard _card = new PaymentCard();
  //double _fee = ;

  @override
  void initState() {
    super.initState();
    //_focusNode = FocusNode();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  // void _requestFocus() {
  //   setState(() {
  //     FocusScope.of(context).requestFocus(_focusNode);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(
                'Card details',
                style: TextStyle(fontSize: kAppBarFontSize),
              ),
            ],
          ),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: new Form(
              key: _formKey,
              autovalidateMode:
                  AutovalidateMode.always, //autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),

                  //Name on card
                  new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: const Icon(
                        CustomIcons.user,
                        color: kDarkPrimaryColor,
                        size: 25.0,
                      ),
                      hintText: 'As written your card',
                      labelText: 'Name on Card',
                    ),
                    onSaved: (String value) {
                      _card.name = value;
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? MyGlobalVariables.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //Card number
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(16),
                      new CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: CardUtils.getCardIcon(_paymentCard.type),
                      hintText: '16 digit number behind your card',
                      labelText: 'Card Number',
                    ),
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //CVV Number
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: new Image.asset(
                        'assets/images/card_cvv.png',
                        width: 25.0,
                        color: kDarkPrimaryColor,
                      ),
                      hintText: '3 digit number behind your card',
                      labelText: 'CVV',
                    ),
                    validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _paymentCard.cvv = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),

                  //Card expiry date
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      new CardMonthInputFormatter()
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      //filled: true,
                      icon: new Image.asset(
                        'assets/images/calender.png',
                        width: 25.0,
                        color: kDarkPrimaryColor,
                      ),
                      hintText: 'MM/YY',
                      labelText: 'Expiry Date',
                    ),
                    validator: CardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),

                  //Submit button
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    //_focusNode.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        //_autoValidate = true; // Start validating on every change.
      });
      //_showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      //_showInSnackBar('Payment card is valid');

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: TransactionSuccessScreen(
                from: widget.from,
                to: widget.to,
                destinationPlatform: widget.destinationPlatform,
                purpose: widget.purpose,
                amount: widget.amount,
                currentBalance: widget.currentBalance,
                transactionType: widget.transactionType,
                fee: widget.fee,
                cardName: _card.name,
                cardNumber: _paymentCard.number,
                cardCvv: _paymentCard.cvv,
                cardMonth: _paymentCard.month,
                cardYear: _paymentCard.year),
          ),
          (route) => false);
    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
        child: const Text(
          MyGlobalVariables.cardDetailsSubmit,
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return new RaisedButton(
        onPressed: _validateInputs,
        color: kDefaultPrimaryColor,
        //splashColor: Colors.deepPurple,
        // shape: RoundedRectangleBorder(
        //   borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
        // ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
        textColor: kTextPrimaryColor,
        child: new Text(
          MyGlobalVariables.cardDetailsSubmit.toUpperCase(),
          style: const TextStyle(
            fontSize: kSubmitButtonFontSize,
          ),
        ),
      );
    }
  }

  // void _showInSnackBar(String value) {
  //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(value),
  //     duration: new Duration(seconds: 3),
  //   ));
  // }
}
