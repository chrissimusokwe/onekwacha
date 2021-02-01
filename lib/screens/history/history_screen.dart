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
import 'package:flutter/services.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:onekwacha/utils/custom_icons.dart';

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
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  GetKeyValues getKeyValues = new GetKeyValues();
  UserModel userModel = new UserModel();
  String _transactionMonthYear,
      _transactionTime,
      _currencyAmount,
      _destination,
      _source,
      _grouping,
      _today,
      _yesterday,
      _purchasedProductCode;
  int _transactionDay = 0;
  DateTime _now;

  double _transactionAmount = 0;
  //List _bankDetails = [];

  // getList() async {
  //   _elements = [];
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(getKeyValues.getCurrentUserLoginID())
  //       .collection('Transactions')
  //       .orderBy('Date', descending: true)
  //       .get()
  //       .then((documents) {
  //     for (QueryDocumentSnapshot document in documents.docs) {
  //       _elements.add(document);
  //     }
  //   });

  //   return _elements;
  // }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //getList();
  }

  @override
  Widget build(BuildContext context) {
    _now = DateTime.now();
    _today = formatDate(DateTime.now(), [
      yyyy,
      ' ',
      mm,
      ' ',
      dd,
    ]);
    _yesterday = formatDate(DateTime(_now.year, _now.month, _now.day - 1), [
      yyyy,
      ' ',
      mm,
      ' ',
      dd,
    ]);
    return Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        // bottom: TabBar(
        //   tabs: [
        //     Tab(
        //       text: 'Incoming',
        //     ),
        //     Tab(
        //       text: 'Outgoing',
        //     ),
        //   ],
        // ),
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
      body: Column(
        children: [
          getGroupedList(),
        ],
      ),

      // Column(
      //   children: _getHistoryWidget(),
      // ),
      bottomNavigationBar: BottomNavigation(
        incomingData: widget.incomingData,
      ),
    );
  }

  Future<void> _transactionDetailsDialog(QueryDocumentSnapshot document) async {
    //Format product code
    try {
      _purchasedProductCode =
          document['PurchasedProductCode'].replaceAll('_', ' ');
    } catch (e) {
      _purchasedProductCode = 'None';
    }
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
              (document['DestinationType'] == 'Bank Account')
                  ? Column(
                      children: [
                        Row(
                          children: [
                            new Text(
                              'Name:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                            SizedBox(
                              width: MyGlobalVariables.sizedBoxWidth,
                            ),
                            new Text(
                              document['BankAccountName'],
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
                              'Bank:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                            SizedBox(
                              width: MyGlobalVariables.sizedBoxWidth,
                            ),
                            new Text(
                              getKeyValues.formatBankDetails(
                                  document['Destination'], 0),
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
                              'Branch Code:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                            SizedBox(
                              width: MyGlobalVariables.sizedBoxWidth,
                            ),
                            new Text(
                              getKeyValues.formatBankDetails(
                                  document['Destination'], 1),
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
                              'Account #:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                            SizedBox(
                              width: MyGlobalVariables.sizedBoxWidth,
                            ),
                            new Text(
                              getKeyValues.formatBankDetails(
                                  document['Destination'], 2),
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
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
                          document['Destination'],
                          style: TextStyle(
                              fontSize: MyGlobalVariables.dialogFontSize),
                        ),
                      ],
                    ),
              SizedBox(
                height: MyGlobalVariables.sizedBoxHeight,
              ),
              (_purchasedProductCode != 'None')
                  ? Column(
                      children: [
                        Row(
                          children: [
                            new Text(
                              'Product:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                            SizedBox(
                              width: MyGlobalVariables.sizedBoxWidth,
                            ),
                            new Text(
                              _purchasedProductCode.replaceAll('_', ' '),
                              style: TextStyle(
                                  fontSize: MyGlobalVariables.dialogFontSize),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MyGlobalVariables.sizedBoxHeight,
                        ),
                      ],
                    )
                  : Container(),
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
                    'Receipt:',
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

  Widget getGroupedList() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(getKeyValues.getCurrentUserLoginID())
            .collection('Transactions')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Connection errored. Please try again later.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Loading Transaction List...',
                  style: TextStyle(
                    color: Colors.amber.shade700,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
              ],
            ));
          } else {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 40,
                      color: Colors.amber.shade700,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No transactions available yet',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return GroupedListView<dynamic, String>(
                elements: snapshot.data.docs,
                groupBy: (element) {
                  _grouping = formatDate(DateTime.parse(element['Date']), [
                    yyyy,
                    ' ',
                    mm,
                    ' ',
                    dd,
                  ]);
                  return _grouping;
                },
                groupComparator: (value1, value2) => value2.compareTo(value1),
                // itemComparator: (element1, element2) =>
                //     element1['Date'].compareTo(element2['Date']),
                //order: GroupedListOrder.ASC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String _groupingLabel) => Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: (_today.toLowerCase() == _grouping.toLowerCase())
                      ? Text(
                          'Today',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : (_yesterday.toLowerCase() == _grouping.toLowerCase())
                          ? Text(
                              'Yesterday',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              getKeyValues.formatGrouping(_groupingLabel),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
                itemBuilder: (c, document) {
                  // QueryDocumentSnapshot document =
                  //     snapshot.data.docs[index];

                  _transactionAmount =
                      double.parse(document['TransactionAmount']);

                  _currencyAmount =
                      currencyConvertor.format(_transactionAmount);
                  _transactionDay =
                      int.parse(formatDate(DateTime.parse(document['Date']), [
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

                  //Format destination
                  try {
                    _destination = getKeyValues
                        .formatPhoneNumberWithSpaces(document['Destination']);
                  } catch (e) {
                    _destination = document['Destination'];
                  }

                  //Format destination
                  try {
                    _source = getKeyValues
                        .formatPhoneNumberWithSpaces(document['Source']);
                  } catch (e) {
                    _source = document['Source'];
                  }

                  //Format product code
                  try {
                    _purchasedProductCode =
                        document['PurchasedProductCode'].replaceAll('_', ' ');
                  } catch (e) {
                    _purchasedProductCode = 'None';
                  }

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
                          Icon(
                            getKeyValues.getTransactionTypeIcons(
                                document['TransactionType']),
                            size: 35,
                            color: kDarkPrimaryColor,
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
                              (document['DestinationType'] == 'Bank Account')
                                  ? Text(
                                      'To Bank Account',
                                      style: TextStyle(
                                        fontSize: 13,
                                        //fontFamily: 'Metrophobic',
                                      ),
                                    )
                                  : (_purchasedProductCode != 'None' ||
                                          _purchasedProductCode == null)
                                      ? Row(
                                          children: [
                                            Text(
                                              _destination,
                                              style: TextStyle(
                                                fontSize: 13,
                                                //fontFamily: 'Metrophobic',
                                              ),
                                            ),
                                            Text(
                                              ' - ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                //color: Colors.grey.shade700,
                                              ),
                                            ),
                                            Text(
                                              _purchasedProductCode,
                                              style: TextStyle(
                                                fontSize: 13,
                                                //color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        )
                                      : (document['TransactionType'] ==
                                              'Top up')
                                          ? (document['SourceType'] ==
                                                  'Mobile Money')
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      'From Mobile Money',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        //fontFamily: 'Metrophobic',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Icon(
                                                      CustomIcons.credit_card,
                                                      size: 15,
                                                      color: kDarkPrimaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'From Card',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        //fontFamily: 'Metrophobic',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                          : Text(
                                              'To ' + _destination,
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
                              ? (_source == 'Card')
                                  ? Container()
                                  : Row(
                                      children: [
                                        Icon(
                                          CustomIcons.money,
                                          size: 15,
                                          color: kDarkPrimaryColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _source,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (document['Destination'] ==
                                      getKeyValues.getCurrentUserLoginID())
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '+' +
                                              MyGlobalVariables
                                                  .zmcurrencySymbol +
                                              _currencyAmount,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'BaiJamJuree',
                                              color: Colors.green),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _transactionTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                            //fontFamily: 'Metrophobic',
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '-' +
                                              MyGlobalVariables
                                                  .zmcurrencySymbol +
                                              _currencyAmount,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'BaiJamJuree',
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
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
                },
              );
            }
          }
        },
      ),
    );
  }

  // List<Widget> _getHistoryWidget() {
  //   List<Widget> formWidget = new List();
  //   formWidget.add(
  //     Expanded(
  //       child: StreamBuilder(
  //         stream: FirebaseFirestore.instance
  //             .collection("Users")
  //             .doc(getKeyValues.getCurrentUserLoginID())
  //             .collection('Transactions')
  //             .orderBy('Date', descending: true)
  //             .snapshots(),
  //         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (snapshot.hasError) {
  //             return Center(
  //                 child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(
  //                   Icons.error_outline_rounded,
  //                   size: 40,
  //                   color: Colors.red,
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Text(
  //                   'Connection errored. Please try again later.',
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                   ),
  //                 ),
  //               ],
  //             ));
  //           }
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(
  //                 child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Loading Transaction List...',
  //                   style: TextStyle(
  //                     color: Colors.amber.shade700,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 CircularProgressIndicator(),
  //               ],
  //             ));
  //           } else {
  //             if (snapshot.data.docs.length == 0) {
  //               return Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.error_outline_rounded,
  //                       size: 40,
  //                       color: Colors.amber.shade700,
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Text(
  //                       'No transactions available yet',
  //                       style: TextStyle(
  //                         color: Colors.amber.shade700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             } else {
  //               return ListView.builder(
  //                 scrollDirection: Axis.vertical,
  //                 itemCount: snapshot.data.docs.length,
  //                 itemBuilder: (context, index) {
  //                   QueryDocumentSnapshot document = snapshot.data.docs[index];

  //                   _transactionAmount =
  //                       double.parse(document['TransactionAmount']);

  //                   _currencyAmount =
  //                       currencyConvertor.format(_transactionAmount);
  //                   _transactionDay =
  //                       int.parse(formatDate(DateTime.parse(document['Date']), [
  //                     dd,
  //                   ]));
  //                   _transactionMonthYear = formatDate(
  //                       DateTime.parse(document['Date']), [M, ' ', yy]);

  //                   _transactionTime =
  //                       (formatDate(DateTime.parse(document['Date']), [
  //                     hh,
  //                     ':',
  //                     nn,
  //                     ' ',
  //                     am,
  //                   ]));

  //                   //Format destination
  //                   try {
  //                     _destination = getKeyValues
  //                         .formatPhoneNumberWithSpaces(document['Destination']);
  //                   } catch (e) {
  //                     _destination = document['Destination'];
  //                   }

  //                   //Format product code
  //                   try {
  //                     _purchasedProductCode =
  //                         document['PurchasedProductCode'].replaceAll('_', ' ');
  //                   } catch (e) {
  //                     _purchasedProductCode = 'None';
  //                   }

  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                         bottom: BorderSide(color: Colors.grey.shade300),
  //                       ),
  //                     ),
  //                     child: ListTile(
  //                       leading: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             _transactionDay.toString(),
  //                             style: TextStyle(
  //                               fontSize: 23,
  //                               color: Colors.grey.shade700,
  //                               fontFamily: 'Metrophobic',
  //                             ),
  //                           ),
  //                           Text(
  //                             _transactionMonthYear.toUpperCase(),
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: Colors.grey.shade700,
  //                               fontFamily: 'Metrophobic',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       title: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Row(
  //                             children: [
  //                               Icon(
  //                                 getKeyValues.getTransactionTypeIcons(
  //                                     document['TransactionType']),
  //                                 size: 20,
  //                                 color: kDarkPrimaryColor,
  //                               ),
  //                               SizedBox(
  //                                 width: 5,
  //                               ),
  //                               Text(
  //                                 document['TransactionType'],
  //                                 style: TextStyle(
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.grey.shade800,
  //                                   //fontFamily: 'Metrophobic',
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'To: ',
  //                                 style: TextStyle(
  //                                   fontSize: 10,
  //                                   color: Colors.grey.shade700,
  //                                   //fontFamily: 'BaiJamJuree',
  //                                 ),
  //                               ),
  //                               (document['DestinationType'] == 'Bank Account')
  //                                   ? Text(
  //                                       'Bank Account',
  //                                       style: TextStyle(
  //                                         fontSize: 13,
  //                                         //fontFamily: 'Metrophobic',
  //                                       ),
  //                                     )
  //                                   : (_purchasedProductCode != 'None' ||
  //                                           _purchasedProductCode == null)
  //                                       ? Row(
  //                                           children: [
  //                                             Text(
  //                                               _destination,
  //                                               style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 //fontFamily: 'Metrophobic',
  //                                               ),
  //                                             ),
  //                                             Text(
  //                                               _purchasedProductCode,
  //                                               style: TextStyle(
  //                                                 fontSize: 10,
  //                                                 color: Colors.grey.shade700,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         )
  //                                       : Text(
  //                                           _destination,
  //                                           style: TextStyle(
  //                                             fontSize: 13,
  //                                             //fontFamily: 'Metrophobic',
  //                                           ),
  //                                         ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       subtitle: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           (document['TransactionType'] ==
  //                                   getKeyValues.getTransactionType(0))
  //                               ? Row(
  //                                   children: [
  //                                     Text(
  //                                       _transactionTime,
  //                                       style: TextStyle(
  //                                         fontSize: 10,
  //                                         color: Colors.grey.shade700,
  //                                         //fontFamily: 'Metrophobic',
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               : Row(
  //                                   children: [
  //                                     Icon(
  //                                       getKeyValues.getPurposeIcons(
  //                                           document['Purpose']),
  //                                       size: 15,
  //                                       color: kDarkPrimaryColor,
  //                                     ),
  //                                     SizedBox(
  //                                       width: 5,
  //                                     ),
  //                                     Text(
  //                                       document['Purpose'],
  //                                       style: TextStyle(
  //                                         fontSize: 10,
  //                                         color: Colors.grey.shade700,
  //                                         //fontFamily: 'Metrophobic',
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 5,
  //                                     ),
  //                                     Text('|'),
  //                                     SizedBox(
  //                                       width: 5,
  //                                     ),
  //                                     Text(
  //                                       _transactionTime,
  //                                       style: TextStyle(
  //                                         fontSize: 10,
  //                                         color: Colors.grey.shade700,
  //                                         //fontFamily: 'Metrophobic',
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                         ],
  //                       ),
  //                       trailing: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           // SizedBox(
  //                           //   height: 10,
  //                           // ),
  //                           Row(
  //                             mainAxisSize: MainAxisSize.min,
  //                             //crossAxisAlignment: CrossAxisAlignment.center,
  //                             //mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               (document['Destination'] ==
  //                                       getKeyValues.getCurrentUserLoginID())
  //                                   ? Text(
  //                                       '+' +
  //                                           MyGlobalVariables.zmcurrencySymbol +
  //                                           _currencyAmount,
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           //fontWeight: FontWeight.bold,
  //                                           fontFamily: 'BaiJamJuree',
  //                                           color: Colors.green),
  //                                     )
  //                                   : Text(
  //                                       '-' +
  //                                           MyGlobalVariables.zmcurrencySymbol +
  //                                           _currencyAmount,
  //                                       style: TextStyle(
  //                                         fontSize: 16,
  //                                         //fontWeight: FontWeight.bold,
  //                                         fontFamily: 'BaiJamJuree',
  //                                         color: Colors.red,
  //                                       ),
  //                                     ),
  //                               SizedBox(
  //                                 width: 5,
  //                               ),
  //                               Icon(
  //                                 Icons.info_outline_rounded,
  //                                 //color: kDarkPrimaryColor,
  //                                 size: 20,
  //                               ),
  //                               SizedBox(
  //                                 width: 10,
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       //dense: true,
  //                       onTap: () {
  //                         _transactionDetailsDialog(document);
  //                       },
  //                     ),
  //                   );
  //                 },
  //               );
  //             }
  //           }
  //         },
  //       ),
  //     ),
  //   );
  //   return formWidget;
  // }
}
