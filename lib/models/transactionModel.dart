import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  //Transaction creation
  Future createTransaction(
    double _currentBalance,
    _fee,
    _oldBalance,
    _transactionAmount,
    int _day,
    _month,
    _year,
    String _transactionType,
    _destinationType,
    _sourceType,
    _date,
    _destination,
    _purpose,
    _source,
    _time,
    _userID,
    _invoiceID,
  ) async {
    DocumentReference documentRef =
        await FirebaseFirestore.instance.collection("Transactions").add({
      'CurrentBalance': _currentBalance.toString(),
      'Date': _date.toString(),
      'Day': _day.toString(),
      'Destination': _destination.toString(),
      'DestinationType': _destinationType.toString(),
      'Fee': _fee.toString(),
      'Month': _month.toString(),
      'Year': _year.toString(),
      'PreviousBalance': _oldBalance.toString(),
      'Purpose': _purpose.toString(),
      'Source': _source.toString(),
      'SourceType': _sourceType.toString(),
      'Time': _time.toString(),
      'TransactionAmount': _transactionAmount.toString(),
      'TransactionType': _transactionType.toString(),
      'UserID': _userID.toString(),
      'InvoiceID': _invoiceID.toString(),
    });
    return documentRef;
  }
}
