import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
//import 'package:onekwacha/screens/scanpay/scan_pay_screen.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/models/userModel.dart';

class HistoryScreen extends StatefulWidget {
  final int incomingData;
  final double walletBalance;

  HistoryScreen({
    Key key,
    @required this.incomingData,
    this.walletBalance,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  //final _formKey = GlobalKey<FormState>();
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  UserModel userModel = new UserModel();
  String _transactionMonthYear, _transactionTime, _currencyAmount;
  double _currentBalance = 0;
  int _transactionDay = 0;
  String _currentUserLoginID;
  String _userFirstName;

  double _transactionAmount = 0;

  @override
  void initState() {
    super.initState();
    listenToBalanceUpdates();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  listenToBalanceUpdates() {
    _currentUserLoginID = getKeyValues.getCurrentUserLoginID();

    FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUserLoginID)
        .snapshots()
        .listen((DocumentSnapshot userSnapshot) {
      if (this.mounted) {
        setState(() {
          _currentBalance = double.parse(userSnapshot['CurrentBalance']);
          _userFirstName = userSnapshot['FirstName'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _getHistoryWidget(),
      bottomNavigationBar: BottomNavigation(
        incomingData: widget.incomingData,
      ),
    );
  }

  Future<void> _transactionDetailsDialog(QueryDocumentSnapshot document) async {
    // _amount = double.parse(document['Amount']);
    // _availableBalance = _currentBalance - _amount;
    // _fee = double.parse(document['Fee']);
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
              "Transation Details",
              style: TextStyle(
                color: kDarkPrimaryColor,
              ),
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
                    style:
                        TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                  ),
                  SizedBox(
                    width: MyGlobalVariables.sizedBoxWidth,
                  ),
                  new Text(
                    document['SourceType'],
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
                    document['Source'],
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
                    document['DestinationType'],
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
                    document['Destination'],
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
                    'Amount:',
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                  ),
                  SizedBox(
                    width: MyGlobalVariables.sizedBoxWidth,
                  ),
                  new Text(
                    MyGlobalVariables.zmcurrencySymbol +
                        currencyConvertor.format(
                            double.parse(document['TransactionAmount'])) +
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
                    width: MyGlobalVariables.sizedBoxWidth,
                  ),
                  Row(
                    children: [
                      new Text(
                        MyGlobalVariables.zmcurrencySymbol +
                            currencyConvertor
                                .format(double.parse(document['Fee'])),
                        style: TextStyle(
                          fontSize: MyGlobalVariables.dialogFontSize,
                        ),
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
                    width: MyGlobalVariables.sizedBoxWidth,
                  ),
                  new Text(
                    document['TransactionType'],
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
                    'Receipt No:',
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                  ),
                  SizedBox(
                    width: MyGlobalVariables.sizedBoxWidth,
                  ),
                  new Text(
                    document.id,
                    style:
                        TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                  ),
                ],
              ),
              SizedBox(
                height: MyGlobalVariables.sizedBoxHeight,
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
              style: TextStyle(
                color: kDarkPrimaryColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          //Confirm Payment Dialog
        ],
      ),
    );
  }

  Widget _getHistoryWidget() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: kDefaultPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Wallet Balance',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      MyGlobalVariables.zmcurrencySymbol,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    (_currentBalance != null)
                        ? Text(
                            currencyConvertor.format(_currentBalance),
                            style: TextStyle(
                              fontSize: 40.0,
                            ),
                          )
                        : Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 40.0,
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Transactions")
                .orderBy('Date', descending: true)
                .where("UserID", isEqualTo: '+260987456321')
                //.where("Status", isEqualTo: 'Active')
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

                      _transactionAmount =
                          double.parse(document['TransactionAmount']);

                      _currencyAmount =
                          currencyConvertor.format(_transactionAmount);
                      _transactionDay = int.parse(
                          formatDate(DateTime.parse(document['Date']), [
                        dd,
                      ]));
                      _transactionMonthYear = formatDate(
                          DateTime.parse(document['Date']), [M, ' ', yy]);

                      _transactionTime =
                          (formatDate(DateTime.parse(document['Date']), [
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
                                _transactionDay.toString(),
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.grey.shade700,
                                  fontFamily: 'Metrophobic',
                                ),
                              ),
                              Text(
                                _transactionMonthYear.toUpperCase(),
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
                                  Icon(
                                    getKeyValues.getTransactionTypeIcons(
                                        document['TransactionType']),
                                    size: 20,
                                    color: kDarkPrimaryColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    document['TransactionType'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      //fontFamily: 'Metrophobic',
                                    ),
                                  ),
                                ],
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
                                  (document['DestinationType'] ==
                                          'Bank Account')
                                      ? Text(
                                          'Bank Account',
                                          style: TextStyle(
                                            fontSize: 13,
                                            //fontFamily: 'Metrophobic',
                                          ),
                                        )
                                      : Text(
                                          getKeyValues
                                              .formatPhoneNumberWithSpaces(
                                                  document['Destination']),
                                          style: TextStyle(
                                            fontSize: 13,
                                            //fontFamily: 'Metrophobic',
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
                              (document['TransactionType'] ==
                                      getKeyValues.getTransactionType(0))
                                  ? Row(
                                      children: [
                                        Text(
                                          _transactionTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade700,
                                            //fontFamily: 'Metrophobic',
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          getKeyValues.getPurposeIcons(
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
                                            //fontFamily: 'Metrophobic',
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
                                          _transactionTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade700,
                                            //fontFamily: 'Metrophobic',
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (document['Destination'] ==
                                          getKeyValues.getCurrentUserLoginID())
                                      ? Text(
                                          '+' +
                                              MyGlobalVariables
                                                  .zmcurrencySymbol +
                                              _currencyAmount,
                                          style: TextStyle(
                                              fontSize: 16,
                                              //fontWeight: FontWeight.bold,
                                              fontFamily: 'BaiJamJuree',
                                              color: Colors.green),
                                        )
                                      : Text(
                                          '-' +
                                              MyGlobalVariables
                                                  .zmcurrencySymbol +
                                              _currencyAmount,
                                          style: TextStyle(
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold,
                                            fontFamily: 'BaiJamJuree',
                                            color: Colors.red,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    //color: kDarkPrimaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //dense: true,
                          onTap: () {
                            _transactionDetailsDialog(document);
                          },
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ],
    );
  }
}
