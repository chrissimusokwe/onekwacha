import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/invoicing/new_invoice_screen.dart';

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
  //final List list;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
    formWidget.add(
      Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Invoices").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Errored');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return ListView(
                    children: snapshot.data.docs.map((document) {
                      return ListTile(
                        title: Text('Amount: ' + document.data()['Amount']),
                      );
                    }).toList(),
                  );
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
    formWidget.add(Text('Receievable'));

    return formWidget;
  }
}
