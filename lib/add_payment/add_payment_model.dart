import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/domain/friend_domain.dart';
import 'package:firebase_todo_app/domain/payment_domain.dart';
import 'package:flutter/cupertino.dart';

class AddPaymentModel extends ChangeNotifier {
  String paymentEvent = '';
  String paymentName = '';
  String paymentMoney = '';
  bool isLoading = false;
  List<String> paymentNames = [];

  startLoading() {
    isLoading = true;
  }

  endLoading() {
    isLoading = false;
  }

  Future fetchPaymentNames() async {
    final documents =
        await FirebaseFirestore.instance.collection('friends').get();
    final friends1 = documents.docs.map((doc) => FriendDomain(doc)).toList();
    final friends2 = friends1.map((doc) => doc.name).toList();
    this.paymentNames = friends2;
    notifyListeners();
  }

  Future addPaymentToFirebase() async {
    if (paymentName.isEmpty) {
      throw ('名前を入力してください!');
    }
    await FirebaseFirestore.instance.collection('payments').add(
      {
        'createdAt': Timestamp.now(),
        'name': paymentName,
        'money': paymentMoney,
        'event': paymentEvent,
      },
    );
  }

  Future updatepayment(PaymentDomain payment) async {
    final document = FirebaseFirestore.instance
        .collection('payments')
        .doc(payment.documentID);
    await document.update(
      {
        'updateAt': Timestamp.now(),
        'name': paymentName,
        'money': paymentMoney,
        'event': paymentEvent,
      },
    );
  }
}
