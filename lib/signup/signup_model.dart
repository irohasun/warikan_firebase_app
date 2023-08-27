import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String uid = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final User? user = (await _auth.createUserWithEmailAndPassword(
            email: mail, password: password))
        .user;

    //uidをdocumentIdとしてusersに保存
    FirebaseFirestore.instance.collection('users').doc(user?.uid).set(
      {
        'email': mail,
        'createdAt': Timestamp.now(),
        'userId': user?.uid,
      },
    );
  }
}
