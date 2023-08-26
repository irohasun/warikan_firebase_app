import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/domain/payment_domain.dart';
import 'package:firebase_todo_app/login/login_model.dart';
import 'package:flutter/cupertino.dart';

class PaymentListModel extends ChangeNotifier {
  List<PaymentDomain> payments = [];
  String sumAllPayment = '0';
  bool isLoading = false;
  String currentUserId = LoginModel().getCurrentUserId();

  startLoading() {
    isLoading = true;
  }

  endLoading() {
    isLoading = false;
  }

  Future fetchPayments() async {
    final documents = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('payments')
        .get();
    final payments = documents.docs.map((doc) => PaymentDomain(doc)).toList();
    this.payments = payments;
    notifyListeners();
  }

  Future deletePayment(PaymentDomain payment) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('payments')
        .doc(payment.documentID)
        .delete();
  }

  // 支払いの全合計金額を取得する
  Future sumAllPayments() async {
    startLoading();
    final documents = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('payments')
        .get();
    final payments1 = documents.docs.map((doc) => PaymentDomain(doc)).toList();
    if (payments1.isEmpty) {
      this.sumAllPayment = '0';
      notifyListeners();
    } else {
      final payments2 = payments1.map((e) => (int.parse(e.money))).toList();
      final sumAllPayment = payments2.reduce((a, b) => a + b).toString();
      this.sumAllPayment = sumAllPayment;
      notifyListeners();
    }
    endLoading();
  }
}
