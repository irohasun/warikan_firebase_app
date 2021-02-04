import 'package:firebase_todo_app/domain/payment_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_payment_model.dart';

class AddPaymentDialog extends StatelessWidget {
  final PaymentDomain payment;

  //this.paymentを{}で囲むと必須ではなくなる
  AddPaymentDialog({this.payment});

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = payment != null;
    TextEditingController _eventController = TextEditingController();
    TextEditingController _paymentController = TextEditingController();

    String selected;

    bool isEnable = true;

    return ChangeNotifierProvider<AddPaymentModel>(
      create: (_) => AddPaymentModel()..fetchPaymentNames(),
      child: Consumer<AddPaymentModel>(builder: (context, model, child) {
        final paymentNames = model.paymentNames;
        return Column(
          children: <Widget>[
            AlertDialog(
                title: Center(
                  child: Text('新たな支払いを追加'),
                ),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Form(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 300,
                              child: TextFormField(
                                onChanged: (text) {
                                  model.paymentEvent = text;
                                  print("First text field: $text");
                                  // buttonState();
                                },
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.event),
                                  labelText: "イベント",
                                ),
                                controller: _eventController,
                              ),
                            ),
                            TextFormField(
                              onChanged: (text) {
                                model.paymentMoney = text;
                                print("First text field: $text");
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                icon: Icon(Icons.money),
                                labelText: "金額",
                              ),
                              keyboardType: TextInputType.phone,
                              controller: _paymentController,
                            ),
                            DropdownButtonFormField<String>(
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              value: selected,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                icon: Icon(Icons.person),
                                labelText: '要選択',
                              ),
                              items: paymentNames
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                selected = value;
                                model.paymentName = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                        print(paymentNames);
                      },
                      child: Text('Cancel')),
                  FlatButton(
                    onPressed: !isEnable
                        ? null
                        : () async {
                            model.startLoading();
                            if (isUpdate) {
                              await updatePayment(model, context);
                            } else {
                              await addPayment(model, context);
                            }
                            model.endLoading();
                          },
                    child: Text(
                      '追加',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
          ],
        );
      }),
    );
  }

  Future addPayment(AddPaymentModel model, BuildContext context) async {
    try {
      await model.addPaymentToFirebase();
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

  Future updatePayment(AddPaymentModel model, BuildContext context) async {
    try {
      await model.updatepayment(payment);
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
