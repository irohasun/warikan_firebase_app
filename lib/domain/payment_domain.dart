import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDomain {
  PaymentDomain(DocumentSnapshot doc) {
    documentID = doc.id;
    name = doc['name'];
    money = doc['money'];
    event = doc['event'];
  }
  String name;
  String money;
  String event;
  String documentID;
}
