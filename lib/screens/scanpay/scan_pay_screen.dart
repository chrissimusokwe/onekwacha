import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_icons.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:onekwacha/screens/scanpay/scan_qr_screen.dart';
import 'package:onekwacha/screens/scanpay/generate_qr_screen.dart';

class ScanPayScreen extends StatefulWidget {
  final int incomingData;
  ScanPayScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  _ScanPayScreenState createState() => _ScanPayScreenState();
}

class _ScanPayScreenState extends State<ScanPayScreen> {
  TextEditingController qrTextController = TextEditingController();
  String dummyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Generate QR Code',
              style: TextStyle(fontSize: kAppBarFontSize),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("Scan Code"),
              leading: Icon(CustomIcons.qr_code),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ScanPage()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Generate QR Code"),
              leading: Icon(CustomIcons.qr_code),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: QRGenerateScreen()));
              },
            ),
          ),
        ],
      ), // bottomNavigationBar: BottomNavigation(
      //   incomingData: widget.incomingData,
      // ),
    );
  }
}
