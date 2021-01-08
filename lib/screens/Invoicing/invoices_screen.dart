import 'package:flutter/material.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';
import 'package:onekwacha/screens/common/error_screen.dart';
import 'package:onekwacha/screens/invoicing/receivable_screen.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/invoicing/create_invoice_screen.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  String _monthyear;
  int _day = 0;
  double _amount = 0;
  String _currencyAmount;
  int _transactionType = 2;
  int _selectedFundDestination = 0;
  double _balance = 0;

  @override
  void initState() {
    super.initState();
    //widget.selectedTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
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

    void onPressedPayable(QueryDocumentSnapshot document) {
      //_amount = double.parse(document['Amount']);
      _balance = GetKeyValues.currentBalance - _amount;
      print(_amount.toString());
      //Destination OneKwacha Wallet
      if (_balance < 0) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: ErrorScreen(
              from: GetKeyValues.onekwachaWalletNumber,
              to: document['ReceivableUserID'],
              destinationPlatform: GetKeyValues.getFundDestinationValue(
                  _selectedFundDestination),
              purpose: document['Purpose'],
              errorMessage: MyGlobalVariables.errorInssufficientBalance,
              amount: _amount,
              currentBalance: widget.currentBalance,
              transactionType:
                  GetKeyValues.getTransactionTypeValue(_transactionType),
              document: document,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: ConfirmationScreen(
              from: GetKeyValues.onekwachaWalletNumber,
              to: document['ReceivableUserID'],
              destinationPlatform: GetKeyValues.getFundDestinationValue(
                  _selectedFundDestination),
              purpose: document['Purpose'],
              amount: _amount,
              currentBalance: _balance,
              transactionType:
                  GetKeyValues.getTransactionTypeValue(_transactionType),
              document: document,
            ),
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
                      isEqualTo: GetKeyValues.onekwachaWalletNumber)
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

                        _amount = double.parse(document['Amount']);

                        _currencyAmount = currencyConvertor.format(_amount);
                        _day = int.parse(formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          dd,
                        ]));
                        _monthyear = formatDate(
                            DateTime.parse(document['InvoiceDate']),
                            [M, ' ', yy]);

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
                                  _day.toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                                Text(
                                  _monthyear.toUpperCase(),
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
                                Text(
                                  'Purpose: ' + document['Purpose'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    //fontFamily: 'BaiJamJuree',
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'K' + _currencyAmount,
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
                              onPressedPayable(document);
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
                      isEqualTo: GetKeyValues.onekwachaWalletNumber)
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

                        _amount = double.parse(document['Amount']);

                        _currencyAmount = currencyConvertor.format(_amount);
                        _day = int.parse(formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          dd,
                        ]));
                        _monthyear = formatDate(
                            DateTime.parse(document['InvoiceDate']),
                            [M, ' ', yy]);

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
                                  _day.toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Metrophobic',
                                  ),
                                ),
                                Text(
                                  _monthyear.toUpperCase(),
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
                                Text(
                                  'Purpose: ' + document['Purpose'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    //fontFamily: 'BaiJamJuree',
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'K' + _currencyAmount,
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
                                    to: GetKeyValues.onekwachaWalletNumber,
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
