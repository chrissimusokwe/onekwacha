import 'package:cloud_firestore/cloud_firestore.dart';

class InvoicingModel {
  final String amount;
  final String fee;
  final String invoiceDate;
  final String purpose;
  final String receivableUserID;
  final String settlementDate;
  final String status;
  final String payableUserID;

  InvoicingModel(
      {this.amount,
      this.fee,
      this.invoiceDate,
      this.purpose,
      this.receivableUserID,
      this.settlementDate,
      this.status,
      this.payableUserID});

  Map<String, dynamic> toMap() {
    return {
      "Amount": this.amount,
      "Fee": this.fee,
      "InvoiceDate": this.invoiceDate,
      "Purpose": this.purpose,
      "ReceivableUserID": this.receivableUserID,
      "SettlementDate": this.settlementDate,
      "PayableUserID": this.payableUserID,
      "Status": this.status
    };
  }

  static void createNewInvoice(
    String _amount,
    String _fee,
    String _purpose,
    String _receivableUserID,
    String _payableUserID,
  ) {
    InvoicingModel invoicingModel = new InvoicingModel();

    Future<void> addNewInvoices(final invoice) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection("Invoices")
          .add(invoice)
          .then((DocumentReference documentID) {
        //print(documentID);
      }).catchError((e) {
        //print(e);
      });
    }

    invoicingModel = InvoicingModel(
      amount: _amount,
      fee: _fee,
      invoiceDate: DateTime.now().toString(),
      purpose: _purpose,
      receivableUserID: _receivableUserID,
      payableUserID: _payableUserID,
      settlementDate: '',
      status: 'Active',
    );
    addNewInvoices(invoicingModel.toMap());
  }
}
