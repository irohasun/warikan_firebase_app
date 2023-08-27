import 'package:flutter/material.dart';

import '../base_model.dart';
import '../domain/group_domain.dart';
import '../domain/payment_domain.dart';

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
        insteadMember: group.members[0].name,
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

  void registerPayment() {
// Firebaseを使って支払い情報を登録する処理を追加してください。
//     payment = Payment(
//         name: paymentName,
//         amount: paymentAmount,
//         insteadMember:
//         targetMembers: );
  }
}
