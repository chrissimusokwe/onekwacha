import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantTransactionModel {
  //Merchant transaction creation
  Future createMerchantTransaction(
    double _fee,
    _transactionAmount,
    int _day,
    _month,
    _year,
    String _merchantName,
    _productCode,
    _productDescription,
    _productPrice,
    _productCategory,
    _transactionType,
    _destinationType,
    _sourceType,
    _date,
    _destination,
    _purpose,
    _source,
    _time,
    _userID,
    _transactionID,
  ) async {
    if (_productCategory == null || _productCategory == '') {
      _productCategory = 'None';
    }

    DocumentReference documentRef = await FirebaseFirestore.instance
        .collection("Marketplace")
        .doc(_merchantName)
        .collection("Transactions")
        .add({
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
      'TransactionID': _transactionID.toString(),
      'ProductCode': _productCode.toString(),
      'ProductDescription': _productDescription.toString(),
      'ProductPrice': _productPrice.toString(),
      'ProductCategory': _productCategory.toString(),
    });

    return documentRef;
  }
}
