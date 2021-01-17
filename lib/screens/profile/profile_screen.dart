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
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController numberController = new TextEditingController();
  //TextEditingController firtName = new TextEditingController();
  GetKeyValues getKeyValues = new GetKeyValues();

  UserModel userModel = new UserModel();
  TransactionModel transactionModel = new TransactionModel();
  bool _updated = false;
  bool _status = true;
  String _name;
  final FocusNode myFocusNode = FocusNode();
  int _selectedIndex = 2;
  String _currentUserLoginID,
      _accountStatus,
      _createdDate,
      _currentBalance,
      _kycDate,
      _kycStatus,
      _firstName,
      _middleName,
      _lastName,
      _address,
      _email,
      _phoneNumber,
      _nrcPassport,
      _selectedGender,
      _dateOfBirth;
  int _selectedGenderValue = 0;

  DocumentSnapshot _user;

  void getUser() async {
    _currentUserLoginID = getKeyValues.getCurrentUserLoginID();

    _user = await userModel.getUser(_currentUserLoginID);
    setState(() {
      _firstName = _user['FirstName'];
      _middleName = _user['MiddleName'];
      _lastName = _user['LastName'];
      _selectedGenderValue = getKeyValues.getGenderString(_user['Gender']);
      _selectedGender = _user['Gender'];
      _dateOfBirth = _user['DateOfBirth'];
      _nrcPassport = _user['NRCPassport'];
      _address = _user['Address'];
      _email = _user['Email'];
      _phoneNumber = _user['PhoneNumber'];
      _accountStatus = _user['AccountStatus'];
      _createdDate = _user['CreatedDate'];
      _currentBalance = _user['CurrentBalance'];
      _kycDate = _user['KYCDate'];
      _kycStatus = _user['KYCStatus'];
    });

    print(_selectedGender + ' And ' + _selectedGenderValue.toString());
  }

  @override
  void initState() {
    super.initState();
    getUser();
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
                  _status ? _getEditIcon() : new Container(),
                ],
              ))
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: ListView(
            children: getFormWidget(),
          ),
        ),
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
    formWidget.add(
      TextFormField(
        //controller: firtName,
        initialValue: _firstName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your first name',
          labelText: 'First Name',
        ),
        onSaved: (String value) {
          _firstName = value;
        },
        enabled: !_status,
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
    formWidget.add(
      TextFormField(
        initialValue: _lastName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your last name',
          labelText: 'Last Name',
        ),
        onSaved: (String value) {
          _lastName = value;
        },
        enabled: !_status,
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
    formWidget.add(
      TextFormField(
        initialValue: _middleName,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your middle name',
          labelText: 'Middle Name',
        ),
        onSaved: (String value) {
          _middleName = value;
        },
        enabled: !_status,
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
    //formWidget.add(
    formWidget.add(DropdownButton(
      hint: Text(
        'Select Gender',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      disabledHint: Text(
        _selectedGender,
        style: TextStyle(
          fontSize: 20,
          color: kTextPrimaryColor,
        ),
      ),
      onChanged: !_status
          ? (value) => setState(() => _selectedGenderValue = value)
          : null,
      items: getKeyValues.genderList,
      value: _selectedGenderValue,
      isExpanded: true,
    ));

    //   TextFormField(
    //     decoration: const InputDecoration(
    //       border: const UnderlineInputBorder(),
    //       hintText: 'Enter your gender',
    //       labelText: 'Gender',
    //     ),
    //     onSaved: (String value) {
    //       _name = value;
    //     },
    //     enabled: !_status,
    //     style: TextStyle(fontSize: 20),
    //     keyboardType: TextInputType.text,
    //     validator: (String value) =>
    //         value.isEmpty ? MyGlobalVariables.fieldReq : null,
    //   ),
    // );
    formWidget.add(
      SizedBox(
        height: 20.0,
      ),
    );
    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your date of birth',
          labelText: 'Date of Birth',
        ),
        onSaved: (String value) {
          _dateOfBirth = value;
        },
        enabled: !_status,
        initialValue: _dateOfBirth,
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
    formWidget.add(
      TextFormField(
        initialValue: _address,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your address',
          labelText: 'Address',
        ),
        onSaved: (String value) {
          _name = value;
        },
        enabled: !_status,
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
    formWidget.add(
      TextFormField(
        initialValue: _nrcPassport,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your NRC/Passport No.',
          labelText: 'NRC/Passport No.',
        ),
        onSaved: (String value) {
          _name = value;
        },
        enabled: !_status,
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
    formWidget.add(
      TextFormField(
        initialValue: _email,
        decoration: const InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'Enter your email',
          labelText: 'Email',
        ),
        onSaved: (String value) {
          _name = value;
        },
        enabled: !_status,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.text,
        // validator: (String value) =>
        //     value.isEmpty ? MyGlobalVariables.fieldReq : null,
      ),
    );
    formWidget.add(
      Visibility(
        visible: !_status,
        child: _getActionButtons(),
      ),
    );

    return formWidget;
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: kTextPrimaryColor,
                color: kDefaultPrimaryColor,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: kTextPrimaryColor,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
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
    );
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
          _status = false;
        });
      },
    );
  }
}
