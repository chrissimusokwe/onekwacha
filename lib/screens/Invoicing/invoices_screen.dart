import 'package:flutter/material.dart';
import 'package:onekwacha/utils/get_key_values.dart';
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

  InvoicingScreen({
    Key key,
    this.incomingData,
    this.currentBalance,
  }) : super(key: key);

  @override
  _InvoicingScreenState createState() => _InvoicingScreenState();
}

class _InvoicingScreenState extends State<InvoicingScreen> {
  final _formKey = GlobalKey<FormState>();
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  String _monthyear;
  int _day = 0;

  SlidableController slidableController;

  final List<_HomeItem> items = List.generate(
    20,
    (i) => _HomeItem(
      i,
      'Tile n°$i',
      _getSubtitle(i),
      _getAvatarColor(i),
    ),
  );

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: kBackgroundShade,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Payable',
              ),
              // Tab(
              //   text: 'Receivable',
              // ),
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
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot document =
                            snapshot.data.docs[index];

                        //final Axis slidableDirection = Axis.vertical;

                        final _HomeItem item = items[index];

                        double _amount = double.parse(document['Amount']);
                        String _currencyAmount =
                            currencyConvertor.format(_amount);
                        _day = int.parse(formatDate(
                            DateTime.parse(document['InvoiceDate']), [
                          dd,
                        ]));
                        _monthyear = formatDate(
                            DateTime.parse(document['InvoiceDate']),
                            [M, ' ', yy]);
                        //final _HomeItem item = items[index];
                        //final int t = index;

                        //final _HomeItem item = items[index];

                        return Slidable.builder(
                          key: Key(item.title),
                          controller: slidableController,
                          direction: Axis.vertical,
                          dismissal: SlidableDismissal(
                            child: SlidableDrawerDismissal(),
                            closeOnCanceled: true,
                            onWillDismiss: (item.index != 10)
                                ? null
                                : (actionType) {
                                    return showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Delete'),
                                          content: Text('Item will be deleted'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                            FlatButton(
                                              child: Text('Ok'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                            // onDismissed: (actionType) {
                            //   // _showSnackBar(
                            //   //     context,
                            //   //     actionType == SlideActionType.primary
                            //   //         ? 'Dismiss Archive'
                            //   //         : 'Dimiss Delete');
                            //   setState(() {
                            //     //items.removeAt(index);
                            //   });
                            // },
                          ),
                          actionPane: _getActionPane(item.index),
                          actionExtentRatio: 0.25,
                          child: GestureDetector(
                            onTap: () {
                              if (Slidable.of(context)?.renderingMode ==
                                  SlidableRenderingMode.none) {
                                print('Slider redering mode opened');
                                Slidable.of(context)?.open();
                              } else {
                                Slidable.of(context)?.close();
                                print('Slider redering mode closed');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300),
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
                                //onTap: () {
                                // do something
                                //},
                              ),
                            ),
                          ),
                          actionDelegate: SlideActionBuilderDelegate(
                              actionCount: 2,
                              builder:
                                  (context, index, animation, renderingMode) {
                                if (index == 0) {
                                  return IconSlideAction(
                                    caption: 'Archive',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? Colors.blue
                                            .withOpacity(animation.value)
                                        : (renderingMode ==
                                                SlidableRenderingMode.dismiss
                                            ? Colors.blue
                                            : Colors.green),
                                    icon: Icons.archive,
                                    onTap: () async {
                                      var state = Slidable.of(context);
                                      var dismiss = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete'),
                                            content:
                                                Text('Item will be deleted'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                              ),
                                              FlatButton(
                                                child: Text('Ok'),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (dismiss) {
                                        state.dismiss();
                                      }
                                    },
                                  );
                                } else {
                                  return IconSlideAction(
                                    caption: 'Share',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? Colors.indigo
                                            .withOpacity(animation.value)
                                        : Colors.indigo,
                                    icon: Icons.share,
                                    onTap: () =>
                                        _showSnackBar(context, 'Share'),
                                  );
                                }
                              }),
                          secondaryActionDelegate: SlideActionBuilderDelegate(
                              actionCount: 2,
                              builder:
                                  (context, index, animation, renderingMode) {
                                if (index == 0) {
                                  return IconSlideAction(
                                    caption: 'More',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? Colors.grey.shade200
                                            .withOpacity(animation.value)
                                        : Colors.grey.shade200,
                                    icon: Icons.more_horiz,
                                    onTap: () => _showSnackBar(context, 'More'),
                                    closeOnTap: false,
                                  );
                                } else {
                                  return IconSlideAction(
                                    caption: 'Delete',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? Colors.red
                                            .withOpacity(animation.value)
                                        : Colors.red,
                                    icon: Icons.delete,
                                    onTap: () =>
                                        _showSnackBar(context, 'Delete'),
                                  );
                                }
                              }),
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
    // formWidget.add(
    //   Column(
    //     children: [
    //       Expanded(
    //         child: StreamBuilder(
    //           stream: FirebaseFirestore.instance
    //               .collection("Invoices")
    //               .orderBy('InvoiceDate', descending: true)
    //               .where("ReceivableUserID",
    //                   isEqualTo: GetKeyValues.onekwachaWalletNumber)
    //               .where("Status", isEqualTo: 'Active')
    //               .snapshots(),
    //           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //             if (snapshot.hasError) return Text('Errored');
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return CircularProgressIndicator();
    //             } else {
    //               return ListView(
    //                 children: snapshot.data.docs.map((document) {
    //                   double _amount = double.parse(document.data()['Amount']);
    //                   String _currencyAmount =
    //                       currencyConvertor.format(_amount);
    //                   // String _date = formatDate(
    //                   //     DateTime.parse(document.data()['InvoiceDate']),
    //                   //     [dd, ' ', M, ' ', yyyy, ' - ', hh, ':', nn, ' ', am]);
    //                   // String _year = formatDate(
    //                   //     DateTime.parse(document.data()['InvoiceDate']), [
    //                   //   yyyy,
    //                   // ]);
    //                   _day = int.parse(formatDate(
    //                       DateTime.parse(document.data()['InvoiceDate']), [
    //                     dd,
    //                   ]));
    //                   _monthyear = formatDate(
    //                       DateTime.parse(document.data()['InvoiceDate']),
    //                       [M, ' ', yy]);

    //                   return Container(
    //                     decoration: BoxDecoration(
    //                       //                    <-- BoxDecoration
    //                       border: Border(
    //                         bottom: BorderSide(color: Colors.grey.shade300),
    //                       ),
    //                     ),
    //                     child: ListTile(
    //                       leading: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Text(
    //                             _day.toString(),
    //                             style: TextStyle(
    //                               fontSize: 23,
    //                               color: Colors.grey.shade700,
    //                               fontFamily: 'Metrophobic',
    //                             ),
    //                           ),
    //                           Text(
    //                             _monthyear.toUpperCase(),
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
    //                               Text(
    //                                 'From: ',
    //                                 style: TextStyle(
    //                                   fontSize: 10,
    //                                   color: Colors.grey.shade700,
    //                                   //fontFamily: 'BaiJamJuree',
    //                                 ),
    //                               ),
    //                               Text(
    //                                 document.data()['PayableUserID'],
    //                                 style: TextStyle(
    //                                   fontSize: 15,
    //                                   //fontFamily: 'BaiJamJuree',
    //                                 ),
    //                               ),
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
    //                           Text(
    //                             'Purpose: ' + document.data()['Purpose'],
    //                             style: TextStyle(
    //                               fontSize: 10,
    //                               color: Colors.grey.shade700,
    //                               //fontFamily: 'BaiJamJuree',
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       trailing: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Text(
    //                             'K' + _currencyAmount,
    //                             style: TextStyle(
    //                               fontSize: 15,
    //                               fontWeight: FontWeight.bold,
    //                               fontFamily: 'BaiJamJuree',
    //                             ),
    //                           ),
    //                           // SizedBox(
    //                           //   width: 5,
    //                           // ),
    //                           Icon(Icons.keyboard_arrow_right),
    //                         ],
    //                       ),
    //                       //dense: true,
    //                       onTap: () {
    //                         // do something
    //                       },
    //                     ),
    //                   );
    //                 }).toList(),
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //       RaisedButton(
    //           color: kDefaultPrimaryColor,
    //           textColor: kTextPrimaryColor,
    //           padding:
    //               const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
    //           child: new Text(
    //             'Create Invoice',
    //             style: TextStyle(
    //               fontSize: kSubmitButtonFontSize,
    //               fontWeight: FontWeight.bold,
    //               fontFamily: 'BaiJamJuree',
    //             ),
    //           ),
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               PageTransition(
    //                 type: PageTransitionType.rightToLeft,
    //                 child: NewInvoiceScreen(),
    //               ),
    //             );
    //           }),
    //       SizedBox(
    //         height: 10,
    //       ),
    //     ],
    //   ),
    // );

    return formWidget;
  }

  // Widget _getSlidableWithLists(
  //     BuildContext context, int index, Axis direction) {
  //   final _HomeItem item = items[index];
  //   //final int t = index;
  //   return Slidable(
  //     key: Key(item.title),
  //     controller: slidableController,
  //     direction: direction,
  //     dismissal: SlidableDismissal(
  //       child: SlidableDrawerDismissal(),
  //       onDismissed: (actionType) {
  //         _showSnackBar(
  //             context,
  //             actionType == SlideActionType.primary
  //                 ? 'Dismiss Archive'
  //                 : 'Dimiss Delete');
  //         setState(() {
  //           items.removeAt(index);
  //         });
  //       },
  //     ),
  //     actionPane: _getActionPane(item.index),
  //     actionExtentRatio: 0.25,
  //     child: direction == Axis.horizontal
  //         ? VerticalListItem(items[index])
  //         : HorizontalListItem(items[index]),
  //     actions: <Widget>[
  //       IconSlideAction(
  //         caption: 'Archive',
  //         color: Colors.blue,
  //         icon: Icons.archive,
  //         onTap: () => _showSnackBar(context, 'Archive'),
  //       ),
  //       IconSlideAction(
  //         caption: 'Share',
  //         color: Colors.indigo,
  //         icon: Icons.share,
  //         onTap: () => _showSnackBar(context, 'Share'),
  //       ),
  //     ],
  //     secondaryActions: <Widget>[
  //       Container(
  //         height: 800,
  //         color: Colors.green,
  //         child: Text('a'),
  //       ),
  //       IconSlideAction(
  //         caption: 'More',
  //         color: Colors.grey.shade200,
  //         icon: Icons.more_horiz,
  //         onTap: () => _showSnackBar(context, 'More'),
  //         closeOnTap: false,
  //       ),
  //       IconSlideAction(
  //         caption: 'Delete',
  //         color: Colors.red,
  //         icon: Icons.delete,
  //         onTap: () => _showSnackBar(context, 'Delete'),
  //       ),
  //     ],
  //   );
  // }

  // Widget _getSlidableWithDelegates(
  //     BuildContext context, int index, Axis direction) {
  //   final _HomeItem item = items[index];

  //   return Slidable.builder(
  //     key: Key(item.title),
  //     controller: slidableController,
  //     direction: direction,
  //     dismissal: SlidableDismissal(
  //       child: SlidableDrawerDismissal(),
  //       closeOnCanceled: true,
  //       onWillDismiss: (item.index != 10)
  //           ? null
  //           : (actionType) {
  //               return showDialog<bool>(
  //                 context: context,
  //                 builder: (context) {
  //                   return AlertDialog(
  //                     title: Text('Delete'),
  //                     content: Text('Item will be deleted'),
  //                     actions: <Widget>[
  //                       FlatButton(
  //                         child: Text('Cancel'),
  //                         onPressed: () => Navigator.of(context).pop(false),
  //                       ),
  //                       FlatButton(
  //                         child: Text('Ok'),
  //                         onPressed: () => Navigator.of(context).pop(true),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               );
  //             },
  //       onDismissed: (actionType) {
  //         _showSnackBar(
  //             context,
  //             actionType == SlideActionType.primary
  //                 ? 'Dismiss Archive'
  //                 : 'Dimiss Delete');
  //         setState(() {
  //           items.removeAt(index);
  //         });
  //       },
  //     ),
  //     actionPane: _getActionPane(item.index),
  //     actionExtentRatio: 0.25,
  //     child: direction == Axis.horizontal
  //         ? VerticalListItem(items[index])
  //         : HorizontalListItem(items[index]),
  //     actionDelegate: SlideActionBuilderDelegate(
  //         actionCount: 2,
  //         builder: (context, index, animation, renderingMode) {
  //           if (index == 0) {
  //             return IconSlideAction(
  //               caption: 'Archive',
  //               color: renderingMode == SlidableRenderingMode.slide
  //                   ? Colors.blue.withOpacity(animation.value)
  //                   : (renderingMode == SlidableRenderingMode.dismiss
  //                       ? Colors.blue
  //                       : Colors.green),
  //               icon: Icons.archive,
  //               onTap: () async {
  //                 var state = Slidable.of(context);
  //                 var dismiss = await showDialog<bool>(
  //                   context: context,
  //                   builder: (context) {
  //                     return AlertDialog(
  //                       title: Text('Delete'),
  //                       content: Text('Item will be deleted'),
  //                       actions: <Widget>[
  //                         FlatButton(
  //                           child: Text('Cancel'),
  //                           onPressed: () => Navigator.of(context).pop(false),
  //                         ),
  //                         FlatButton(
  //                           child: Text('Ok'),
  //                           onPressed: () => Navigator.of(context).pop(true),
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 );

  //                 if (dismiss) {
  //                   state.dismiss();
  //                 }
  //               },
  //             );
  //           } else {
  //             return IconSlideAction(
  //               caption: 'Share',
  //               color: renderingMode == SlidableRenderingMode.slide
  //                   ? Colors.indigo.withOpacity(animation.value)
  //                   : Colors.indigo,
  //               icon: Icons.share,
  //               onTap: () => _showSnackBar(context, 'Share'),
  //             );
  //           }
  //         }),
  //     secondaryActionDelegate: SlideActionBuilderDelegate(
  //         actionCount: 2,
  //         builder: (context, index, animation, renderingMode) {
  //           if (index == 0) {
  //             return IconSlideAction(
  //               caption: 'More',
  //               color: renderingMode == SlidableRenderingMode.slide
  //                   ? Colors.grey.shade200.withOpacity(animation.value)
  //                   : Colors.grey.shade200,
  //               icon: Icons.more_horiz,
  //               onTap: () => _showSnackBar(context, 'More'),
  //               closeOnTap: false,
  //             );
  //           } else {
  //             return IconSlideAction(
  //               caption: 'Delete',
  //               color: renderingMode == SlidableRenderingMode.slide
  //                   ? Colors.red.withOpacity(animation.value)
  //                   : Colors.red,
  //               icon: Icons.delete,
  //               onTap: () => _showSnackBar(context, 'Delete'),
  //             );
  //           }
  //         }),
  //   );
  // }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  static Color _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  static String _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindActionPane';
      case 1:
        return 'SlidableStrechActionPane';
      case 2:
        return 'SlidableScrollActionPane';
      case 3:
        return 'SlidableDrawerActionPane';
      default:
        return null;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final _HomeItem item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CircleAvatar(
              backgroundColor: item.color,
              child: Text('${item.index}'),
              foregroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                item.subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final _HomeItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: item.color,
            child: Text('${item.index}'),
            foregroundColor: Colors.white,
          ),
          title: Text(item.title),
          subtitle: Text(item.subtitle),
        ),
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(
    this.index,
    this.title,
    this.subtitle,
    this.color,
  );

  final int index;
  final String title;
  final String subtitle;
  final Color color;
}
