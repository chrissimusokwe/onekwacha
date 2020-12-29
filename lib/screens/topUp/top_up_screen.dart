import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/utils/custom_icons_icons.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/profile/cards_screen.dart';
import 'package:onekwacha/widgets/confirmation_details.dart';
import 'package:page_transition/page_transition.dart';
//import 'dart:math' as math;

class TopUpScreen extends StatefulWidget {
  final int incomingData;
  TopUpScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

enum CardType {
  MasterCard,
  Visa,
  Verve,
  Others, // Any other card issuer
  Invalid // We'll use this when the card is invalid
}

class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard(
      {this.type, this.number, this.name, this.month, this.year, this.cvv});
}

class _TopUpScreenState extends State<TopUpScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  int _selectedFundSource = 0;
  int _selectedPurpose = 0;
  int _enteredAmount = 0;
  //String _name = '';

  List<DropdownMenuItem<int>> fundSourceList = [];
  List<DropdownMenuItem<int>> purposeList = [];
  TextEditingController topUpAmountField = TextEditingController();
  TextEditingController sourcePhoneNumerField = TextEditingController();
  //TextEditingController sourceCardNumerField = TextEditingController();
  String initialCountry = 'ZM';
  PhoneNumber number = PhoneNumber(isoCode: 'ZM');
  List<String> country = ['ZM', 'AU'];
  bool _phoneNumberVisibility = true;
  bool _cardSourceSelected = false;

  void loadPuporseList() {
    purposeList = [];
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.clock,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Business',
        ),
      ),
      value: 0,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.video,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Entertainment',
        ),
      ),
      value: 1,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.department,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Education',
        ),
      ),
      value: 2,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.user,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Family & Friend Support',
        ),
      ),
      value: 3,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.add_shopping_cart,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Groceries',
        ),
      ),
      value: 4,
    ));
    purposeList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.globe_earth,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Travel',
        ),
      ),
      value: 5,
    ));
  }

  void loadFundSourceList() {
    fundSourceList = [];
    fundSourceList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.money,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Mobile Money',
        ),
      ),
      value: 0,
    ));
    fundSourceList.add(DropdownMenuItem(
      child: ListTile(
        leading: Icon(
          CustomIcons.visa,
          color: kDarkPrimaryColor,
        ),
        title: Text(
          'Card',
        ),
      ),
      value: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadFundSourceList();
    loadPuporseList();
    return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                Text(
                  'Top up',
                  style: TextStyle(fontSize: 23.0),
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(
              children: getFormWidget(),
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            incomingData: _selectedIndex,
          ),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new Text(
      'From:',
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'BaiJamJuree',
      ),
    ));
    formWidget.add(new DropdownButton(
      hint: Text('Select Source'),
      items: fundSourceList,
      value: _selectedFundSource,
      onChanged: (value) {
        setState(() {
          _selectedFundSource = value;
          if (_selectedFundSource == 0) {
            _phoneNumberVisibility = true;
            _cardSourceSelected = false;
          } else {
            _phoneNumberVisibility = false;
            _cardSourceSelected = true;
          }
        });
      },
      isExpanded: true,
    ));
    formWidget.add(
      Visibility(
        visible: _phoneNumberVisibility,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            new InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                //print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                //print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                showFlags: true,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: number,
              textFieldController: sourcePhoneNumerField,
              maxLength: 10,
              countrySelectorScrollControlled: false,
              countries: country,
            ),
          ],
        ),
      ),
    );
    formWidget.add(
      Visibility(
        visible: _phoneNumberVisibility,
        child: SizedBox(
          height: 30,
        ),
      ),
    );
    formWidget.add(
      SizedBox(
        height: 30,
      ),
    );
    formWidget.add(
      new Text(
        'Purpose:',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'BaiJamJuree',
        ),
      ),
    );
    formWidget.add(new DropdownButton(
      hint: Text('Select Purpose'),
      value: _selectedPurpose,
      items: purposeList,
      onChanged: (value) {
        setState(() {
          _selectedPurpose = value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(
      SizedBox(
        height: 40,
      ),
    );
    formWidget.add(new MoneyTextFormField(
      settings: MoneyTextFormFieldSettings(
        controller: topUpAmountField,
        validator: (value) {
          if (double.parse(value) < 50.00) {
            return 'Minimum required amount is K50.00';
          }
        },
        moneyFormatSettings: MoneyFormatSettings(
          currencySymbol: 'K',
          fractionDigits: 2,
          displayFormat: MoneyDisplayFormat.symbolOnLeft,
        ),
        appearanceSettings: AppearanceSettings(
          hintText: 'Enter amount',
          labelText: 'Amount:',
          labelStyle: TextStyle(
              color: kTextPrimaryColor,
              fontSize: 18,
              fontFamily: 'BaiJamJuree'),
          inputStyle: TextStyle(
              color: kTextPrimaryColor,
              fontSize: 18,
              fontFamily: 'BaiJamJuree'),
          formattedStyle: TextStyle(
              color: kTextPrimaryColor,
              fontSize: 18,
              fontFamily: 'BaiJamJuree'),
        ),
      ),
    ));

    void onPressedSubmit() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        switch (_selectedFundSource) {
          case 0:
            //print("Mobile Money");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ConfirmationScreen(
                  incomingData: 2,
                ),
              ),
            );
            break;
          case 1:
            //print("Card");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: CardScreen(
                  incomingData: 2,
                ),
              ),
            );
            break;
        }
        switch (_selectedPurpose) {
          case 0:
            print("Business");
            break;
          case 1:
            print("Entertainment");
            break;
          case 2:
            print("Education");
            break;
          case 3:
            print("Family & Friend Support");
            break;
          case 4:
            print("Groceries");
            break;
          case 5:
            print("Travel");
            break;
        }
        print(_formKey.currentContext.toString());
      }
    }

    formWidget.add(
      SizedBox(
        height: 40,
      ),
    );
    formWidget.add(
      new RaisedButton(
          color: kDefaultPrimaryColor,
          textColor: kTextPrimaryColor,
          child: new Text(
            'Next >',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'BaiJamJuree',
            ),
          ),
          onPressed: onPressedSubmit),
    );

    return formWidget;
  }
}
