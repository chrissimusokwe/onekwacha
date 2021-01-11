import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/services.dart';
//import 'package:onekwacha/utils/global_strings.dart';
import 'package:onekwacha/screens/common/confirmation_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/utils/get_key_values.dart';

const flashOn = 'Flash ON';
const flashOff = 'Flash OFF';
const frontCamera = 'Front Camera';
const backCamera = 'Back Camera';

class QRViewScreen extends StatefulWidget {
  final int incomingData;
  final double currentBalance;
  QRViewScreen({
    Key key,
    this.currentBalance,
    this.incomingData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  Barcode result;
  QRViewController controller;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

  TextEditingController qrTextController = TextEditingController();
  bool _isQRVisible = false;
  bool _isGenerateEnabled = false;
  String _decimalValueNoCommas;
  String qrDataString;
  String _destinationPhoneNumber;
  double _validDouble = 0.0;
  double _transferAmount = 0;
  int _transactionType = 1;
  int _selectedFundDestination = 0;
  int _selectedPurpose = 4;

  var flashState = flashOn;
  var cameraState = frontCamera;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

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
    GetKeyValues.loadPuporseList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShade,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Scan QR',
              ),
              Tab(
                text: 'My QR',
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
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: TabBarView(
            children: getQRFormWidget(), //getGeneratorFormWidget(),
          ),
        ),
      ),
    );
  }

  List<Widget> getQRFormWidget() {
    List<Widget> formWidget = new List();

    //Scan QR Tab
    formWidget.add(
      Column(
        children: <Widget>[
          Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)

                    //Pay button after scanning QR Code
                    Card(
                      child: ListTile(
                        title: Text(
                          'Scanned Data: ${result.code}',
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: 'BaiJamJuree',
                          ),
                        ),
                        trailing: new RaisedButton(
                          color: kDefaultPrimaryColor,
                          textColor: kTextPrimaryColor,
                          // padding:
                          //     const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                          child: new Text(
                            'Pay',
                            style: TextStyle(
                              fontSize: kSubmitButtonFontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BaiJamJuree',
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() {
                                List values = result.code.split("|");
                                // print(values[0]);
                                // print(values[1]);
                                // print(values[2]);
                                _destinationPhoneNumber = values[0];
                                _selectedPurpose = values[1];
                                _transferAmount = double.parse(values[2]);
                                if (result.code != null) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ConfirmationScreen(
                                        from: MyGlobalVariables
                                            .topUpWalletDestination,
                                        to: _destinationPhoneNumber,
                                        destinationPlatform: GetKeyValues
                                            .getFundDestinationValue(
                                                _selectedFundDestination),
                                        purpose: GetKeyValues.getPurposeValue(
                                            _selectedPurpose),
                                        amount: _transferAmount,
                                        currentBalance: widget.currentBalance,
                                        transactionType: GetKeyValues
                                            .getTransactionTypeValue(
                                                _transactionType),
                                      ),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    )
                  else
                    Text(
                      'Position QR inside square',
                      style: TextStyle(
                        fontSize: 8,
                        fontFamily: 'BaiJamJuree',
                      ),
                    ),

                  //Flash and Front/Back Camera
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          color: kDefaultPrimaryColor,
                          textColor: kTextPrimaryColor,
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
                          child: Text(
                            flashState,
                            style: TextStyle(
                              fontSize: kSubmitButtonFontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BaiJamJuree',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          color: kDefaultPrimaryColor,
                          textColor: kTextPrimaryColor,
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
                          child: Text(
                            cameraState,
                            style: TextStyle(
                              fontSize: kSubmitButtonFontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BaiJamJuree',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: EdgeInsets.all(8),
                  //       child: RaisedButton(
                  //         onPressed: () {
                  //           controller?.pauseCamera();
                  //         },
                  //         child: Text('Pause', style: TextStyle(fontSize: 20)),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(8),
                  //       child: RaisedButton(
                  //         onPressed: () {
                  //           controller?.resumeCamera();
                  //         },
                  //         child: Text('Resume', style: TextStyle(fontSize: 20)),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    //Generate QR Tab
    formWidget.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            new Text(
              'Purpose:',
              style: TextStyle(
                fontSize: 14,
                //fontFamily: 'BaiJamJuree',
              ),
            ),
            new DropdownButton(
              hint: Text('Select Purpose'),
              value: _selectedPurpose,
              items: GetKeyValues.purposeList,
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value;
                });
              },
              isExpanded: true,
            ),
            SizedBox(
              height: 30,
            ),
            new Text(
              'Amount:',
              //textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                //fontFamily: 'BaiJamJuree',
              ),
            ),
            ListTile(
              leading: Text(
                'K',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BaiJamJuree',
                ),
              ),
              title: new TextFormField(
                controller: qrTextController,
                validator: (value) {
                  _decimalValueNoCommas =
                      qrTextController.text.replaceAll(new RegExp(r","), '');

                  if (_decimalValueNoCommas.isNotEmpty ||
                      _decimalValueNoCommas != null) {
                    try {
                      _validDouble = double.parse(_decimalValueNoCommas);

                      if (_validDouble < MyGlobalVariables.minimumTopUpAmount) {
                        _isGenerateEnabled = false;
                        _isQRVisible = false;
                        return 'Minimum allowed is K${currencyConvertor.format(MyGlobalVariables.minimumTopUpAmount)}';
                      } else {
                        if (_validDouble >
                            MyGlobalVariables.maximumTopUpAmount) {
                          _isGenerateEnabled = false;
                          _isQRVisible = false;
                          return 'Maximum allowed is K${currencyConvertor.format(MyGlobalVariables.maximumTopUpAmount)}';
                        }
                        _isGenerateEnabled = true;

                        //Assign QR data a tab delimited string - Wallet Number + Purpose + Amount
                        qrDataString = MyGlobalVariables.onekwachaWalletNumber +
                            '|' +
                            _selectedPurpose.toString() +
                            '|' +
                            _decimalValueNoCommas.toString();
                        print(qrDataString);
                        return null;
                      }
                    } catch (identifier) {
                      _isGenerateEnabled = false;
                      qrDataString = null;
                      _isQRVisible = false;
                      return 'Enter amount';
                    }
                  } else {
                    _isGenerateEnabled = false;
                    qrDataString = null;
                    _isQRVisible = false;
                    return 'String is null or empty';
                  }
                },
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    //locale: 'zm',
                    decimalDigits: 2,
                    //symbol: 'K',
                  )
                ],
                onSaved: (String value) {},
                decoration: InputDecoration(hintText: 'Enter amount'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'BaiJamJuree',
                ),
              ),
              trailing: new RaisedButton(
                color: kDefaultPrimaryColor,
                textColor: kTextPrimaryColor,
                child: new Text(
                  'Generate',
                  style: TextStyle(
                    fontSize: kSubmitButtonFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BaiJamJuree',
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      if (qrDataString != null && _isGenerateEnabled) {
                        _isQRVisible = true;
                      } else {
                        qrDataString = null;
                        _isQRVisible = false;
                      }
                    });
                  }
                },
              ),
            ),
            //QR Code display
            (qrDataString == null)
                ? Container()
                : new Visibility(
                    visible: _isQRVisible,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 50.0),
                        child: Column(
                          children: [
                            Text('Present below QR'),
                            SizedBox(
                              height: 10,
                            ),
                            QrImage(
                              data: qrDataString,
                              gapless: true,
                            ),
                          ],
                        ),
                      ),
                    ])),
          ],
        ),
      ),
    );

    return formWidget;
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  Widget _buildQrView(BuildContext context) {
    // check how wide or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view properly sizes after rotation
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
