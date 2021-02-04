import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/domain/friend_domain.dart';
import 'package:firebase_todo_app/domain/payment_domain.dart';
import 'package:flutter/material.dart';

class FriendListModel extends ChangeNotifier {
  List<FriendDomain> friends = [];
  List<int> friendPaymentList = [];

  Map<String, String> friendPaymentMap = {};

  Future fetchFriends() async {
    final documents =
        await FirebaseFirestore.instance.collection('friends').get();
    final friends = documents.docs.map((doc) => FriendDomain(doc)).toList();
    this.friends = friends;
    notifyListeners();
  }

  Future deleteFriend(FriendDomain friend) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(friend.documentID)
        .delete();
  }

  //友達一人当たりの支払金額を取得する
  Future getFriendPayment(FriendDomain friend) async {
    String sumFriendPayment = '';
    final documents = await FirebaseFirestore.instance
        .collection('payments')
        .where('name', isEqualTo: friend.name)
        .get();
    final payments1 = documents.docs.map((doc) => PaymentDomain(doc)).toList();
    if (payments1.isEmpty) {
      sumFriendPayment = '0';
      return sumFriendPayment;
    } else {
      final payments2 = payments1.map((e) => (int.parse(e.money))).toList();
      final sumFriendPayment = payments2.reduce((a, b) => a + b).toString();
      return sumFriendPayment;
    }
  }
}
