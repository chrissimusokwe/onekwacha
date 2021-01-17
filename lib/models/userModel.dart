import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static Future createUser(
    String _userID,
    _address,
    _cardNumber,
    _createdDate,
    _currentBalance,
    _email,
    _firstName,
    _kycDate,
    _kycStatus,
    _lastName,
    _lastUpdateDate,
    _loyaltyPoints,
    _nrcNumber,
    _oldBalance,
    _phoneNumber,
    _previousUpdateDate,
    _transactionID,
  ) async {
    print('Current balance is :' + _currentBalance.toString());
    await FirebaseFirestore.instance.collection("Users").doc(_userID).set({
      'AccountStatus': 'Pending',
      'Address': _address.toString(),
      'CurrentBalance': _currentBalance.toString(),
      'CardNumber': _cardNumber.toString(),
      'CreatedDate': _createdDate.toString(),
      'Email': _email.toString(),
      'FirstName': _firstName.toString(),
      'KYCDate': _kycDate.toString(),
      'KYCStatus': 'Pending',
      'LastName': _lastName.toString(),
      'LastUpdateDate': _lastUpdateDate.toString(),
      'LoyaltyPoints': _loyaltyPoints.toString(),
      'NRCNumber': _nrcNumber.toString(),
      'PreviousBalance': '0.0',
      'PhoneNumber': _userID.toString(),
      'LastTransactionID': _transactionID.toString(),
      'PreviousUdpateDate': _previousUpdateDate.toString(),
    });
    //return documentRef;
  }

  Future<bool> updateUser(
    String _userID,
    _accountStatus,
    _address,
    _cardNumber,
    _createdDate,
    _currentBalance,
    _email,
    _firstName,
    _kycDate,
    _kycStatus,
    _lastName,
    _lastUpdateDate,
    _loyaltyPoints,
    _nrcNumber,
    _oldBalance,
    _phoneNumber,
    _previousUpdateDate,
  ) async {
    bool _updated = true;
    await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
      'AccountStatus': _accountStatus,
      'Address': _address,
      'CurrentBalance': _currentBalance,
      'CardNumber': _cardNumber,
      'CreatedDate': _createdDate,
      'Email': _email,
      'FirstName': _firstName,
      'KYCDate': _kycDate,
      'KYCStatus': _kycStatus,
      'LastName': _lastName,
      'LastUpdateDate': _lastUpdateDate,
      'LoyaltyPoints': _loyaltyPoints,
      'NRCNumber': _nrcNumber,
      'PreviousBalance': _oldBalance,
      'PhoneNumber': _phoneNumber,
      'PreviousUpdateDate': _previousUpdateDate,
    }).catchError((e) {
      _updated = false;
    });
    return _updated;
  }

  //Credit destination user balance
  Future<bool> creditDestinationUserBalance(
    String _transactionID,
    _creditUserID,
    double _amount,
  ) async {
    bool _destinationCredited = true;
    double _currentBalance = 0;
    double _newBalance = 0;
    //UserModel userModel = new UserModel();
    String _dateTime;

    try {
      // user exists, so get current balance
      _currentBalance = await getUserBalance(_creditUserID);

      //Add current balance and transaction amount (excludes fees)
      //to get the new wallet balance to apply on destination user.
      _newBalance = _currentBalance + _amount;

      //Get document reference to user document
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection("Users").doc(_creditUserID);

      //Perform the update on the user if the user exisits
      documentRef.get().then((document) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_creditUserID)
            .update({
          'CurrentBalance': _newBalance.toString(),
          'PreviousBalance': document['CurrentBalance'].toString(),
          'PreviousUpdateDate': document['LastUpdateDate'].toString(),
          'LastUpdateDate': DateTime.now().toString(),
          'LastTransactionID': _transactionID.toString(),
          'UpdateReason': 'Balance Update',
        }).catchError((e) {
          _destinationCredited = false;
        });
      });
    } catch (e) {
      if (_currentBalance == 0 || _currentBalance == null) {
        _dateTime = DateTime.now().toString();

        createUser(
          _creditUserID,
          '',
          '',
          _dateTime,
          _amount,
          '',
          '',
          '',
          'Pending',
          '',
          _dateTime,
          '',
          '',
          '0.0',
          _creditUserID,
          _dateTime,
          _transactionID,
        );

        //user does not exist, then create new user and set the fields
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_creditUserID)
            .set({
          'AccountStatus': 'Pending Review',
          'Address': '',
          'CurrentBalance': _amount.toString(),
          'CardNumber': '',
          'CreatedDate': _dateTime,
          'Email': '',
          'FirstName': '',
          'KYCDate': '',
          'KYCStatus': 'Pending Review',
          'LastName': '',
          'LastUpdateDate': _dateTime,
          'LoyaltyPoints': '',
          'NRCNumber': '',
          'PreviousBalance': '0.0',
          'PhoneNumber': _creditUserID,
          'PreviousUpdateDate': _dateTime,
          'LastTransactionID': _transactionID.toString(),
          'UpdateReason': 'Account Created'
        }).catchError((e) {
          _destinationCredited = false;
        });
      }
    }
    return _destinationCredited;
  }

  //Update user balance
  Future<bool> updateUserBalance(
    String _transactionID,
    _userID,
    _currentBalance,
  ) async {
    bool _updated = true;

    //Get document reference to user document
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);

    //Perform the update on the user if the user exisits
    documentRef.get().then((document) async {
      await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
        'CurrentBalance': _currentBalance.toString(),
        'PreviousBalance': document['CurrentBalance'].toString(),
        'PreviousUpdateDate': document['LastUpdateDate'].toString(),
        'LastUpdateDate': DateTime.now().toString(),
        'LastTransactionID': _transactionID.toString(),
        'UpdateReason': 'Balance Update',
      }).catchError((e) {
        _updated = false;
      });
    });

    return _updated;
  }

  //Acivate user
  Future<bool> activateUser(
    String _userID,
  ) async {
    bool _activated = true;

    //Get document reference to user document
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);

    //Perform the update on the user if the user exisits
    documentRef.get().then((document) async {
      await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
        'AccountStatus': 'Active',
      }).catchError((e) {
        _activated = false;
      });
    });

    return _activated;
  }

  //KYC approve user
  Future<bool> approveKYC(
    String _userID,
    _kycApproveDate,
  ) async {
    bool _approved = true;

    //Get document reference to user document
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);

    //Perform the update on the user if the user exisits
    documentRef.get().then((document) async {
      await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
        'KYCStatus': 'Approved',
        'KYCDate': _kycApproveDate,
      }).catchError((e) {
        _approved = false;
      });
    });

    return _approved;
  }

  //Get user balance
  Future<double> getUserBalance(String _userID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<DocumentSnapshot> userSnapshot = users.doc(_userID).get();

    return userSnapshot.then((_user) {
      return double.parse(_user.data()['CurrentBalance']);
    });
  }

  //Get user snapshot
  Future<DocumentSnapshot> getUser(String _userID) async {
    Future<DocumentSnapshot> userSnapshot;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    userSnapshot = users.doc(_userID).get();
    return userSnapshot;
  }

  //Get user first name
  Future<String> getUserFirstName(String _userID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<DocumentSnapshot> userSnapshot = users.doc(_userID).get();

    return userSnapshot.then((_user) {
      return _user.data()['FirstName'];
    });
  }
}
