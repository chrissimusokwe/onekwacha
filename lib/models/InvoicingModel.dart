import 'package:cloud_firestore/cloud_firestore.dart';

class InvoicingModel {
  // final String amount;
  // final String fee;
  // final String invoiceDate;
  // final String purpose;
  // final String receivableUserID;
  // final String settlementDate;
  // final String status;
  // final String payableUserID;

  // InvoicingModel(
  //     {this.amount,
  //     this.fee,
  //     this.invoiceDate,
  //     this.purpose,
  //     this.receivableUserID,
  //     this.settlementDate,
  //     this.status,
  //     this.payableUserID});

  static Future createInvoice(String _amount, String _fee, String _purpose,
      String _receivableUserID, String _payableUserID) async {
    DocumentReference document =
        await FirebaseFirestore.instance.collection("Invoices").add({
      'Amount': _amount,
      'Fee': _fee,
      'InvoiceDate': DateTime.now().toString(),
      'Purpose': _purpose,
      'ReceivableUserID': _receivableUserID,
      'SettlementDate': '',
      'PayableUserID': _payableUserID,
      'Status': 'Active'
    });

    return document;
  }

  static Future<void> deactivateInvoice(String id) async {
    await FirebaseFirestore.instance
        .collection("Invoices")
        .doc(id)
        .update({"Status": "InActive"});
  }

  Future<void> editInvoice(bool _isFavourite, String id) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(id)
        .update({"isFavourite": !_isFavourite});
  }

  Future<void> deleteProduct(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(doc.id)
        .delete();
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     "Amount": this.amount,
  //     "Fee": this.fee,
  //     "InvoiceDate": this.invoiceDate,
  //     "Purpose": this.purpose,
  //     "ReceivableUserID": this.receivableUserID,
  //     "SettlementDate": this.settlementDate,
  //     "PayableUserID": this.payableUserID,
  //     "Status": this.status
  //   };
  // }

  // static String createNewInvoice(
  //   String _amount,
  //   String _fee,
  //   String _purpose,
  //   String _receivableUserID,
  //   String _payableUserID,
  // ) {
  //   InvoicingModel invoicingModel = new InvoicingModel();
  //   String _documentID;
  //   //DocumentSnapshot document;

  //   Future<void> addNewInvoices(final invoice) async {
  //     FirebaseFirestore firestore = await FirebaseFirestore.instance;
  //     firestore
  //         .collection("Invoices")
  //         .add(invoice)
  //         .then((DocumentReference documentRef) {
  //       _documentID = documentRef.id;
  //       //document = await documentRef.get();

  //       print(documentRef.id);
  //     }).catchError((e) {
  //       //print(e);
  //     });
  //   }

  //   invoicingModel = InvoicingModel(
  //     amount: _amount,
  //     fee: _fee,
  //     invoiceDate: DateTime.now().toString(),
  //     purpose: _purpose,
  //     receivableUserID: _receivableUserID,
  //     payableUserID: _payableUserID,
  //     settlementDate: '',
  //     status: 'Active',
  //   );

  //   addNewInvoices(invoicingModel.toMap());

  //   return _documentID;
  // }
}
