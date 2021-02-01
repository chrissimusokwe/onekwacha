import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/invoicing/invoicing_confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class NewInvoiceScreen extends StatefulWidget {
  NewInvoiceScreen({
    Key key,
  }) : super(key: key);

  @override
  _NewInvoiceScreenState createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedPurpose = 3;
  int _transactionType = 2;
  String requestFromPhoneNumber = '';
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  TextEditingController invoiceAmountField = TextEditingController();
  TextEditingController requestFromPhoneNumberField = TextEditingController();
  String initialCountry = 'ZM';
  PhoneNumber number = PhoneNumber(isoCode: 'ZM');
  List<String> country = ['ZM', 'AU'];
  String _decimalValueNoCommas;
  double _validDouble = 0.0;
  //double transferAmount = 0;
  GetKeyValues getKeyValues = new GetKeyValues();
  //double _fee;

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
                  'Create Invoice',
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
    //Receiver Phone number field widget
    formWidget.add(new Text(
      'Request from:',
      style: TextStyle(
        fontSize: 14,
        //fontFamily: 'BaiJamJuree',
      ),
    ));

    formWidget.add(
      Column(
        children: [
          new InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              //print(number.phoneNumber);
              requestFromPhoneNumber = number.phoneNumber;
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
            textFieldController: requestFromPhoneNumberField,
            maxLength: 10,
            countrySelectorScrollControlled: false,
            countries: country,
          ),
        ],
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
        height: 40,
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
          controller: invoiceAmountField,
          validator: (value) {
            _decimalValueNoCommas =
                invoiceAmountField.text.replaceAll(new RegExp(r","), '');

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
            }
            return null;
          },
          inputFormatters: [
            CurrencyTextInputFormatter(
              //locale: 'zm',
              decimalDigits: 2,
              //symbol: 'K',
            )
          ],
          onSaved: (String value) {},
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            //fontWeight: FontWeight.bold,
            fontFamily: 'BaiJamJuree',
          ),
        ),
      ),
    );

    void onConfirmInvoice() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: InvoicingConfirmationScreen(
              requestFrom: requestFromPhoneNumber,
              purpose: getKeyValues.getPurposeValue(_selectedPurpose),
              amount: double.parse(_decimalValueNoCommas),
              //fee: _fee,
              transactionType: _transactionType,
            ),
          ),
        );
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
          child: new Text(
            MyGlobalVariables.nextButton,
            style: TextStyle(
              fontSize: kSubmitButtonFontSize,
              //fontWeight: FontWeight.bold,
              //fontFamily: 'BaiJamJuree',
            ),
          ),
          onPressed: onConfirmInvoice),
    );
    return formWidget;
  }
}
