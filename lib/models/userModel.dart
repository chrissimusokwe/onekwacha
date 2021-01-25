import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static Future<bool> createUser(
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
    bool _userCreated = true;

    print('Current balance is :' + _currentBalance.toString());
    await FirebaseFirestore.instance.collection("Users").doc(_userID).set({
      'Address': _address.toString(),
      'CurrentBalance': _currentBalance.toString(),
      'CardNumber': _cardNumber.toString(),
      'CreatedDate': _createdDate.toString(),
      'Email': _email.toString(),
      'FirstName': _firstName.toString(),
      'KYCDate': _kycDate.toString(),
      'KYCStatus': 'Unsubmitted',
      'LastName': _lastName.toString(),
      'LastUpdateDate': _lastUpdateDate.toString(),
      'LoyaltyPoints': _loyaltyPoints.toString(),
      'NRCPassport': _nrcNumber.toString(),
      'PreviousBalance': '0.0',
      'PhoneNumber': _userID.toString(),
      'LastTransactionID': _transactionID.toString(),
      'PreviousUdpateDate': _previousUpdateDate.toString(),
    }).catchError((e) {
      _userCreated = false;
    });
    return _userCreated;
  }

  Future<bool> updateUser(
    String _userID,
    _address,
    _cardNumber,
    _email,
    _firstName,
    _gender,
    _dateOfBirth,
    _middleName,
    _kycStatus,
    _lastName,
    _loyaltyPoints,
    _nrcNumber,
    _phoneNumber,
    _previousUpdateDate,
    _updateReason,
  ) async {
    bool _updated = true;
    await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
      'Address': _address.toString(),
      'CardNumber': _cardNumber.toString(),
      'Email': _email.toString(),
      'FirstName': _firstName.toString(),
      'MiddleName': _middleName.toString(),
      'Gender': _gender.toString(),
      'DateOfBirth': _dateOfBirth.toString(),
      'KYCStatus': _kycStatus.toString(),
      'LastName': _lastName.toString(),
      'LastUpdateDate': DateTime.now().toString(),
      'LoyaltyPoints': _loyaltyPoints.toString(),
      'NRCPassort': _nrcNumber.toString(),
      'PhoneNumber': _phoneNumber.toString(),
      'PreviousUpdateDate': _previousUpdateDate.toString(),
      'UpdateReason': _updateReason.toString(),
    }).catchError((e) {
      _updated = false;
    });
    return _updated;
  }

  //Credit destination user balance
  Future<bool> creditDestinationUserBalance(
    String _transactionID,
    _creditUserID,
    _transactionDate,
    double _amount,
  ) async {
    bool _destinationCredited = true;
    double _currentBalance = 0;
    double _newBalance = 0;
    String _dateTime;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_creditUserID)
        .get()
        .then((_user) async {
      if (_user.exists) {
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
            'LastUpdateDate': _transactionDate.toString(),
            'LastTransactionID': _transactionID.toString(),
            'UpdateReason': 'Balance Update',
          }).catchError((e) {
            _destinationCredited = false;
          });
        });
      } else {
        //user does not exist, then create new user and set the fields
        if (_currentBalance == 0 || _currentBalance == null) {
          _dateTime = _transactionDate;

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(_creditUserID)
              .set({
            'Address': '',
            'CurrentBalance': _amount.toString(),
            'CardNumber': '',
            'CreatedDate': _dateTime.toString(),
            'Email': '',
            'FirstName': '',
            'KYCDate': '',
            'KYCStatus': 'Unsubmitted',
            'LastName': '',
            'LastUpdateDate': _dateTime.toString(),
            'LoyaltyPoints': '',
            'NRCPassport': '',
            'PreviousBalance': '0.0',
            'PhoneNumber': _creditUserID.toString(),
            'PreviousUpdateDate': _dateTime.toString(),
            'LastTransactionID': _transactionID.toString(),
            'UpdateReason': 'Account Created'
          }).catchError((e) {
            _destinationCredited = false;
          });
        }
      }
    });
    return _destinationCredited;
  }

  //Update user balance
  Future<bool> updateUserBalance(
    String _transactionID,
    _userID,
    _currentBalance,
    _transactionDate,
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
        'LastUpdateDate': _transactionDate.toString(),
        'LastTransactionID': _transactionID.toString(),
        'UpdateReason': 'Balance Update',
      }).catchError((e) {
        _updated = false;
      });
    });

    return _updated;
  }

  //Update user balance
  Future<bool> updateUserImageUrl(
    String _userID,
    _url,
    bool isfront,
  ) async {
    bool _updated = true;

    //Get document reference to user document
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);

    if (isfront) {
      //Uplaod front or page 1 of ID document
      documentRef.get().then((document) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_userID)
            .update({
          'IDFrontImage': _url.toString(),
          'PreviousUpdateDate': document['LastUpdateDate'].toString(),
          'LastUpdateDate': DateTime.now().toString(),
          'UpdateReason': 'Image ID Update',
        }).catchError((e) {
          _updated = false;
        });
      });
    } else {
      //Uplaod back or page 2 of ID document
      documentRef.get().then((document) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_userID)
            .update({
          'IDBackImage': _url.toString(),
          'PreviousUpdateDate': document['LastUpdateDate'].toString(),
          'LastUpdateDate': DateTime.now().toString(),
          'UpdateReason': 'Image ID Update',
        }).catchError((e) {
          _updated = false;
        });
      });
    }

    return _updated;
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
