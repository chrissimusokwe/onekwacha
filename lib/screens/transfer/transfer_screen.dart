import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/screens/common/error_screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/screens/common/bank_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TransferScreen extends StatefulWidget {
  final int incomingData;
  final double currentBalance;
  TransferScreen({
    Key key,
    this.currentBalance,
    @required this.incomingData,
  }) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedFundDestination = 0;
  int _selectedPurpose = 3;
  int _transactionType = 1;
  int _sourceType = 2;
  String fullPhoneNumber = '';
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  TextEditingController topUpAmountField = TextEditingController();
  TextEditingController destinationPhoneNumerField = TextEditingController();
  String initialCountry = 'ZM';
  PhoneNumber number = PhoneNumber(isoCode: 'ZM');
  List<String> country = ['ZM', 'AU'];
  bool _phoneNumberVisibility = true;
  String _decimalValueNoCommas;
  double _validDouble = 0.0;
  double transferAmount = 0;
  GetKeyValues getKeyValues = new GetKeyValues();

  @override
  Widget build(BuildContext context) {
    getKeyValues.loadFundDestinationList();
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
                  'Send',
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
      'To:',
      style: TextStyle(
        fontSize: 14,
        //fontFamily: 'BaiJamJuree',
      ),
    ));

    //Fund destination field widget
    formWidget.add(new DropdownButton(
      //hint: Text('Select Source'),
      items: getKeyValues.fundDestinationList,
      value: _selectedFundDestination,
      onChanged: (value) {
        setState(() {
          _selectedFundDestination = value;
          if (_selectedFundDestination == 0 || _selectedFundDestination == 1) {
            _phoneNumberVisibility = true;
            //_bankDestinationSelected = false;
          } else {
            _phoneNumberVisibility = false;
            //_bankDestinationSelected = true;
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
              textFieldController: destinationPhoneNumerField,
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

    //Amount field widget
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
        double _amount = double.parse(_decimalValueNoCommas);
        double _balance = widget.currentBalance - _amount;

        switch (_selectedFundDestination) {
          case 0:
            //Destination OneKwacha Wallet
            if (_balance < 0) {
              //Error Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ErrorScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: fullPhoneNumber,
                    destinationPlatform: getKeyValues
                        .getFundDestinationValue(_selectedFundDestination),
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    errorMessage: MyGlobalVariables.errorInssufficientBalance,
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: widget.currentBalance,
                    transactionType:
                        getKeyValues.getTransactionType(_transactionType),
                  ),
                ),
              );
            } else {
              //Confirmation Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ConfirmationScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: fullPhoneNumber,
                    destinationType: _selectedFundDestination,
                    sourceType:
                        getKeyValues.getTransferFundSourceValue(_sourceType),
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: _balance,
                    transactionType: _transactionType,
                  ),
                ),
              );
            }

            break;
          case 1:
            //Destination Mobile Money
            if (_balance < 0) {
              //Error Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ErrorScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: fullPhoneNumber,
                    destinationPlatform: getKeyValues
                        .getFundDestinationValue(_selectedFundDestination),
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    errorMessage: MyGlobalVariables.errorInssufficientBalance,
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: widget.currentBalance,
                    transactionType: getKeyValues.getTransactionType(4),
                  ),
                ),
              );
            } else {
              //Confirmation Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ConfirmationScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: fullPhoneNumber,
                    destinationType: _selectedFundDestination,
                    sourceType:
                        getKeyValues.getTransferFundSourceValue(_sourceType),
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: _balance,
                    transactionType: 4,
                  ),
                ),
              );
            }
            break;
          case 2:
            //Destination Bank Account
            if (_balance < 0) {
              //Error Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ErrorScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: getKeyValues
                        .getFundDestinationValue(_selectedFundDestination),
                    destinationPlatform: getKeyValues
                        .getFundDestinationValue(_selectedFundDestination),
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    errorMessage: MyGlobalVariables.errorInssufficientBalance,
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: widget.currentBalance,
                    transactionType: getKeyValues.getTransactionType(4),
                  ),
                ),
              );
            } else {
              print('balance = ' + _balance.toString());
              //Bank Details Screen
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: BankDetailsScreen(
                    from: getKeyValues.getCurrentUserLoginID(),
                    to: getKeyValues
                        .getFundDestinationValue(_selectedFundDestination),
                    destinationType: _selectedFundDestination,
                    sourceType: _sourceType,
                    purpose: getKeyValues.getPurposeValue(_selectedPurpose),
                    amount: double.parse(_decimalValueNoCommas),
                    currentBalance: _balance,
                    transactionType: 4,
                  ),
                ),
              );
            }
            break;
        }
      }
    }

    //Button to go to next page
    formWidget.add(
      SizedBox(
        height: 30,
      ),
    );
    formWidget.add(
      new RaisedButton(
          elevation: 5,
          color: Colors.grey.shade100,
          textColor: kTextPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: kDefaultPrimaryColor,
              width: 3,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                MyGlobalVariables.nextButton.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BaiJamJuree',
                ),
              ),
              //Icon(Icons.navigate_next_sharp)
            ],
          ),
          onPressed: onPressedSubmit),
    );
    return formWidget;
  }
}
