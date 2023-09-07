import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login_page.dart';
import 'signup_model.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: Center(child: Text('新規登録')),
        ),
        body: _buildSignUpForm(context),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Consumer<SignUpModel>(
      builder: (context, model, child) {
        return Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'example@gmail.com'),
              controller: emailController,
              onChanged: (text) {
                model.mail = text;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'password'),
              obscureText: true,
              controller: passwordController,
              onChanged: (text) {
                model.password = text;
              },
            ),
            ElevatedButton(
              child: Text('登録する', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                _handleSignUpButtonPressed(context, model);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignUpButtonPressed(
      BuildContext context, SignUpModel model) async {
    try {
      await model.signUp();
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text('登録完了しました！')),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text(errorMessage)),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
