import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/domain/friend_domain.dart';
import 'package:flutter/cupertino.dart';

class AddFrinedModel extends ChangeNotifier {
  String friendEvent = '';
  String friendName = '';
  bool isLoading = false;

  startLoading() {
    isLoading = true;
  }

  endLoading() {
    isLoading = false;
  }

  Future addFriendtoFirebase() async {
    if (friendName.isEmpty) {
      throw ('名前を入力してください!');
    }
    await FirebaseFirestore.instance.collection('friends').add(
      {
        'createdAt': Timestamp.now(),
        'name': friendName,
      },
    );
  }

  Future updatefriend(FriendDomain friend) async {
    final document =
        FirebaseFirestore.instance.collection('friends').doc(friend.documentID);
    await document.update(
      {
        'updateAt': Timestamp.now(),
        'name': friendName,
      },
    );
  }
}
