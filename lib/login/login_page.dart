import 'package:firebase_todo_app/domain/book_domain.dart';
import 'package:firebase_todo_app/presentation/book_list/bookList_page.dart';
import 'package:firebase_todo_app/presentation/signup/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final BookDomain book;

  //this.bookを{}で囲むと必須ではなくなる
  LoginPage({this.book});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignUpModel>(
        create: (_) => SignUpModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('ログイン'),
          ),
          body: Consumer<SignUpModel>(builder: (context, model, child) {
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
                RaisedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        model.signUp();
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Center(
                              child: Text('ログイン完了しました！'),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookListPage(),
                                      ),
                                    );
                                  },
                                  child: Text('OK')),
                            ],
                          ),
                        );
                      } catch (e) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Center(
                              child: Text(e.toString()),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: Text('OK')),
                            ],
                          ),
                        );
                      }
                    })
              ],
            );
          }),
        ));
  }
}
