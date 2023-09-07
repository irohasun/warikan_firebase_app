import 'package:flutter/material.dart';
import 'package:warikan_firebase_app/repository/group_repository.dart';

import '../base_model.dart';
import '../domain/group_domain.dart';
import '../domain/payment_domain.dart';
import '../repository/payment_repository.dart';

class AddPaymentModel extends BaseModel {
  AddPaymentModel(this.group, {this.payment});

  Group group;
  Payment? payment;

  final TextEditingController paymentNameController = TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController();

  @override
  Future init() async {
    payment = Payment(
        name: '',
        amount: 0,
        insteadMember: group.members[0],
        targetMembers: {});
  }

  void selectPayer(String payer) {
    payment!.insteadMember = payer;
    notifyListeners();
  }

  void toggleMemberSelection(String memberName) {
    if (payment!.targetMembers!.contains(memberName)) {
      payment!.targetMembers!.remove(memberName);
    } else {
      payment!.targetMembers!.add(memberName);
    }
    notifyListeners();
  }

  Future registerPayment() async {
    startLoading();
    final paymentForAdd = await PaymentRepository().addPayment(
        Payment(
          gid: group.id,
          id: null,
          name: paymentNameController.text,
          amount: int.tryParse(paymentAmountController.text),
          insteadMember: payment!.insteadMember,
          targetMembers: payment!.targetMembers,
        ),
        group);
    payment = paymentForAdd;

    //GroupのPaymentRecordsにも追加する
    await GroupRepository().makeGroupForUpdatePayment(payment!, group);
    await GroupRepository().updateGroup(group);
  }

  Future updatePayment() async {
    startLoading();
    await PaymentRepository().updatePayment(payment!, group);

    //GroupのPaymentRecordsにをUpdateする
    await GroupRepository().updateGroup(group);
  }

  Future deletePayment() async {
    startLoading();
    await PaymentRepository().deletePayment(payment!);
    await GroupRepository().updateGroup(group);
  }
}
