import 'package:flutter/material.dart';
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
  GetKeyValues getKeyValues = new GetKeyValues();
  TransactionModel transactionModel = new TransactionModel();
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
  double _fee = 0, _previousBalance = 0;
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
    _previousBalance = _currentBalance;
    _destinationType =
        getKeyValues.getFundDestinationValue(_selectedFundDestination);
    _sourceType =
        getKeyValues.getFundDestinationValue(_selectedFundDestination);

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

    Future<void> _confirmDeletionDialog(QueryDocumentSnapshot document) async {
      _amount = double.parse(document['Amount']);
      _availableBalance = _currentBalance - _amount;
      _fee = double.parse(document['Fee']);

      return showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: kDarkPrimaryColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Invoice Details",
                style: TextStyle(color: kDarkPrimaryColor),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Text(
                      'Status:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    (document['Status'] == 'Active')
                        ? Text(
                            document['Status'],
                            style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize,
                              color: Colors.green,
                              //fontFamily: 'BaiJamJuree',
                            ),
                          )
                        : Text(
                            document['Status'],
                            style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize,
                              color: Colors.red,
                              //fontFamily: 'BaiJamJuree',
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Source:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      getKeyValues
                          .getFundDestinationValue(_selectedFundDestination),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      MyGlobalVariables.onekwachaWalletNumber,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      getKeyValues
                          .getFundDestinationValue(_selectedFundDestination),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      document['ReceivableUserID'],
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      document['Purpose'],
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
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
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: MyGlobalVariables.sizedBoxWidth,
                    ),
                    new Text(
                      MyGlobalVariables.zmcurrencySymbol +
                          currencyConvertor
                              .format(double.parse(document['Amount'])) +
                          '*',
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
                      'Fees:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        new Text(
                          MyGlobalVariables.zmcurrencySymbol +
                              currencyConvertor.format(_fee),
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Transaction:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new Text(
                      getKeyValues.getTransactionType(_transactionType),
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: MyGlobalVariables.sizedBoxHeight,
                ),
                Row(
                  children: [
                    new Text(
                      'Invoice ID:',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new Text(
                      document.id,
                      style:
                          TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Text(
                    ' *Includes transaction fees.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  )
                ]),
              ],
            ),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            //Confirm Payment Dialog
            BasicDialogAction(
              title: Text(
                "Delete",
                style: TextStyle(
                  color: kDarkPrimaryColor,
                ),
              ),
              onPressed: () async {
                InvoicingModel.deactivateInvoice(document.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    Future<void> _confirmPaymentDialog(QueryDocumentSnapshot document) async {
      _amount = double.parse(document['Amount']);
      _availableBalance = _currentBalance - _amount;
      _fee = double.parse(document['Fee']);

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
                    SizedBox(
                      height: MyGlobalVariables.sizedBoxHeight,
                    ),
                    Row(
                      children: [
                        new Text(
                          'Invoice ID:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          document.id,
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
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
            title: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: kDarkPrimaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Confirm Payment",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
              ],
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
                        getKeyValues
                            .getFundDestinationValue(_selectedFundDestination),
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
                        getKeyValues
                            .getFundDestinationValue(_selectedFundDestination),
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
                                .format(double.parse(document['Amount'])) +
                            '*',
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
                        'Fees:',
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
                                currencyConvertor.format(_fee),
                            style: TextStyle(
                                fontSize: MyGlobalVariables.dialogFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyGlobalVariables.sizedBoxHeight,
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
                        getKeyValues.getTransactionType(_transactionType),
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
                        'Invoice ID:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Text(
                        document.id,
                        style: TextStyle(
                            fontSize: MyGlobalVariables.dialogFontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Text(
                      ' *Includes transaction fees.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    )
                  ]),
                ],
              ),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Decline",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onPressed: () {
                  InvoicingModel.declineInvoice(document.id);

                  //bool _route = false;
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: InvoicingScreen(
                          incomingData: 0,
                          selectedTab: 1,
                        ),
                      ),
                      (route) => false);
                },
              ),
              BasicDialogAction(
                title: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              //Confirm Payment Dialog
              BasicDialogAction(
                title: Text(
                  "PAY",
                  style: TextStyle(
                    color: kDarkPrimaryColor,
                  ),
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
                      getKeyValues.getTransactionType(_transactionType);

                  //Create transaction
                  documentRef = await transactionModel.createTransaction(
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
                    document.id,
                  );

                  if (documentRef != null) {
                    //Pay off invoice and remove it from the Payables tab by setting Status to paid
                    _paid = await InvoicingModel.payInvoice(
                        document.id,
                        _amount.toString(),
                        _fee.toString(),
                        _purpose,
                        _source,
                        _destination,
                        _settlementDate,
                        _status);
                    if (_paid) {
                      //   //Navigate to the success screen once done
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
                              fee: _fee,
                              transactionType: _transactionType,
                              documentID: documentRef.id,
                            ),
                          ),
                          (route) => false);
                    } else {
                      _notPaidDialog();
                    }
                  } else {
                    _connectionErrorDialog();
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
                        _fee = double.parse(document['Fee']);

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
                                      getKeyValues.formatPhoneNumberWithSpaces(
                                          document['ReceivableUserID']),
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
                                      getKeyValues
                                          .getPurposeIcons(document['Purpose']),
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
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 15,
                                ),
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
                  //.orderBy('Status')
                  .orderBy('InvoiceDate', descending: true)
                  .where("ReceivableUserID",
                      isEqualTo: MyGlobalVariables.onekwachaWalletNumber)
                  .where("Status", whereIn: ['Active', 'Declined']).snapshots(),
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
                        _fee = double.parse(document['Fee']);

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

                        bool statusIsActive;

                        (document['Status'] == 'Active')
                            ? statusIsActive = true
                            : statusIsActive = false;

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
                                (statusIsActive)
                                    ? Text(
                                        document['Status'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          //fontFamily: 'BaiJamJuree',
                                        ),
                                      )
                                    : Text(
                                        document['Status'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          //fontFamily: 'BaiJamJuree',
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
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
                                      getKeyValues.formatPhoneNumberWithSpaces(
                                          document['PayableUserID']),
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
                                      getKeyValues
                                          .getPurposeIcons(document['Purpose']),
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
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: GestureDetector(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 47,
                                  ),
                                  Text(
                                    MyGlobalVariables.zmcurrencySymbol +
                                        _currencyAmount,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'BaiJamJuree',
                                    ),
                                  ),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                            //dense: true,
                            onTap: () {
                              _confirmDeletionDialog(document);
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
