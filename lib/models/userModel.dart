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
  ) async {
    await FirebaseFirestore.instance.collection("Users").doc(_userID).set({
      'AccountStatus': 'Pending',
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
      'OldBalance': _oldBalance,
      'PhoneNumber': _phoneNumber,
      'PreviousUdpateDate': _previousUpdateDate,
    });
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
      'OldBalance': _oldBalance,
      'PhoneNumber': _phoneNumber,
      'PreviousUdpateDate': _previousUpdateDate,
    }).catchError((e) {
      _updated = false;
    });
    return _updated;
  }

  Future<bool> updateUserBalance(
    String _userID,
    _currentBalance,
  ) async {
    bool _updated = true;
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);
    documentRef.get().then((document) async {
      await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
        'CurrentBalance': _currentBalance,
        'OldBalance': document['CurrentBalance'],
        'PreviousUdpateDate': document['LastUpdateDate'],
        'LastUpdateDate': DateTime.now(),
        'UpdateReason': 'Balance Update'
      }).catchError((e) {
        _updated = false;
      });
    });

    return _updated;
  }

  Future<double> getUserBalance(String _userID) async {
    double _currentBalance;

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);
    documentRef.get().then((document) {
      _currentBalance = document['CurrentBalance'];
    });
    return _currentBalance;
  }
}
