import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:onekwacha/models/merchantModel.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onekwacha/screens/common/success_screen.dart';
import 'package:page_transition/page_transition.dart';

class LiteSpeedProductScreen extends StatefulWidget {
  final int incomingData;
  final String merchantName;
  final String productsToken;
  final String userProductUrl;
  final String topUpUrl;
  final String merchantLogo;
  final String selectedProductCode;
  final String selectedProductDesctiption;
  final String selectedProductCategory;
  final String selectedPrice;
  LiteSpeedProductScreen({
    this.incomingData,
    @required this.merchantName,
    @required this.productsToken,
    @required this.userProductUrl,
    @required this.merchantLogo,
    @required this.topUpUrl,
    @required this.selectedProductCode,
    @required this.selectedProductDesctiption,
    @required this.selectedPrice,
    this.selectedProductCategory,
    Key key,
  }) : super(key: key);

  @override
  _LiteSpeedProductScreenState createState() => _LiteSpeedProductScreenState();
}

class _LiteSpeedProductScreenState extends State<LiteSpeedProductScreen> {
  //ProductsModel getproductModel = new ProductsModel();
  //Future<List<ProductsModel>> listSpeedModel;
  final _formKey = new GlobalKey<FormState>();
  GetKeyValues getKeyValues = new GetKeyValues();
  TextEditingController _ctrlMSISDN = new TextEditingController();
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  String _productCategory;

  int _transactionType, _transactionDay, _transactionMonth, _transactionYear;
  UserModel userModel = new UserModel();
  TransactionModel transactionModel = new TransactionModel();
  MerchantTransactionModel merchantTransactionModel =
      new MerchantTransactionModel();
  bool _isUserUpdated = false;
  String _invoiceID;
  double _amount = 0;
  double _totalAmount = 0;
  double _fee = 0;
  double _newWalletBalance = 0;
  //double _previousBalance = 0;
  double creditAmount = 0;
  double debitAmount = 0;
  //double _availableBalance = 0;
  double _currentBalance = 0;
  String _transactionTypeString;
  String _transactionDate,
      _transactionTime,
      _destination,
      _destinationType,
      _sourceType,
      _purpose,
      _source,
      _transactionTypeName,
      _userID;
  bool _isPurchased = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Check tha product category is not null
    (widget.selectedProductCategory != null)
        ? _productCategory = capitalize(widget.selectedProductCategory)
        : _productCategory = null;

    //Variable initialisations
    _purpose = getKeyValues.getPurposeValue(4); //Purpose as 'Merchant'
    _transactionType = 3; //Transaction Type as 'Marketplace'
    _amount = double.parse(widget.selectedPrice);
    _transactionTypeString = getKeyValues.getTransactionType(_transactionType);
    _fee = getKeyValues.calculateFee(_amount, _transactionTypeString);
    _totalAmount =
        getKeyValues.calculateTotalAmount(_amount, _transactionTypeString);
    _userID = getKeyValues.getCurrentUserLoginID();
    _destinationType =
        getKeyValues.getFundDestinationValue(3); //Destination as 'Merchant'
    _destination = widget.merchantName;
    _source = _userID;
    _sourceType =
        getKeyValues.getTransferFundSourceValue(2); //Fund source as 'OneKwacha'

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
        backgroundColor: kBackgroundShade,
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(
                'Purchase',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: _getListSpeedProductWidgets(),
          ),
        ),
        // bottomNavigationBar: BottomNavigation(
        //   incomingData: 0,
        // ),
      ),
    );
  }

  List<Widget> _getListSpeedProductWidgets() {
    void _connectionErrorDialog(BuildContext context) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
            title: Center(
                child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Connection Error',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
            content: Text(
              'Transaction encountered a connection error. Please try again later.',
              style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Cancel",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
      );
    }

    void _notPaidDialog(BuildContext context) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
            title: Center(
                child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Transaction Unsuccessful',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
            content: Text(
              'Do not retry this transaction. Please contact Serengeti Technologies Ltd to resolve the issue. Apologies for the incovinience caused.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Cancel",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
      );
    }

    //Purchase confirmation dialog pop up
    void processPurchase(BuildContext context) async {
      _transactionTypeName = getKeyValues.getTransactionType(_transactionType);
      _invoiceID = 'Non-Invoice';

      //Get user's current balance
      _currentBalance = await userModel.getUserBalance(_userID);

      //Compute what the new balance will be
      _newWalletBalance = getKeyValues.calculateNewWalletBalance(
          _transactionType, _fee, _totalAmount, _currentBalance);

      if (_newWalletBalance < 0) {
        //Insufficient wallet balance
        return showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
              title: Center(
                  child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Unsuccessful',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Center(
                      child: Text(
                        'Insufficient wallet balance. Please top up before conducting this transaction.',
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Transaction Amount:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        new Text(
                          MyGlobalVariables.zmcurrencySymbol +
                              currencyConvertor.format(_totalAmount),
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Available Wallet Balance:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: MyGlobalVariables.sizedBoxWidth,
                        ),
                        Row(
                          children: [
                            new Text(
                              MyGlobalVariables.zmcurrencySymbol +
                                  currencyConvertor.format(_currentBalance),
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    "Cancel",
                    style: TextStyle(color: kDarkPrimaryColor),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPurchased = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ]),
        );
      } else {
        //TODO: Check if MSISDN exists on PRISM API
        //TODO: Process transaction on PRISM

        DocumentReference _transactionDocumentRef;
        _transactionDate = DateTime.now().toString();

        _transactionDay =
            int.parse(formatDate(DateTime.parse(_transactionDate), [
          dd,
        ]));
        _transactionMonth =
            int.parse(formatDate(DateTime.parse(_transactionDate), [
          mm,
        ]));
        _transactionYear =
            int.parse(formatDate(DateTime.parse(_transactionDate), [
          yy,
        ]));
        _transactionTime = (formatDate(DateTime.parse(_transactionDate), [
          hh,
          ':',
          nn,
          ' ',
          am,
        ]));

        //Record transaction in the general ledger
        _transactionDocumentRef = await transactionModel.createTransaction(
          _newWalletBalance,
          _fee,
          _currentBalance,
          _totalAmount,
          _transactionDay,
          _transactionMonth,
          _transactionYear,
          _transactionTypeName,
          _destinationType,
          _sourceType,
          _transactionDate,
          _destination,
          _purpose,
          _source,
          _transactionTime,
          _ctrlMSISDN.text,
          _invoiceID,
          widget.selectedProductCode,
          'None',
        );

        //Update user balance and last transaction id
        if (_transactionDocumentRef != null) {
          //Update users balance
          _isUserUpdated = await userModel.updateUserBalance(
            _transactionDocumentRef.id,
            _userID,
            _newWalletBalance,
            _transactionDate,
          );

          DocumentReference _isMerchantTransactionCreated;

          if (_isUserUpdated) {
            //Record transaction under merchant transactions ledger
            _isMerchantTransactionCreated =
                await merchantTransactionModel.createMerchantTransaction(
              _fee,
              _totalAmount,
              _transactionDay,
              _transactionMonth,
              _transactionYear,
              _destination,
              widget.selectedProductCode,
              widget.selectedProductDesctiption,
              widget.selectedPrice,
              _productCategory,
              _transactionTypeName,
              _destinationType,
              _sourceType,
              _transactionDate,
              _destination,
              _purpose,
              _source,
              _transactionTime,
              _ctrlMSISDN.text,
              _transactionDocumentRef.id,
            );

            if (_isMerchantTransactionCreated != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TransactionSuccessScreen(
                      source: _source,
                      sourceType: _sourceType,
                      destination: _destination +
                          ' - ' +
                          widget.selectedProductCode.replaceAll('_', ' '),
                      destinationType: _destinationType,
                      purpose: _purpose,
                      amount: _totalAmount,
                      fee: _fee,
                      currentBalance: _currentBalance,
                      transactionType: _transactionTypeString,
                      documentID: _transactionDocumentRef.id,
                    ),
                  ),
                  (route) => false);
            } else {
              _notPaidDialog(context);
            }
          } else {
            _notPaidDialog(context);
          }
        } else {
          _connectionErrorDialog(context);
        }
      }
    }

    void _confirmPurchaseDialog(BuildContext context) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
            title: Center(
                child: Column(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: kDarkPrimaryColor,
                  size: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Confirm Purchase',
                  style: TextStyle(
                    color: kDarkPrimaryColor,
                    fontSize: 22,
                  ),
                ),
              ],
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Are you sure you would like to purchase ${widget.selectedProductCode.replaceAll('_', ' ')}?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Confirm",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
                onPressed: () {
                  setState(() {
                    _isPurchased = true;
                  });
                  Navigator.pop(context);
                  processPurchase(context);
                },
              ),
              BasicDialogAction(
                title: Text(
                  "Dismiss",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
      );
    }

    List<Widget> formWidget = new List();
    formWidget.add(
      SizedBox(
        height: 5,
      ),
    );

    //Product heading
    formWidget.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/marketplace/' + widget.merchantLogo,
                  width: 60,
                ),
                Text(
                  'You are about to purchase the below product from ' +
                      widget.merchantName,
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    //fontFamily: 'Metrophobic',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20,
      ),
    );

    //Product details
    formWidget.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),

          //Selected product code
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                widget.selectedProductCode.replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          //Product description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: new Text(
                  'Description:',
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: new Text(
                  widget.selectedProductDesctiption,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          //Category
          Row(
            children: [
              Expanded(
                flex: 1,
                child: new Text(
                  'Category:',
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: new Text(
                  _productCategory ?? 'None',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          //Price
          Row(
            children: [
              Expanded(
                flex: 1,
                child: new Text(
                  'Price:',
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
                      currencyConvertor
                          .format(double.parse(widget.selectedPrice)) +
                      '*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          //MSISDN text field
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                    controller: _ctrlMSISDN,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: 'Enter your 12-digit MSISDN',
                      //labelText: 'Your MSISDN',
                    ),
                    onSaved: (String value) {},
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 14),
                    maxLength: 12,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return MyGlobalVariables.fieldReq;
                      }
                      return null;
                    }),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          //subscript message
          Row(children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Text(
                ' *Includes transaction fees.',
                style: TextStyle(fontSize: 10),
              ),
            )
          ]),
          SizedBox(
            height: 20,
          ),
          (!_isPurchased)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Purchase button
                    new RaisedButton(
                        elevation: 5,
                        color: Colors.grey.shade100,
                        textColor: kTextPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: kDefaultPrimaryColor,
                            width: 3,
                          ),
                        ),
                        child: new Text(
                          'Purchase',
                          style: TextStyle(
                            fontSize: kSubmitButtonFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BaiJamJuree',
                            color: kTextPrimaryColor,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _confirmPurchaseDialog(context);
                          }
                        }),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Purchase in progress...",
                      style: TextStyle(
                        color: Colors.amber.shade700,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
        ],
      ),
    );
    return formWidget;
  }
}
