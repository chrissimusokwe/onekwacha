import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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

// enum CardType {
//   MasterCard,
//   Visa,
//   Verve,
//   Others, // Any other card issuer
//   Invalid // We'll use this when the card is invalid
// }

// class PaymentCard {
//   CardType type;
//   String number;
//   String name;
//   int month;
//   int year;
//   int cvv;

//   PaymentCard(
//       {this.type, this.number, this.name, this.month, this.year, this.cvv});
// }

class _TopUpScreenState extends State<TopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedFundSource = 0;
  int _selectedFundDestination = 0;
  int _selectedPurpose = 3;
  int _transactionType = 0;
  String fullPhoneNumber = '';
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();

  TextEditingController topUpAmountField = TextEditingController();
  TextEditingController sourcePhoneNumerField = TextEditingController();
  String initialCountry = 'ZM';
  PhoneNumber number = PhoneNumber(isoCode: 'ZM');
  List<String> country = ['ZM', 'AU'];
  bool _phoneNumberVisibility = true;
  String _decimalValueNoCommas;
  double _validDouble = 0.0;
  double transferAmount = 0;
  //double _totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    getKeyValues.loadFundSourceList();
    getKeyValues.loadPuporseList();
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
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
      items: getKeyValues.fundSourceList,
      value: _selectedFundSource,
      onChanged: (value) {
        setState(() {
          _selectedFundSource = value;
          if (_selectedFundSource == 0) {
            _phoneNumberVisibility = true;
          } else {
            _phoneNumberVisibility = false;
            sourcePhoneNumerField.text = '';
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
              height: 20,
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
        height: 20,
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
      items: getKeyValues.purposeList,
      onChanged: (value) {
        setState(() {
          _selectedPurpose = value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(
      SizedBox(
        height: 20,
      ),
    );

    //Amount field widgets
    formWidget.add(
      new Text(
        'Amount:',
        style: TextStyle(
          fontSize: 14,
          //fontFamily: 'BaiJamJuree',
        ),
      ),
    );

    formWidget.add(
      ListTile(
        leading: Text(
          MyGlobalVariables.zmcurrencySymbol,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'BaiJamJuree',
          ),
        ),
        title: new TextFormField(
          controller: topUpAmountField,
          validator: (value) {
            _decimalValueNoCommas =
                topUpAmountField.text.replaceAll(new RegExp(r","), '');

            if (_decimalValueNoCommas.isNotEmpty ||
                _decimalValueNoCommas != null) {
              try {
                _validDouble = double.parse(_decimalValueNoCommas);

                if (_validDouble < MyGlobalVariables.minimumTopUpAmount) {
                  return 'Minimum allowed is K${currencyConvertor.format(MyGlobalVariables.minimumTopUpAmount)}';
                } else {
                  if (_validDouble > MyGlobalVariables.maximumTopUpAmount) {
                    return 'Maximum allowed is K${currencyConvertor.format(MyGlobalVariables.maximumTopUpAmount)}';
                  }
                  return null;
                }
              } catch (identifier) {
                return 'Enter amount';
              }
            } else {
              return 'String is null or empty';
            }
          },
          inputFormatters: [
            CurrencyTextInputFormatter(
              //locale: 'zm',
              decimalDigits: 2,
              //symbol: 'K',
            )
          ],
          onSaved: (String value) {},
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            //fontWeight: FontWeight.bold,
            fontFamily: 'BaiJamJuree',
          ),
        ),
      ),
    );

    void onPressedSubmit() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        switch (_selectedFundSource) {
          case 0:
            //Top up from Mobile Money
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ConfirmationScreen(
                  from: fullPhoneNumber,
                  to: getKeyValues.getCurrentUserLoginID(),
                  destinationType: _selectedFundDestination,
                  sourceType:
                      getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
                  purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                  amount: double.parse(_decimalValueNoCommas),
                  currentBalance: widget.currentBalance,
                  transactionType: _transactionType,
                ),
              ),
            );
            break;
          case 1:
            //Top up from Card
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ConfirmationScreen(
                  from:
                      getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
                  to: getKeyValues.getCurrentUserLoginID(),
                  destinationType: _selectedFundDestination,
                  sourceType:
                      getKeyValues.getTopUpFundSourceValue(_selectedFundSource),
                  purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                  amount: double.parse(_decimalValueNoCommas),
                  currentBalance: widget.currentBalance,
                  transactionType: _transactionType,
                ),
              ),
            );
            break;
        }
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
        onPressed: onPressedSubmit,
      ),
    );
    return formWidget;
  }
}
