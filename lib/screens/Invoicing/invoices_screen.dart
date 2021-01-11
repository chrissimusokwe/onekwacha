import 'package:flutter/material.dart';
import 'package:onekwacha/screens/invoicing/receivable_screen.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/invoicing/create_invoice_screen.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:onekwacha/models/InvoicingModel.dart';
import 'package:onekwacha/screens/invoicing/invoicing_success.dart';

class InvoicingScreen extends StatefulWidget {
  final int incomingData;
  final double currentBalance;
  final int selectedTab;

  InvoicingScreen({
    Key key,
    this.incomingData,
    this.currentBalance,
    this.selectedTab,
  }) : super(key: key);

  @override
  _InvoicingScreenState createState() => _InvoicingScreenState();
}

class _InvoicingScreenState extends State<InvoicingScreen> {
  final _formKey = GlobalKey<FormState>();
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  String _invoiceMonthYear,
      _invoiceTime,
      _currencyAmount,
      _settlementDate,
      _status,
      _destination,
      _destinationType,
      _purpose,
      _source,
      _sourceType,
      _settlementTime,
      _transactionTypeName,
      _userID;
  int _invoiceDay = 0,
      _settlementDay = 0,
      _settlementMonth,
      _settlementYear,
      _transactionType = 2,
      _selectedFundDestination = 0;
  double _balance = 0,
      _fee = MyGlobalVariables.feeInvoicing,
      _previousBalance = 0;
  double _transactionAmount = 0, _currentBalance = 0, _availableBalance = 0;
  double _amount = 0;
  bool _paid = false;

  @override
  void initState() {
    super.initState();
    //widget.selectedTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    //Assignments
    _currentBalance = widget.currentBalance;

    _fee = MyGlobalVariables.feeInvoicing;
    _previousBalance = _currentBalance;
    _destinationType =
        GetKeyValues.getFundDestinationValue(_selectedFundDestination);
    _sourceType =
        GetKeyValues.getFundDestinationValue(_selectedFundDestination);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kBackgroundShade,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Payable',
              ),
              Tab(
                text: 'Receivable',
              ),
            ],
          ),
          title: Column(
            children: <Widget>[
              Text(
                'Invoicing',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: TabBarView(
            children: getInvoicesWidget(),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          incomingData: widget.incomingData,
        ),
      ),
    );
  }

  List<Widget> getInvoicesWidget() {
    List<Widget> formWidget = new List();

    // void onPressedPayable(QueryDocumentSnapshot document) {
    //   _transactionAmount = double.parse(document['Amount']);
    //   _balance = _currentBalance - _transactionAmount;
    //   print(_transactionAmount.toString());
    //   //Destination OneKwacha Wallet
    //   if (_balance < 0) {
    //     Navigator.push(
    //       context,
    //       PageTransition(
    //         type: PageTransitionType.rightToLeft,
    //         child: ErrorScreen(
    //           from: document['PayableUserID'],
    //           to: document['ReceivableUserID'],
    //           destinationPlatform: _destinationType,
    //           purpose: document['Purpose'],
    //           errorMessage: MyGlobalVariables.errorInssufficientBalance,
    //           amount: _transactionAmount,
    //           currentBalance: _currentBalance,
    //           transactionType:
    //               GetKeyValues.getTransactionTypeValue(_transactionType),
    //           document: document,
    //         ),
    //       ),
    //     );
    //   } else {
    //     Navigator.push(
    //       context,
    //       PageTransition(
    //         type: PageTransitionType.rightToLeft,
    //         child: ConfirmationScreen(
    //           from: document['PayableUserID'],
    //           to: document['ReceivableUserID'],
    //           destinationPlatform: GetKeyValues.getFundDestinationValue(
    //               _selectedFundDestination),
    //           purpose: document['Purpose'],
    //           amount: _transactionAmount,
    //           currentBalance: _balance,
    //           transactionType:
    //               GetKeyValues.getTransactionTypeValue(_transactionType),
    //           document: document,
    //         ),
    //       ),
    //     );
    //   }
    // }

    void _connectionErrorDialog() {
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

    void _notPaidDialog() {
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
              'Transaction was not processed. Please try again later',
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

    Future<void> _confirmPaymentDialog(QueryDocumentSnapshot document) async {
      _amount = double.parse(document['Amount']);
      _availableBalance = _currentBalance - _amount;

      //Check if wallet balance is enough to process required transaction amount
      if (_availableBalance < 0) {
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
                        'Insufficient wallet balance. Please top up before performing this transaction.',
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
                              currencyConvertor.format(_amount),
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
                          width: 10,
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
                    Navigator.pop(context);
                  },
                ),
              ]),
        );
      } else {
        //Enough amount in wallet for transaction to proceed
        return showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: Text(
              "Confirm Payment",
              style: TextStyle(color: kDarkPrimaryColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Row(
                    children: [
                      new Text(
                        'Source:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        GetKeyValues.getFundDestinationValue(
                            _selectedFundDestination),
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Source #:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        MyGlobalVariables.onekwachaWalletNumber,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Destination:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        GetKeyValues.getFundDestinationValue(
                            _selectedFundDestination),
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Destination #:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        document['ReceivableUserID'],
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Purpose:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        document['Purpose'],
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Transaction Amt:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: MyGlobalVariables.sizedBoxWidth,
                      ),
                      new Text(
                        MyGlobalVariables.zmcurrencySymbol +
                            currencyConvertor
                                .format(double.parse(document['Amount'])),
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
                        'Wallet Balance:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          new Text(
                            MyGlobalVariables.zmcurrencySymbol +
                                currencyConvertor.format(_availableBalance) +
                                '*',
                            style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      new Text(
                        'Transaction:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Text(
                        GetKeyValues.getTransactionTypeValue(_transactionType),
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Center(
                      child: Text(
                        ' *Balance after transaction success.',
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ]),
                ],
              ),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              //Confirm Payment Dialog
              BasicDialogAction(
                title: Text(
                  "Pay",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
                onPressed: () async {
                  DocumentReference documentRef;
                  _settlementDate = DateTime.now().toString();

                  _settlementDay =
                      int.parse(formatDate(DateTime.parse(_settlementDate), [
                    dd,
                  ]));
                  _settlementMonth =
                      int.parse(formatDate(DateTime.parse(_settlementDate), [
                    mm,
                  ]));
                  _settlementYear =
                      int.parse(formatDate(DateTime.parse(_settlementDate), [
                    yy,
                  ]));
                  print(_settlementYear);
                  _settlementTime =
                      (formatDate(DateTime.parse(_settlementDate), [
                    hh,
                    ':',
                    nn,
                    ' ',
                    am,
                  ]));

                  _destination = document['ReceivableUserID'];
                  _purpose = document['Purpose'];
                  _source = document['PayableUserID'];
                  _userID = document['PayableUserID'];
                  _status = 'Paid';
                  _transactionTypeName =
                      GetKeyValues.getTransactionTypeValue(_transactionType);

                  //Create transaction
                  documentRef = await TransactionModel.createTransaction(
                    _availableBalance,
                    _fee,
                    _previousBalance,
                    _amount,
                    _settlementDay,
                    _settlementMonth,
                    _settlementYear,
                    _transactionTypeName,
                    _destinationType,
                    _sourceType,
                    _settlementDate,
                    _destination,
                    _purpose,
                    _source,
                    _settlementTime,
                    _userID,
                  );

                  if (documentRef != null) {
                    //Pay off invoice and remove it from the Payables tab by setting Status to paid
                    _paid = await InvoicingModel.payInvoice(
                        document.id,
                        _amount,
                        _fee,
                        _purpose,
                        _source,
                        _destination,
                        _settlementDate,
                        _status);
                    if (_paid) {
                      //   //Navigate to the success screen once done
                      print('transaction amount: ' +
                          _transactionAmount.toString());
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: InvoicingSuccessScreen(
                              currentBalance: _availableBalance,
                              requestFrom: _source,
                              sendTo: _destination,
                              purpose: _purpose,
                              amount: _amount,
                              transactionType: _transactionType,
                              documentID: documentRef.id,
                            ),
                          ),
                          (route) => false);
                    } else {
                      _notPaidDialog();
                      print('Not paid dialog evoked');
                    }
                  } else {
                    _connectionErrorDialog();
                    print('Connection error dialog evoked');
                  }
                },
              ),
            ],
          ),
        );
      }
    }

    //Payables Tab
    formWidget.add(
      Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Invoices")
                  .orderBy('InvoiceDate', descending: true)
                  .where("PayableUserID",
                      isEqualTo: MyGlobalVariables.onekwachaWalletNumber)
                  .where("Status", isEqualTo: 'Active')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Errored');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot document =
                            snapshot.data.docs[index];

                        _transactionAmount = double.parse(document['Amount']);

                        _currencyAmount =
                            currencyConvertor.format(_transactionAmount);
                        _invoiceDay = int.parse(formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          dd,
                        ]));
                        _invoiceMonthYear = formatDate(
                            DateTime.parse(document['InvoiceDate']),
                            [M, ' ', yy]);

                        _invoiceTime = (formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          hh,
                          ':',
                          nn,
                          ' ',
                          am,
                        ]));

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _invoiceDay.toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                                Text(
                                  _invoiceMonthYear.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'To: ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                    Text(
                                      document['ReceivableUserID'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      GetKeyValues.getPurposeIcons(
                                          document['Purpose']),
                                      size: 15,
                                      color: kDarkPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      document['Purpose'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('|'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _invoiceTime,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  MyGlobalVariables.zmcurrencySymbol +
                                      _currencyAmount,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'BaiJamJuree',
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // GestureDetector(
                                //   child: Text(
                                //     'Pay',
                                //     style: TextStyle(
                                //       color: kDarkPrimaryColor,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.bold,
                                //       //fontFamily: 'BaiJamJuree',
                                //     ),
                                //   ),
                                // ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            //dense: true,
                            onTap: () {
                              _confirmPaymentDialog(document);
                            },
                          ),
                        );
                      });
                }
              },
            ),
          ),
          // RaisedButton(
          //     color: kDefaultPrimaryColor,
          //     textColor: kTextPrimaryColor,
          //     padding:
          //         const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
          //     child: new Text(
          //       'Create Invoice',
          //       style: TextStyle(
          //         fontSize: kSubmitButtonFontSize,
          //         fontWeight: FontWeight.bold,
          //         fontFamily: 'BaiJamJuree',
          //       ),
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         PageTransition(
          //           type: PageTransitionType.rightToLeft,
          //           child: NewInvoiceScreen(),
          //         ),
          //       );
          //     }),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );

    //Receivables Tab
    formWidget.add(
      Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Invoices")
                  .orderBy('InvoiceDate', descending: true)
                  .where("ReceivableUserID",
                      isEqualTo: MyGlobalVariables.onekwachaWalletNumber)
                  .where("Status", isEqualTo: 'Active')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Errored');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot document =
                            snapshot.data.docs[index];

                        _transactionAmount = double.parse(document['Amount']);

                        _currencyAmount =
                            currencyConvertor.format(_transactionAmount);
                        _invoiceDay = int.parse(formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          dd,
                        ]));
                        _invoiceMonthYear = formatDate(
                            DateTime.parse(document['InvoiceDate']),
                            [M, ' ', yy]);
                        _invoiceTime = (formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          hh,
                          ':',
                          nn,
                          ' ',
                          am,
                        ]));

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _invoiceDay.toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                                Text(
                                  _invoiceMonthYear.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'To: ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                    Text(
                                      document['PayableUserID'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      GetKeyValues.getPurposeIcons(
                                          document['Purpose']),
                                      size: 15,
                                      color: kDarkPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      document['Purpose'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('|'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _invoiceTime,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                        //fontFamily: 'BaiJamJuree',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  MyGlobalVariables.zmcurrencySymbol +
                                      _currencyAmount,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'BaiJamJuree',
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            //dense: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ReceivableScreen(
                                    from: document['PayableUserID'],
                                    to: MyGlobalVariables.onekwachaWalletNumber,
                                    destinationPlatform:
                                        GetKeyValues.getFundDestinationValue(
                                            _selectedFundDestination),
                                    purpose: document['Purpose'],
                                    amount: double.parse(document['Amount']),
                                    currentBalance: _balance,
                                    transactionType:
                                        GetKeyValues.getTransactionTypeValue(
                                            _transactionType),
                                    document: document,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      });
                }
              },
            ),
          ),
          RaisedButton(
              color: kDefaultPrimaryColor,
              textColor: kTextPrimaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
              child: new Text(
                'Create Invoice',
                style: TextStyle(
                  fontSize: kSubmitButtonFontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BaiJamJuree',
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: NewInvoiceScreen(),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    return formWidget;
  }
}
