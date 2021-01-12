import 'package:onekwacha/screens/Invoicing/invoices_screen.dart';
import 'package:onekwacha/screens/marketplace/marketplace_screen.dart';
//import 'package:onekwacha/screens/scanpay/scan_pay_screen.dart';
import 'package:onekwacha/screens/scanpay/qrview_screen.dart';
import 'package:onekwacha/screens/send/send_screen.dart';
import 'package:onekwacha/screens/topUp/top_up_screen.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/widgets/image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/global_strings.dart';

class HomeScreen extends StatefulWidget {
  final double walletBalance;
  HomeScreen({
    Key key,
    this.walletBalance,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double _currentBalance = 0.0;
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (widget.walletBalance.toString().isEmpty ||
        widget.walletBalance == null) {
      _currentBalance = MyGlobalVariables.currentBalance;
    } else {
      _currentBalance = _currentBalance + widget.walletBalance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Center(
          child: Column(
            children: <Widget>[
              Text(
                'OneKwacha',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Top header section
          Expanded(
            flex: 2,
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
                      Text(
                        currencyConvertor.format(_currentBalance),
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //First section buttons
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Top up button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () {
                        //print('Top up page');
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: TopUpScreen(
                                  incomingData: _selectedIndex,
                                  currentBalance: _currentBalance,
                                )));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.plus,
                              color: kDefaultPrimaryColor,
                              size: 35.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Top up',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //Scan & Pay button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: QRViewScreen()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.qr_code,
                              color: kDefaultPrimaryColor,
                              size: 45.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Scan & Pay',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //Send button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SendScreen(
                              incomingData: _selectedIndex,
                              currentBalance: _currentBalance,
                            ),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.initiate_money_transfer,
                              color: kDefaultPrimaryColor,
                              size: 35.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Second section buttons
          //HomeSecondSection(selectedIndex: _selectedIndex),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: InvoicingScreen(
                              incomingData: _selectedIndex,
                              currentBalance: _currentBalance,
                            ),
                          ),
                        );
                      },
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.bill,
                              color: kDefaultPrimaryColor,
                              size: 45.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Invoicing',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketplaceScreen(
                                  incomingData: _selectedIndex)),
                        );
                      },
                      elevation: 5.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.shopping_cart,
                              color: kDefaultPrimaryColor,
                              size: 45.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Marketplace',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Banner of adverts
          Expanded(
            flex: 4,
            child: CarouselWithIndicatorDemo(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        incomingData: _selectedIndex,
      ),
    );
  }
}
