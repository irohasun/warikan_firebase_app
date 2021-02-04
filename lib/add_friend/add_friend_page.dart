import 'package:firebase_todo_app/domain/friend_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_friend_model.dart';

class AddFriendDialog extends StatelessWidget {
  final FriendDomain friend;

  //this.bookを{}で囲むと必須ではなくなる
  AddFriendDialog({this.friend});

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = friend != null;
    final TextEditingController textController = TextEditingController();

    if (isUpdate) {
      textController.text = friend.name;
    }

    bool isEnable = true;

    return ChangeNotifierProvider<AddFrinedModel>(
        create: (_) => AddFrinedModel(),
        child: Consumer<AddFrinedModel>(builder: (context, model, child) {
          return Column(children: <Widget>[
            AlertDialog(
                title: Center(
                  child: Text('新たな友達を追加'),
                ),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          icon: Icon(Icons.person),
                          labelText: "友達",
                        ),
                        controller: textController,
                        onChanged: (text) {
                          model.friendName = text;
                          print("First text field: $text");
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text('Cancel')),
                  FlatButton(
                      onPressed: !isEnable
                          ? null
                          : () async {
                              model.startLoading();
                              if (isUpdate) {
                                await updateFrined(model, context);
                              } else {
                                await addFriend(model, context);
                              }
                              model.endLoading();
                            },
                      child: Text('追加',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )))
                ])
          ]);
        }));
  }

  Future addFriend(AddFrinedModel model, BuildContext context) async {
    try {
      await model.addFriendtoFirebase();
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('追加しました！'),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text('OK')),
                  ]));
      Navigator.of(context).pop();
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
                  ]));
    }
  }

  Future updateFrined(AddFrinedModel model, BuildContext context) async {
    try {
      await model.updatefriend(friend);
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('更新しました！'),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
      Navigator.of(context).pop();
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Center(
            child: Text(e.toString()),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
