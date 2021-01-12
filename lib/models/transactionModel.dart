import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  // final double availableBalance;
  // final double fee;
  // final double oldBalance;
  // final double transactionAmount;
  // final int day;
  // final int month;
  // final int year;
  // final String date;
  // final String destination;
  // final String destinationType;
  // final String purpose;
  // final String source;
  // final String sourceType;
  // final String time;
  // final String userID;
  // TransactionModel({
  //   this.availableBalance,
  //   this.fee,
  //   this.oldBalance,
  //   this.transactionAmount,
  //   this.day,
  //   this.month,
  //   this.year,
  //   this.date,
  //   this.destination,
  //   this.destinationType,
  //   this.purpose,
  //   this.source,
  //   this.sourceType,
  //   this.time,
  //   this.userID,
  // });

  Future createTransaction(
    double _currentBalance,
    _fee,
    _oldBalance,
    _transactionAmount,
    int _day,
    _month,
    _year,
    _transactionType,
    _destinationType,
    _sourceType,
    String _date,
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
