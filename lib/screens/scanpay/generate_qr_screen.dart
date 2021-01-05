import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerateScreen extends StatefulWidget {
  final int incomingData;
  QRGenerateScreen({
    Key key,
    this.incomingData,
  }) : super(key: key);

  @override
  _QRGenerateScreenState createState() => _QRGenerateScreenState();
}

class _QRGenerateScreenState extends State<QRGenerateScreen> {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.money),
                trailing: FlatButton(
                  child: Text(
                    "Generate",
                    style: TextStyle(
                      color: kTextPrimaryColor,
                    ),
                  ),
                  color: kDefaultPrimaryColor,
                  onPressed: () {
                    setState(() {
                      dummyData = qrTextController.text == ""
                          ? null
                          : qrTextController.text;
                    });
                  },
                ),
                title: TextField(
                  controller: qrTextController,
                  decoration: InputDecoration(
                    hintText: "Enter amount to receive",
                  ),
                ),
              ),
            ),
          ),
          (dummyData == null)
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Text('Present below QR Code'),
                      SizedBox(
                        height: 10,
                      ),
                      QrImage(
                        // embeddedImage: NetworkImage(
                        //   "https://avatars1.githubusercontent.com/u/41328571?s=280&v=4",
                        // ),
                        data: dummyData,
                        gapless: true,
                      ),
                    ],
                  ),
                ),
        ],
      ),
      // bottomNavigationBar: BottomNavigation(
      //   incomingData: widget.incomingData,
      // ),
    );
  }
}
