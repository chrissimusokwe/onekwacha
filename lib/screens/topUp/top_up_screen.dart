import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/common/cards_details_screen.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:intl/intl.dart';

class TopUpScreen extends StatefulWidget {
  final int incomingData;
  final double currentBalance;
  TopUpScreen({
    Key key,
    this.currentBalance,
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
  //int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  int _selectedFundSource = 0;
  int _selectedPurpose = 3;
  int _transactionType = 0;
  String fullPhoneNumber = '';
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

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
          GetKeyValues.getPurposeValue(0),
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
          GetKeyValues.getPurposeValue(1),
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
          GetKeyValues.getPurposeValue(2),
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
          GetKeyValues.getPurposeValue(3),
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
          GetKeyValues.getPurposeValue(4),
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
          GetKeyValues.getPurposeValue(5),
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
          Icons.credit_card,
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
          backgroundColor: kBackgroundShade,
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                Text(
                  'Top up',
                  style: TextStyle(fontSize: kAppBarFontSize),
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
          // bottomNavigationBar: BottomNavigation(
          //   incomingData: _selectedIndex,
          // ),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new Text(
      'From:',
      style: TextStyle(
        fontSize: 14,
        //fontFamily: 'BaiJamJuree',
      ),
    ));

    //Fund source field widget
    formWidget.add(new DropdownButton(
      //hint: Text('Select Source'),
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

    //Phone number field widget
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
                fullPhoneNumber = number.phoneNumber;
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

    //Transaction Purpose field widget
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
          //fontFamily: 'BaiJamJuree',
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

    //Amount field widget
    formWidget.add(new MoneyTextFormField(
      settings: MoneyTextFormFieldSettings(
        controller: topUpAmountField,
        validator: (value) {
          if (double.parse(value) < MyGlobalVariables.minimumTopUpAmount) {
            return 'Minimum allowed is K${currencyConvertor.format(MyGlobalVariables.minimumTopUpAmount)}';
          } else {
            if (double.parse(value) > MyGlobalVariables.maximumTopUpAmount) {
              return 'Maximum allowed is K${currencyConvertor.format(MyGlobalVariables.maximumTopUpAmount)}';
            }
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
            fontSize: 19,
            fontFamily: 'Roboto',
          ),
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
            print(GetKeyValues.getFundSourceValue(_selectedFundSource));
            print(number.phoneNumber);
            print('Top up amount:' +
                double.parse(topUpAmountField.text).toString());
            //print('Tried the amount');
            //amount = new NumberFormat("###.0#", "en_US");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ConfirmationScreen(
                  from: fullPhoneNumber,
                  to: MyGlobalVariables.topUpWalletDestination,
                  destinationPlatform: MyGlobalVariables.topUpWalletDestination,
                  purpose: GetKeyValues.getPurposeValue(_selectedPurpose),
                  amount: double.parse(topUpAmountField.text),
                  currentBalance: widget.currentBalance +
                      double.parse(topUpAmountField.text),
                  transactionType:
                      GetKeyValues.getTransactionTypeValue(_transactionType),
                ),
              ),
            );
            break;
          case 1:
            print(GetKeyValues.getFundSourceValue(_selectedFundSource));
            print(double.parse(topUpAmountField.text));
            //print('Tried the amount');
            print(MyGlobalVariables.zmcurrencySymbol +
                currencyConvertor.format(double.parse(topUpAmountField.text)));
            // print("Eg. 2: ${oCcy.format(.7)}");
            // print("Eg. 3: ${oCcy.format(12345678975 / 100)}");
            // print("Eg. 4: ${oCcy.format(int.parse('12345678975') / 100)}");
            // print("Eg. 5: ${oCcy.format(double.parse('123456789.75'))}");

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ConfirmationScreen(
                  from: GetKeyValues.getFundSourceValue(_selectedFundSource),
                  to: MyGlobalVariables.topUpWalletDestination,
                  destinationPlatform: MyGlobalVariables.topUpWalletDestination,
                  purpose: GetKeyValues.getPurposeValue(_selectedPurpose),
                  amount: double.parse(topUpAmountField.text),
                  currentBalance: widget.currentBalance +
                      double.parse(topUpAmountField.text),
                  transactionType:
                      GetKeyValues.getTransactionTypeValue(_transactionType),
                ),
              ),
            );
            break;
        }
        switch (_selectedPurpose) {
          case 0:
            //print("Business");
            break;
          case 1:
            //print("Entertainment");
            break;
          case 2:
            //print("Education");
            break;
          case 3:
            //print("Family & Friend Support");
            break;
          case 4:
            //print("Groceries");
            break;
          case 5:
            //print("Travel");
            break;
        }
        //print(_formKey.currentContext.toString());
      }
    }

    //Button to go to next page
    formWidget.add(
      SizedBox(
        height: 40,
      ),
    );
    formWidget.add(
      new RaisedButton(
          color: kDefaultPrimaryColor,
          textColor: kTextPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
          child: new Text(
            MyGlobalVariables.nextButton.toUpperCase(),
            style: TextStyle(
              fontSize: kSubmitButtonFontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'BaiJamJuree',
            ),
          ),
          onPressed: onPressedSubmit),
    );
    return formWidget;
  }
}
