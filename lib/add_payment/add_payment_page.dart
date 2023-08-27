import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../domain/group_domain.dart';
import '../domain/member_domain.dart';
import '../domain/payment_domain.dart';
import 'add_payment_model.dart';

class AddPaymentPage extends StatelessWidget {
  AddPaymentPage(this.group, {this.payment});

  final Group group;
  final Payment? payment;

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = payment != null;

    return ChangeNotifierProvider<AddPaymentModel>(
      create: (_) => AddPaymentModel(group),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("支払いを追加"),
        ),
        body: Consumer<AddPaymentModel>(
          builder: (context, model, child) {
            //更新時は初期値をmodelの変数に代入する
            if (isUpdate) {
              model.paymentNameController.text = payment!.name!;
              model.paymentAmountController.text = payment!.amount.toString();
              model.payment = payment;
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("支払い者"),
                    Row(
                      children: [
                        _dropButtonMenu(context, model),
                        Text("が"),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    ..._buildCheckboxes(model),
                    SizedBox(height: 8.0),
                    _buildPaymentEventTextField(model),
                    SizedBox(height: 8.0),
                    _buildPaymentAmountTextField(model),
                    SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        children: [
                          _buildRegisterButton(model, context, isUpdate),
                          _buildCancelButton(context),
                          isUpdate
                              ? _buildDeleteButton(context, model)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dropButtonMenu(context, model) {
    print(
        "Members: ${model.group.members.map((m) => m.name).toList()}"); // Add this line
    print(
        "Instead Member Name: ${model.payment.insteadMember}"); // And this line
    // String dropdownValue = model.group.members[0].name;
    return DropdownButton<String>(
      value: model.payment.insteadMember,
      onChanged: (newValue) {
        model.selectPayer(newValue);
      },
      items: model.group.members.map<DropdownMenuItem<String>>(
        (Member? member) {
          return DropdownMenuItem<String>(
            value: member!.name,
            child: Text(member.name!),
          );
        },
      ).toList(),
    );
  }

  List<Widget> _buildCheckboxes(AddPaymentModel model) {
    return model.group.members.map<Widget>((member) {
      return Row(
        children: [
          Checkbox(
            value: model.payment!.targetMembers!.contains(member.name!),
            onChanged: (bool? value) {
              model.toggleMemberSelection(member.name!);
            },
          ),
          Text(member.name!),
        ],
      );
    }).toList();
  }

  Widget _buildPaymentEventTextField(AddPaymentModel model) {
    return Row(
      children: [
        Text("の"),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "支払いイベント",
            ),
            controller: model.paymentNameController,
            onChanged: (text) {
              model.payment!.name = text;
            },
          ),
        ),
        Text("を立て替えるため、"),
      ],
    );
  }

  Widget _buildPaymentAmountTextField(AddPaymentModel model) {
    return Row(
      children: [
        Text("¥"),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "支払額",
            ),
            controller: model.paymentAmountController,
            onChanged: (text) {
              model.payment!.amount = int.tryParse(text) ?? 0;
            },
          ),
        ),
        Text("を払った。"),
      ],
    );
  }

  Widget _buildRegisterButton(
      AddPaymentModel model, BuildContext context, bool isUpdate) {
    return ElevatedButton(
      onPressed: () {
        model.registerPayment();
        Navigator.pop(context, {"payment": model.payment!, "isDelete": false});
      },
      child: isUpdate ? Text('更新') : Text('登録'),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('戻る'),
    );
  }

  Widget _buildDeleteButton(BuildContext context, model) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(title: Text('本当に削除しますか？'), actions: <Widget>[
                  TextButton(
                    child: Text('はい'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context,
                          {"payment": model.payment, "isDelete": true});
                    },
                  ),
                  TextButton(
                    child: Text('いいえ'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
      },
      child: Text('削除'),
    );
  }
}
