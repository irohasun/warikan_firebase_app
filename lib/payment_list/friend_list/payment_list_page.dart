import 'package:firebase_todo_app/add_payment/add_payment_dialog.dart';
import 'package:firebase_todo_app/check_money/check_list_page.dart';
import 'package:firebase_todo_app/domain/payment_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_list_model.dart';

class PaymentListPage extends StatelessWidget {
  final _isEnable = true;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentListModel>(
        create: (_) => PaymentListModel()
          ..sumAllPayments()
          ..fetchPayments(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('支払い一覧'),
          ),
          body: Consumer<PaymentListModel>(
            builder: (context, model, child) {
              final payments = model.payments;
              final listTiles = payments
                  .map(
                    (payment) => ListTile(
                      leading: Container(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(payment.name,
                              style: TextStyle(fontSize: 20.0)),
                        ),
                      ),
                      title: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            payment.event,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          )),
                      subtitle: Text(payment.money + '円',
                          style: TextStyle(fontSize: 20.0)),
                      trailing:
                          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                      onTap: () {},
                      onLongPress: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: Center(
                                      child: Text('${payment.name}削除しますか？'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel')),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deletePayment(
                                                model, context, payment);
                                          },
                                          child: Text('OK')),
                                    ]));
                      },
                    ),
                  )
                  .toList();
              return ListView(
                children: listTiles,
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                Consumer<PaymentListModel>(builder: (context, model, child) {
                  final sumPayment = model.sumAllPayment;
                  return Container(
                    width: 270,
                    child: Text(
                      '合計金額' + sumPayment + '円',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: '',
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: RaisedButton(
                    child: const Text(
                      '割り勘計算',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Colors.orange,
                    onPressed: !_isEnable
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckListPage()));
                          },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
              Consumer<PaymentListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AddPaymentDialog());
                await model.fetchPayments();
                await model.sumAllPayments();
              },
            );
          }),
        ));
  }

  Future deletePayment(PaymentListModel model, BuildContext context,
      PaymentDomain payment) async {
    try {
      await model.deletePayment(payment);
      await model.fetchPayments();
      await model.sumAllPayments();
      await _showDialog(context, '削除しました');
    } catch (e) {
      // _showDialog(context, e.toString());
    }
  }

  Future _showDialog(BuildContext context, String title) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Center(
                  child: Text(title),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: Text('OK')),
                ]));
  }
}
