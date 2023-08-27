import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../lib/add_payment/add_payment_page.dart';
import '../../lib/domain/group_domain.dart';
import '../../lib/make_group/make_group_page.dart';
import 'payment_list_model.dart';

class PaymentListPage extends StatelessWidget {
  final Group group;

  PaymentListPage(this.group);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentListModel(group),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Tabikan'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<PaymentListModel>(builder: (context, model, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildText(model.group.name),
                  SizedBox(height: 8),
                  _buildText(
                      '${model.group.members.map((member) => member.name).toList()}'),
                  SizedBox(height: 16),
                  addPaymentRecordsButton(context, model),
                  SizedBox(height: 16),
                  _buildPaymentRecords(model),
                  SizedBox(height: 16),
                  _buildText('清算方法'),
                  SizedBox(height: 8),
                  _buildSettlementMethods(model),
                  SizedBox(height: 16),
                  // _buildActions(),
                  SizedBox(height: 16),
                  _buildEditGroupButton(context, model)
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget addPaymentRecordsButton(context, model) {
    return ElevatedButton(
      onPressed: () async {
        Map<String, dynamic>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPaymentPage(model.group),
          ),
        );
        if (result != null) {
          model.payment = result["payment"];
          model.addPaymentRecord(result["payment"]);
          model.makeSettlementMethods();
        } else {}
      },
      child: Text('立て替え記録を追加'),
    );
  }

  Widget _buildPaymentRecords(PaymentListModel model) {
    return Consumer<PaymentListModel>(
      builder: (context, model, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (model.group.paymentRecords)?.length,
          itemBuilder: (context, index) {
            final payment = model.group.paymentRecords?[index];
            return ListTile(
              title: Text(payment!.name!),
              subtitle: Text(
                "${(payment.insteadMember)}が立て替え",
              ),
              trailing: SizedBox(
                width: 100, // 適切な幅を設定してください
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("￥${payment.amount}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        Map<String, dynamic>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPaymentPage(model.group, payment: payment),
                          ),
                        );
                        if (result != null && result["isDelete"] == false) {
                          model.updatePayment(index, result["payment"]);
                          model.makeSettlementMethods();
                        } else if (result != null &&
                            result["isDelete"] == true) {
                          model.removePaymentRecord(result["payment"]);
                          model.makeSettlementMethods();
                        } else {}
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettlementMethods(PaymentListModel model) {
    return Consumer<PaymentListModel>(
      builder: (context, model, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (model.settlementMethods).length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? method = model.settlementMethods[index];
            return ListTile(
              title: Text("${method["from"]} から ${method["to"]} へ"),
              trailing: Text("￥${method["amount"]}"),
            );
          },
        );
      },
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () {},
          child: Text('URLをコピー'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: Text('LINEでシェア'),
        ),
      ],
    );
  }
}

Widget _buildEditGroupButton(context, model) {
  return ElevatedButton(
    onPressed: () async {
      Group? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MakeGroupPage(group: model.group),
        ),
      );
      if (result != null) {
        model.updateGroup(result);
      }
    },
    child: Text('グループ編集'),
  );
}
