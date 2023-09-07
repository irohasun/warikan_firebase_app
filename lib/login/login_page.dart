import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_firebase_app/signup/signup_page.dart';

import '../select_group/select_group_page.dart';
import 'login_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Center(child: Text('ログイン')),
        ),
        body: _buildLoginForm(context, emailController, passwordController),
      ),
    );
  }

  Widget _buildLoginForm(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return Consumer<LoginModel>(
      builder: (context, model, child) {
        return Column(
          children: <Widget>[
            _buildTextField(emailController, 'example@gmail.com',
                (text) => model.mail = text),
            _buildTextField(
                passwordController, 'password', (text) => model.password = text,
                obscureText: true),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('ログイン', style: TextStyle(color: Colors.white)),
              onPressed: () => _handleLoginButtonPressed(context, model),
            ),
            TextButton(
              child: Text(
                '新規登録はこちら',
                style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      Function(String) onChanged,
      {bool obscureText = false}) {
    return TextField(
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }

  Future<void> _handleLoginButtonPressed(
      BuildContext context, LoginModel model) async {
    try {
      await model.login();
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text('ログイン完了しました！')),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectGroupPage()),
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
        title: Center(child: Text("メールアドレスもしくはパスワードが間違っています")),
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
