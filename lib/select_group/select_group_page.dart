import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_firebase_app/select_group/select_group_model.dart';

import '../domain/group_domain.dart';
import '../make_group/make_group_page.dart';
import '../payment_list/payment_list_page.dart';

class SelectGroupPage extends StatelessWidget {
  SelectGroupPage({this.group});

  final Group? group;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectGroupModel>(
      create: (_) => SelectGroupModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text("グループ")),
        ),
        body: Consumer<SelectGroupModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildAddButton(context),
                      _buildGroupList(context, model),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      child: _buildSideBlueRoundedCard(
        child: Icon(
          Icons.add,
          color: Colors.blue,
          size: 48.0,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MakeGroupPage(),
          ),
        );
      },
    );
  }

  Widget _buildGroupList(BuildContext context, SelectGroupModel model) {
    final bool hasGroups = model.groups != null;
    return hasGroups
        ? Column(
            children: model.groups!
                .map(
                  (group) => InkWell(
                    child: _buildRoundedCard(
                      child: ListTile(
                        title: Text(group.name),
                        subtitle: Row(
                          children: _buildMemberList(group.members),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentListPage(group),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          )
        : Text("過去のグループはありません");
  }

  List<Widget> _buildMemberList(List<String> members) {
    return members.asMap().entries.map((entry) {
      final member = entry.value;
      final isLast = entry.key == members.length - 1;

      return Row(
        children: [
          Text(member),
          if (!isLast) Text('・'),
        ],
      );
    }).toList();
  }

  Widget _buildSideBlueRoundedCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.blue),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildRoundedCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
