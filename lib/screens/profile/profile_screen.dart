import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:onekwacha/models/transactionModel.dart';
import 'package:onekwacha/utils/get_key_values.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/widgets/image_upload.dart';

class ProfileScreen extends StatefulWidget {
  final int incomingData;

  ProfileScreen({
    Key key,
    this.incomingData,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");
  final _formKey = new GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();

  TextEditingController numberController = new TextEditingController();
  TextEditingController _ctrlFirstName = new TextEditingController();
  TextEditingController _ctrlMiddleName = new TextEditingController();
  TextEditingController _ctrlLastName = new TextEditingController();
  TextEditingController _ctrlAddress = new TextEditingController();
  TextEditingController _ctrlNRCPassport = new TextEditingController();
  TextEditingController _ctrlEmail = new TextEditingController();

  GetKeyValues getKeyValues = new GetKeyValues();
  UserModel userModel = new UserModel();
  TransactionModel transactionModel = new TransactionModel();

  //bool _updated;
  bool _enableFields = true;

  int _selectedIndex = 2;
  String _currentUserLoginID,
      _createdDate,
      _kycStatus,
      _phoneNumber,
      _selectedGenderString,
      // _updateReason,
      // _previousUpdateDate,
      _lastUpdateDate;
  // _loyaltyPoints,
  // _cardNumber;
  int _selectedGenderValue = 0;
  DateTime _selectedDoBInternal;
  String _selectedDoBDisplay;

  DocumentSnapshot _user;

  //Get user profile details from the database
  void getUser() async {
    _currentUserLoginID = getKeyValues.getCurrentUserLoginID();

    _user = await userModel.getUser(_currentUserLoginID);
    setState(() {
      _ctrlFirstName.text = _user['FirstName'];
      _ctrlMiddleName.text = _user['MiddleName'];
      _ctrlLastName.text = _user['LastName'];
      _selectedGenderValue = getKeyValues.getGenderValue(_user['Gender']);
      _selectedGenderString = _user['Gender'];
      _selectedDoBInternal = DateTime.parse(_user['DateOfBirth']);
      _selectedDoBDisplay = (formatDate(
          DateTime.parse(_user['DateOfBirth'] ?? '2021-01-01 00:00:00.000000'),
          [
            dd,
            '/',
            mm,
            '/',
            yyyy,
          ]));
      _ctrlNRCPassport.text = _user['NRCPassport'];
      _ctrlAddress.text = _user['Address'];
      _ctrlEmail.text = _user['Email'];
      _phoneNumber = _user['PhoneNumber'];
      _createdDate = _user['CreatedDate'];
      _kycStatus = _user['KYCStatus'];
      _lastUpdateDate = _user['LastUpdateDate'];
    });
  }

  @override
  void initState() {
    super.initState();

    //Get user details only on first run of the page
    getUser();
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDoBInternal, // Refer step 1
      helpText: 'Select Date of Birth',
      confirmText: 'SELECT',
      firstDate: DateTime(1920),
      lastDate: DateTime(2010),
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Date of Birth',
      fieldHintText: 'MM/DD/YYYY',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDoBInternal)
      setState(() {
        _selectedDoBInternal = picked;
        _selectedDoBDisplay = (formatDate(_selectedDoBInternal, [
          dd,
          '/',
          mm,
          '/',
          yyyy,
        ]));
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != _selectedDoBInternal)
                  setState(() {
                    _selectedDoBInternal = picked;
                  });
              },
              initialDateTime: _selectedDoBInternal,
              minimumYear: 1921,
              maximumYear: 1010,
              //use24hFormat: true,
            ),
          );
        });
  }

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    getKeyValues.loadGenderList();
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'My Profile',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23.0,
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _enableFields && (_kycStatus == 'Unsubmitted')
                      ? _getEditIcon()
                      : new Container(),
                ],
              ))
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: (_phoneNumber != null || _phoneNumber == '')
              ? ListView(
                  children: getFormWidget(),
                )
              : Center(child: CircularProgressIndicator()),
        ),

        // Container(
        //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        //   child: (_phoneNumber != null || _phoneNumber.isEmpty)
        //       ? RefreshIndicator(
        //           child: ListView(
        //             children: getFormWidget(),
        //           ),
        //           onRefresh: getUser,
        //         )
        //       : Center(child: CircularProgressIndicator()),
        // ),
        bottomNavigationBar: BottomNavigation(
          incomingData: _selectedIndex,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(
      SizedBox(
        height: 10.0,
      ),
    );

    //Profile Status
    formWidget.add(Row(
      children: [
        Text(
          'KYC Status: ',
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
        (_kycStatus == 'Approved')
            ? Text(
                _kycStatus,
                style: TextStyle(
                  color: Colors.green,
                ),
              )
            : Text(
                _kycStatus ?? 'Loading...',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
      ],
    ));
    formWidget.add(
      SizedBox(
        height: 10.0,
      ),
    );

    //First Name
    formWidget.add(
      TextFormField(
        controller: _ctrlFirstName,
        //initialValue: _firstName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your first name',
          labelText: 'First Name',
        ),
        onSaved: (String value) {
          //_firstName = value;
        },
        enabled: !_enableFields,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        validator: (String value) =>
            value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //Last Name
    formWidget.add(
      TextFormField(
        controller: _ctrlLastName,
        //initialValue: _lastName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your last name',
          labelText: 'Last Name',
        ),
        onSaved: (String value) {
          //_lastName = value;
        },
        enabled: !_enableFields,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        validator: (String value) =>
            value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //Middle Name
    formWidget.add(
      TextFormField(
        controller: _ctrlMiddleName,
        //initialValue: _middleName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your middle name',
          labelText: 'Middle Name',
        ),
        onSaved: (String value) {
          //_middleName = value;
        },
        enabled: !_enableFields,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        // validator: (String value) =>
        //     value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 40.0,
      ),
    );

    //Gender
    formWidget.add(DropdownButton(
      hint: Text(
        'Select Gender',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      disabledHint:
          (_selectedGenderString == null || _selectedGenderString == '')
              ? Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 20,
                    color: kTextPrimaryColor,
                  ),
                )
              : Text(
                  _selectedGenderString,
                  style: TextStyle(
                    fontSize: 20,
                    color: kTextPrimaryColor,
                  ),
                ),
      onChanged: !_enableFields
          ? (value) {
              setState(() {
                _selectedGenderValue = value;
                _selectedGenderString =
                    getKeyValues.getGenderString(_selectedGenderValue);
              });
            }
          : null,
      items: getKeyValues.genderList,
      value: _selectedGenderValue,
      isExpanded: true,
    ));
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //Date of birth
    formWidget.add(
      (!_enableFields)
          ? Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade600),
                ),
              ),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (_selectedDoBDisplay == null ||
                              _selectedDoBDisplay.isEmpty)
                          ? Text(
                              'Select Date of Birth',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade500),
                            )
                          : Text(
                              _selectedDoBDisplay,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_drop_down),
                  onTap: () {
                    if (!_enableFields) {
                      _selectDate(context);
                    }
                  }),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of Birth',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    (_selectedDoBDisplay == null || _selectedDoBDisplay.isEmpty)
                        ? Text(
                            'Select Date of Birth',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade500),
                          )
                        : Text(
                            _selectedDoBDisplay,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20),
                          ),
                  ],
                ),
                trailing: Icon(Icons.arrow_drop_down),
              ),
            ),
    );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //Address
    formWidget.add(
      TextFormField(
        controller: _ctrlAddress,
        //initialValue: _address,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your address',
          labelText: 'Address',
        ),
        onSaved: (String value) {
          //_address = value;
        },
        enabled: !_enableFields,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        validator: (String value) =>
            value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //NRC or Passport Number
    formWidget.add(
      TextFormField(
        controller: _ctrlNRCPassport,
        //initialValue: _nrcPassport,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your NRC/Passport No.',
          labelText: 'NRC/Passport No.',
        ),
        onSaved: (String value) {
          //_nrcPassport = value;
        },
        enabled: !_enableFields,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        validator: (String value) =>
            value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    //Email address
    formWidget.add(
      TextFormField(
        controller: _ctrlEmail,
        //initialValue: _email,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your email',
          labelText: 'Email',
        ),
        onSaved: (String value) {
          //_email = value;
        },
        enabled: !_enableFields,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        // validator: (String value) =>
        //     value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      SizedBox(
        height: 10.0,
      ),
    );

    //Save buttons
    formWidget.add(
      Column(
        children: [
          Visibility(
            visible: !_enableFields,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Save button
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Container(
                          child: new RaisedButton(
                        child: new Text("Scan and Upload ID"),
                        textColor: kTextPrimaryColor,
                        color: kDefaultPrimaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ImageUpload(
                                userID: _phoneNumber,
                                firstName: _ctrlFirstName.text,
                                lastName: _ctrlLastName.text,
                                middleName: _ctrlMiddleName.text,
                                address: _ctrlAddress.text,
                                email: _ctrlEmail.text,
                                lastUpdateDate: _lastUpdateDate,
                                nrcPassport: _ctrlNRCPassport.text,
                                phoneNumber: _phoneNumber,
                                selectedDoB: _selectedDoBInternal.toString(),
                                selectedGender: _selectedGenderString,
                              ),
                            ),
                          );
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      )),
                    ),
                    flex: 2,
                  ),

                  //Cancel Button
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                          child: new RaisedButton(
                        child: new Text("Cancel"),
                        textColor: kTextPrimaryColor,
                        color: Colors.grey.shade400,
                        onPressed: () {
                          setState(() {
                            _enableFields = true;
                            getUser();
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      )),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            //_getActionButtons(),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );

    //Phone number
    formWidget.add(Row(
      children: [
        Text(
          'Phone Number: ',
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          getKeyValues.formatPhoneNumberWithSpaces(_phoneNumber) ??
              'Loading...',
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    ));

    //Created date
    formWidget.add(Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Text(
              'Created: ',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              (formatDate(
                  DateTime.parse(_createdDate ?? '2021-01-01 00:00:00.000000'),
                  [
                    d,
                    ' ',
                    MM,
                    ' ',
                    yyyy,
                    ' at ',
                    hh,
                    ':',
                    nn,
                    ' ',
                    am,
                  ])),
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    ));
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );

    return formWidget;
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: kDefaultPrimaryColor,
        radius: 20.0,
        child: new Icon(
          Icons.edit,
          color: kTextPrimaryColor,
          size: 22.0,
        ),
      ),
      onTap: () {
        setState(() {
          _enableFields = false;
        });
      },
    );
  }
}
