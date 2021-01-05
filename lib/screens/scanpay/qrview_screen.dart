import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/utils/global_strings.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController topUpAmountField = TextEditingController();
  Barcode result;
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController qrTextController = TextEditingController();
  String dummyData;
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: kBackgroundShade,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Scan QR',
                  ),
                  Tab(
                    text: 'My QR Code',
                  ),
                ],
              ),
              title: Column(
                children: <Widget>[
                  Text(
                    'Scan & Pay',
                    style: TextStyle(fontSize: kAppBarFontSize),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: getFormWidget(),
            )),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    //Scan QR Tab
    formWidget.add(
      Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
                  else
                    Text('Scan code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.toggleFlash();
                              if (_isFlashOn(flashState)) {
                                setState(() {
                                  flashState = flashOff;
                                });
                              } else {
                                setState(() {
                                  flashState = flashOn;
                                });
                              }
                            }
                          },
                          child:
                              Text(flashState, style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.flipCamera();
                              if (_isBackCamera(cameraState)) {
                                setState(() {
                                  cameraState = frontCamera;
                                });
                              } else {
                                setState(() {
                                  cameraState = backCamera;
                                });
                              }
                            }
                          },
                          child:
                              Text(cameraState, style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            controller?.pauseCamera();
                          },
                          child: Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            controller?.resumeCamera();
                          },
                          child: Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    //Generate QR Code Tab
    formWidget.add(ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            child: ListTile(
              //leading: Icon(Icons.money),
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
                    print(qrTextController.text);
                  });
                },
              ),
              title: new MoneyTextFormField(
                settings: MoneyTextFormFieldSettings(
                  controller: qrTextController,
                  validator: (value) {
                    if (double.parse(value) <
                        MyGlobalVariables.minimumTopUpAmount) {
                      return 'Minimum allowed is K${currencyConvertor.format(MyGlobalVariables.minimumTopUpAmount)}';
                    } else {
                      if (double.parse(value) >
                          MyGlobalVariables.maximumTopUpAmount) {
                        return 'Maximum allowed is K${currencyConvertor.format(MyGlobalVariables.maximumTopUpAmount)}';
                      }
                      return value;
                    }
                  },
                  moneyFormatSettings: MoneyFormatSettings(
                    currencySymbol: 'K',
                    fractionDigits: 2,
                    displayFormat: MoneyDisplayFormat.symbolOnLeft,
                  ),
                  appearanceSettings: AppearanceSettings(
                    hintText: 'Enter amount',
                    labelText: 'Amount:',
                    labelStyle: TextStyle(
                      color: kTextPrimaryColor,
                      fontSize: 19,
                      fontFamily: 'Roboto',
                    ),
                    inputStyle: TextStyle(
                        color: kTextPrimaryColor,
                        fontSize: 18,
                        fontFamily: 'BaiJamJuree'),
                    formattedStyle: TextStyle(
                        color: kTextPrimaryColor,
                        fontSize: 18,
                        fontFamily: 'BaiJamJuree'),
                  ),
                ),
              ),
            ),
          ),
        ),
        (dummyData == null)
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 50.0),
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
    ));
    return formWidget;
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 300 ||
            MediaQuery.of(context).size.height < 300)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (notification) {
          Future.microtask(
              () => controller?.updateDimensions(qrKey, scanArea: scanArea));
          return false;
        },
        child: SizeChangedLayoutNotifier(
            key: const Key('qr-size-notifier'),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            )));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
