import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String currentUserId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUserId() => _auth.currentUser!.uid;

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    this.currentUserId = _auth.currentUser!.uid;
  }
}
