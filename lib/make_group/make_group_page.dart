import 'package:firebase_todo_app/domain/friend_domain.dart';
import 'package:firebase_todo_app/domain/group_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'make_group_model.dart';

class MakeGroupPage extends StatelessWidget {
  final GroupDomain group;
  final FriendDomain friend;

  MakeGroupPage({this.group, this.friend});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MakeGroupModel>(
      create: (_) => MakeGroupModel(),
      child: Scaffold(
        body: Consumer<MakeGroupModel>(
          builder: (context, model, child) {
            final TextEditingController groupTextController =
                TextEditingController();
            final TextEditingController friendTextController =
                TextEditingController();
            final bool isUpdate = friend != null;

            if (isUpdate) {
              friendTextController.text = friend.name;
            }

            return Column(
              children: <Widget>[
                //グループ名
                _buildGroupTextField(model, groupTextController),

                // メンバー名
                _buildMemberTextField(model, friendTextController, context),

                SizedBox(height: 16.0),

                _buildAddedMembers(model),

                _buildAddButton(model, context, isUpdate),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGroupTextField(
      MakeGroupModel model, TextEditingController groupTextController) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 8.0),
      Text(
        "グループ名",
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          hintText: "タイ旅行",
        ),
        controller: groupTextController,
        onChanged: (text) {
          model.friendName = text;
          print("First text field: $text");
        },
      ),
    ]);
  }

  Widget _buildMemberTextField(MakeGroupModel model,
      TextEditingController friendTextController, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("メンバー名"),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: "たかし"),
                controller: friendTextController,
                onChanged: (text) {
                  model.friendName = text;
                  print("First text field: $text");
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<MakeGroupModel>(context, listen: false)
                    .addText(friendTextController.text);
                friendTextController.clear();
              },
              child: Text('追加'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddedMembers(MakeGroupModel model) {
    return Consumer<MakeGroupModel>(builder: (context, model, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: model.texts.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            return InkWell(
              onTap: () {
                model.removeText(index);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Text(text),
                    SizedBox(width: 4.0),
                    Text(
                      'x',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildAddButton(
      MakeGroupModel model, BuildContext context, bool isUpdate) {
    return ElevatedButton(
      onPressed: !model.isLoading
          ? () async {
              model.startLoading();
              if (isUpdate) {
                await updateFriend(model, context);
              } else {
                await addFriend(model, context);
              }
              model.endLoading();
            }
          : null,
      child: Text('グループを作成',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
      ),
    );
  }

  Future addFriend(MakeGroupModel model, BuildContext context) async {
    try {
      await model.addFriendToFirebase();
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('追加しました！'),
                  ),
                  actions: <Widget>[
                    TextButton(
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
                    TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text('OK')),
                  ]));
    }
  }

  Future updateFriend(MakeGroupModel model, BuildContext context) async {
    try {
      await model.updateFriend(friend);
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('更新しました！'),
                  ),
                  actions: <Widget>[
                    TextButton(
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
            TextButton(
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
