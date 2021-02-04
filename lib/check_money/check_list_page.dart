import 'package:firebase_todo_app/add_payment/add_payment_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'check_list_model.dart';

class CheckListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckListModel>(
        create: (_) => CheckListModel(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('割り勘計算'),
            ),
            body: Center(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '合計金額：円',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '合計人数：人',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '一人当たり：円',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    color: Colors.orange,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: <Widget>[
                        ListTile(),
                        Divider(),
                      ]);
                    },
                    itemCount: 5,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
