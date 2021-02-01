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

  static Future createInvoice(
    String _amount,
    String _fee,
    String _purpose,
    String _payableUserID,
    String _receivableUserID,
  ) async {
    DateTime _invoiceDate = DateTime.now();

    //Add to general invoices ledger
    DocumentReference document =
        await FirebaseFirestore.instance.collection("Invoices").add({
      'Amount': _amount.toString(),
      'Fee': _fee.toString(),
      'InvoiceDate': _invoiceDate.toString(),
      'Purpose': _purpose.toString(),
      'ReceivableUserID': _receivableUserID.toString(),
      'SettlementDate': '',
      'PayableUserID': _payableUserID.toString(),
      'Status': 'Active',
    }).catchError((e) {
      return null;
    });

    if (document != null) {
      //Add to specific payable user's transactions
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_payableUserID.toString())
          .collection("Invoices")
          .doc(document.id)
          .set({
        'Amount': _amount.toString(),
        'Fee': _fee.toString(),
        'InvoiceDate': _invoiceDate.toString(),
        'Purpose': _purpose.toString(),
        'ReceivableUserID': _receivableUserID.toString(),
        'SettlementDate': '',
        'PayableUserID': _payableUserID.toString(),
        'Status': 'Active',
      });

      //Add to specific receivable user's transactions
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_receivableUserID.toString())
          .collection("Invoices")
          .doc(document.id)
          .set({
        'Amount': _amount.toString(),
        'Fee': _fee.toString(),
        'InvoiceDate': _invoiceDate.toString(),
        'Purpose': _purpose.toString(),
        'ReceivableUserID': _receivableUserID.toString(),
        'SettlementDate': '',
        'PayableUserID': _payableUserID.toString(),
        'Status': 'Active',
      });
    }
    return document;
  }

  static Future<bool> payInvoice(
    String id,
    String _amount,
    String _fee,
    String _purpose,
    String _payableUserID,
    String _receivableUserID,
    String _settlementDate,
    String _status,
  ) async {
    bool _paid = true;

    await FirebaseFirestore.instance.collection("Invoices").doc(id).update({
      'Amount': _amount.toString(),
      'Fee': _fee.toString(),
      'Purpose': _purpose.toString(),
      'PayableUserID': _payableUserID.toString(),
      'ReceivableUserID': _receivableUserID.toString(),
      'SettlementDate': _settlementDate.toString(),
      'Status': _status.toString(),
    }).catchError((e) {
      _paid = false;
    });

    if (_paid) {
      //Update specific payable user's transactions
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_payableUserID)
          .collection("Invoices")
          .doc(id)
          .update({
        'Amount': _amount.toString(),
        'Fee': _fee.toString(),
        'Purpose': _purpose.toString(),
        'PayableUserID': _payableUserID.toString(),
        'ReceivableUserID': _receivableUserID.toString(),
        'SettlementDate': _settlementDate.toString(),
        'Status': _status.toString(),
      }).catchError((e) {
        _paid = false;
      });
    }

    if (_paid) {
      //Update specific receivable user's transactions
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_receivableUserID)
          .collection("Invoices")
          .doc(id)
          .update({
        'Amount': _amount.toString(),
        'Fee': _fee.toString(),
        'Purpose': _purpose.toString(),
        'PayableUserID': _payableUserID.toString(),
        'ReceivableUserID': _receivableUserID.toString(),
        'SettlementDate': _settlementDate.toString(),
        'Status': _status.toString(),
      }).catchError((e) {
        _paid = false;
      });
    }

    return _paid;
  }

  static Future<bool> deactivateInvoice(
      String id, String payableUserID, String receivableUserID) async {
    bool _deleted = true;
    await FirebaseFirestore.instance
        .collection("Invoices")
        .doc(id)
        .update({"Status": "Deleted"}).catchError((e) {
      _deleted = false;
    });

    if (_deleted) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(payableUserID)
          .collection("Invoices")
          .doc(id)
          .update({"Status": "Deleted"}).catchError((e) {
        _deleted = false;
      });

      if (_deleted) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(receivableUserID)
            .collection("Invoices")
            .doc(id)
            .update({"Status": "Deleted"}).catchError((e) {
          _deleted = false;
        });
      }
    }

    return _deleted;
  }

  static Future<bool> declineInvoice(String id) async {
    bool _declined = true;
    await FirebaseFirestore.instance
        .collection("Invoices")
        .doc(id)
        .update({"Status": "Declined"}).catchError((e) {
      _declined = false;
    });

    return _declined;
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
