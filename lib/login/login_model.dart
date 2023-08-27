import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String currentUserId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUserId() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUserId = _auth.currentUser!.uid;
    return currentUserId;
  }

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final result = await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    this.currentUserId = _auth.currentUser!.uid;
  }
}
