import 'package:cloud_firestore/cloud_firestore.dart';

class FriendDomain {
  FriendDomain(DocumentSnapshot doc) {
    documentID = doc.id;
    name = doc['name'];
  }
  String name;
  String documentID;
}
