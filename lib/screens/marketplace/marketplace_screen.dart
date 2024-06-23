import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:onekwacha/screens/marketplace/litespeed/lite_speed_products_list_screen.dart';
import 'package:page_transition/page_transition.dart';

class MarketplaceScreen extends StatelessWidget {
  final int incomingData;
  MarketplaceScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Marketplace',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: _getMarketplaceWidgets(),
      ),
      bottomNavigationBar: BottomNavigation(
        incomingData: 0,
      ),
    );
  }

  List<Widget> _getMarketplaceWidgets() {
    List<Widget> formWidget = new List();

    void goToMerchantProductsList(
        BuildContext context, QueryDocumentSnapshot document) {
      switch (document.id) {
        //Go to Lite Speed Merchant Products List Screen
        case 'Lite Speed':
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: LiteSpeedProductsListScreen(
                productsToken: document['Token'],
                merchantName: document.id,
                productsUrl: document['GetProducts'],
                userProductUrl: document['GetUserProduct'],
                merchantLogo: document['Logo'],
                topUpUrl: document['PostTopUp'],
              ),
            ),
          );
          break;

        //Go to Zesco Merchant Products List Screen
        case 'Zesco':
          break;

        //Go to GoTV Merchant Products List Screen
        case 'GoTV':
          break;

        //Go to DSTV Merchant Products List Screen
        case 'DSTV':
          break;

        //Go to ToKidz Merchant Products List Screen
        case 'ToKidz':
          break;

        //Go to Airtel Merchant Products List Screen
        case 'Airtel':
          break;

        //Go to MTN Merchant Products List Screen
        case 'MTN':
          break;

        //Go to Zamtel Merchant Products List Screen
        case 'Zamtel':
          break;
      }
    }

    //Product not available dialog
    void _productNotAvailableDialog(BuildContext context, String documentID) {
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
                  'Product Coming Soon',
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
                    'Thank you for your interest in ' +
                        documentID +
                        ' products.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'We are yet to go live with this product. Please check back later.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: MyGlobalVariables.dialogFontSize,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  "Dismiss",
                  style: TextStyle(color: kDarkPrimaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
      );
    }

    formWidget.add(
      SizedBox(
        height: 20,
      ),
    );
    formWidget.add(
      Text(
        'Tap active merchant to view products',
        style: TextStyle(
          fontSize: 16,
          //fontWeight: FontWeight.bold,
          //fontFamily: 'Metrophobic',
        ),
        textAlign: TextAlign.left,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20,
      ),
    );
    //List of merchants
    formWidget.add(
      Expanded(
        flex: 1,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("Marketplace").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connection errored. Please try again later.',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
              );
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading Merchant List...',
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
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot document =
                          snapshot.data.docs[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: ListTile(
                          //TODO: Consider pulling logos from merchant websites
                          leading: Image.asset(
                            'assets/marketplace/' + document['Logo'],
                            width: 100,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                document['Category'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kDarkPrimaryColor,
                                  //fontFamily: 'Metrophobic',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                document.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Metrophobic',
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              (document['Status'] == 'Active')
                                  ? Row(
                                      children: [
                                        Text(
                                          'Active',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.green,
                                            //fontFamily: 'Metrophobic',
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          'Coming Soon',
                                          style: TextStyle(
                                            fontSize: 11,
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
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            if (document['Status'] == 'Active') {
                              goToMerchantProductsList(context, document);
                            } else {
                              _productNotAvailableDialog(context, document.id);
                            }
                          },
                        ),
                      );
                    });
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No data available',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ));
              }
            }
          },
        ),
      ),
    );
    return formWidget;
  }
}
