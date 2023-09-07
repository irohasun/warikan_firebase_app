import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_firebase_app/domain/group_domain.dart';
import 'package:warikan_firebase_app/payment_list/payment_list_page.dart';

import 'make_group_model.dart';

class MakeGroupPage extends StatelessWidget {
  MakeGroupPage({this.group});

  final Group? group;

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = group != null;

    return ChangeNotifierProvider<MakeGroupModel>(
      create: (_) => MakeGroupModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: Center(child: Text('Tabikan')),
        ),
        body: Consumer<MakeGroupModel>(
          builder: (context, model, child) {
            //更新時は初期値をmodelに代入する
            if (isUpdate) {
              model.groupTextController.text = group!.name;
              model.group = group;
            }

            return Column(
              children: <Widget>[
                _buildGroupTextField(model),
                _buildMemberTextField(model, context),
                SizedBox(height: 16.0),
                _buildAddedMembers(model),
                SizedBox(height: 16.0),
                isUpdate
                    ? _buildUpdateButton(model, context)
                    : _buildAddButton(model, context),
                SizedBox(height: 16.0),
                _buildReverseButton(model, context)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGroupTextField(MakeGroupModel model) {
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
        controller: model.groupTextController,
        onChanged: (text) {
          model.group!.name = text;
          print("First text field: $text");
        },
      ),
    ]);
  }

  Widget _buildMemberTextField(MakeGroupModel model, BuildContext context) {
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
                controller: model.memberTextController,
                onChanged: (text) {
                  model.member?.name = text;
                  print("First text field: $text");
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _addMember(model, context),
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
          children: model.group!.members.asMap().entries.map((entry) {
            int index = entry.key;
            String member = entry.value;
            return InkWell(
              onTap: () {
                if (model.group!.members.length <= 2) {
                  _showDialog(context, '警告', 'メンバーは最低2人以上必要です');
                } else {
                  if (model.isPossibleRemove(member)) {
                    model.removeMembersName(index);
                  } else {
                    _showDialog(context, '警告', 'すでに支払いに関連しているメンバーは削除できません');
                  }
                }
                ;
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Text(member),
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

  Widget _buildAddButton(MakeGroupModel model, BuildContext context) {
    return ElevatedButton(
      onPressed: !model.isLoading
          ? () async {
              if (model.group!.members.length < 2) {
                _showDialog(context, '警告', '2人以上メンバーを追加してください');
              } else {
                await model.registerGroup();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentListPage(
                      model.group!,
                    ),
                  ),
                );
              }
            }
          : null,
      child: Text(
        'グループを作成',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUpdateButton(MakeGroupModel model, BuildContext context) {
    return ElevatedButton(
      onPressed: !model.isLoading
          ? () async {
              await model.updateGroup();
              Navigator.pop(
                context,
                model.group,
              );
            }
          : null,
      child: Text(
        '更新',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReverseButton(MakeGroupModel model, BuildContext context) {
    return OutlinedButton(
      onPressed: !model.isLoading
          ? () async {
              Navigator.pop(context);
            }
          : null,
      child: Text(
        '戻る',
      ),
    );
  }

  Widget _buildBackButton(context, model) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      child: Text('戻る'),
    );
  }
}

void _showDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

void _addMember(MakeGroupModel model, BuildContext context) {
  String memberName = model.memberTextController.text;
  if (memberName != '') {
    bool nameExists =
        model.group!.members.any((member) => member == memberName);
    if (nameExists) {
      _showDialog(context, '警告', '同じ名前のメンバーが存在します');
    } else {
      Provider.of<MakeGroupModel>(context, listen: false)
          .addMembersName(memberName);
      model.memberTextController.clear();
    }
  } else {
    _showDialog(context, '警告', 'メンバー名を入力してください');
  }
}
