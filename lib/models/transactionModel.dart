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
    _purchasedProductCode,
    _bankAccountName,
  ) async {
    double _cashOutAmount = _transactionAmount - _fee;
    if (_purchasedProductCode == null || _purchasedProductCode == '') {
      _purchasedProductCode = 'None';
    }

    if (_bankAccountName == null || _bankAccountName == '') {
      _bankAccountName = 'None';
    }
    //Add to General Ledger transactions
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
      'PurchasedProductCode': _purchasedProductCode.toString(),
      'BankAccountName': _bankAccountName.toString(),
    }).catchError((e) {
      return null;
    });

    if (documentRef != null) {
      if (_transactionType == 'Transfer' ||
          _transactionType == 'Cash out' ||
          _transactionType == 'Marketplace') {
        //Add to specific source user transactions
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_source.toString())
            .collection("Transactions")
            .doc(documentRef.id)
            .set({
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
          'PurchasedProductCode': _purchasedProductCode.toString(),
          'TransactionID': documentRef.id.toString(),
          'BankAccountName': _bankAccountName.toString(),
        });
      }

      if (_transactionType == 'Transfer' || _transactionType == 'Top up') {
        //Add to specific destination user's transactions
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_destination.toString())
            .collection("Transactions")
            .doc(documentRef.id)
            .set({
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
          'PurchasedProductCode': _purchasedProductCode.toString(),
          'TransactionID': documentRef.id.toString(),
        });
      }

      if (_destinationType == 'Bank Account') {
        //Add to accounts ledger cash out transaction under bank account
        await FirebaseFirestore.instance
            .collection("Accounts")
            .doc(_transactionType.toString())
            .collection("Bank Account")
            .doc(documentRef.id)
            .set({
          'Date': _date.toString(),
          'Day': _day.toString(),
          'Destination': _destination.toString(),
          'DestinationType': _destinationType.toString(),
          'Fee': _fee.toString(),
          'Month': _month.toString(),
          'Year': _year.toString(),
          'Purpose': _purpose.toString(),
          'Source': _source.toString(),
          'SourceType': _sourceType.toString(),
          'Time': _time.toString(),
          'TransactionAmount': _transactionAmount.toString(),
          'TransactionType': _transactionType.toString(),
          'UserID': _userID.toString(),
          'InvoiceID': _invoiceID.toString(),
          'PurchasedProductCode': _purchasedProductCode.toString(),
          'TransactionID': documentRef.id.toString(),
          'CashOutAmount': _cashOutAmount.toString(),
          'BankAccountName': _bankAccountName.toString(),
        });
      }

      if (_destinationType == 'Mobile Money') {
        //Add to accounts ledger cash out transaction under Mobile Money
        await FirebaseFirestore.instance
            .collection("Accounts")
            .doc(_transactionType.toString())
            .collection("Mobile Money")
            .doc(documentRef.id)
            .set({
          'Date': _date.toString(),
          'Day': _day.toString(),
          'Destination': _destination.toString(),
          'DestinationType': _destinationType.toString(),
          'Fee': _fee.toString(),
          'Month': _month.toString(),
          'Year': _year.toString(),
          'Purpose': _purpose.toString(),
          'Source': _source.toString(),
          'SourceType': _sourceType.toString(),
          'Time': _time.toString(),
          'TransactionAmount': _transactionAmount.toString(),
          'TransactionType': _transactionType.toString(),
          'UserID': _userID.toString(),
          'InvoiceID': _invoiceID.toString(),
          'PurchasedProductCode': _purchasedProductCode.toString(),
          'TransactionID': documentRef.id.toString(),
          'CashOutAmount': _cashOutAmount.toString(),
        });
      }

      if (_transactionType != 'Cash out') {
        //Add to accounts ledger by transaction type
        await FirebaseFirestore.instance
            .collection("Accounts")
            .doc(_transactionType.toString())
            .collection("Transactions")
            .doc(documentRef.id)
            .set({
          'Date': _date.toString(),
          'Day': _day.toString(),
          'Destination': _destination.toString(),
          'DestinationType': _destinationType.toString(),
          'Fee': _fee.toString(),
          'Month': _month.toString(),
          'Year': _year.toString(),
          'Purpose': _purpose.toString(),
          'Source': _source.toString(),
          'SourceType': _sourceType.toString(),
          'Time': _time.toString(),
          'TransactionAmount': _transactionAmount.toString(),
          'TransactionType': _transactionType.toString(),
          'UserID': _userID.toString(),
          'InvoiceID': _invoiceID.toString(),
          'PurchasedProductCode': _purchasedProductCode.toString(),
          'TransactionID': documentRef.id.toString(),
        });
      }
    }
    return documentRef;
  }
}
