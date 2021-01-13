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

  //Update user balance
  Future<bool> updateUserBalance(
    String _userID,
    _currentBalance,
  ) async {
    bool _updated = true;
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("Users").doc(_userID);
    documentRef.get().then((document) async {
      await FirebaseFirestore.instance.collection("Users").doc(_userID).update({
        'CurrentBalance': _currentBalance.toString(),
        'OldBalance': document['CurrentBalance'].toString(),
        'PreviousUpdateDate': document['LastUpdateDate'].toString(),
        'LastUpdateDate': DateTime.now().toString(),
        'UpdateReason': 'Balance Update',
      }).catchError((e) {
        _updated = false;
      });
    });

    return _updated;
  }

  //Get user balance
  Future<double> getUserBalance(String _userID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<DocumentSnapshot> userSnapshot = users.doc(_userID).get();

    return userSnapshot.then((_user) {
      return double.parse(_user.data()['CurrentBalance']);
    });
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
