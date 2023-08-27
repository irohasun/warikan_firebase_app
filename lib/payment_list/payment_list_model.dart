import 'package:warikan_firebase_app/domain/group_domain.dart';
import 'package:warikan_firebase_app/domain/payment_domain.dart';

import '../../lib/base_model.dart';

class PaymentListModel extends BaseModel {
  PaymentListModel(this.group);

  Group group;
  Payment? payment;
  List<Map<String, dynamic>> settlementMethods = [];

  void addPaymentRecord(Payment result) {
    group.paymentRecords!.add(result);
    notifyListeners();
  }

  void updatePayment(int index, Payment result) {
    group.paymentRecords![index] = result;
    notifyListeners();
  }

  void removePaymentRecord(paymentRecord) {
    group.paymentRecords!.remove(paymentRecord);
    notifyListeners();
  }

  void updateGroup(Group updateGroup) {
    group.name = updateGroup.name;
    group.members = updateGroup.members;
    notifyListeners();
  }

  int calcAllPaymentAmount(paymentRecords) {
    int allPaymentAmount = 0;
    for (payment in paymentRecords) {
      allPaymentAmount += payment!.amount!;
    }
    return allPaymentAmount;
  }

  int calcAveragePaymentAmount(paymentRecords) {
    final allPayment = calcAllPaymentAmount(paymentRecords);
    final averagePayAmount = allPayment / group.members.length;

    return averagePayAmount.round();
  }

  Map<String, int> makePaidAmountMap() {
    Map<String, int> map = {};

    for (final member in group.members) {
      int allPayAmount = 0;
      map[member.name!] = 0;

      for (payment in group.paymentRecords!) {
        if (member.name == payment!.insteadMember) {
          allPayAmount += payment!.amount!;
          map[member.name!] = allPayAmount;
        } else {
          allPayAmount += 0;
          map[member.name!] = allPayAmount;
        }
      }
    }
    print("paidAmountMap${map}");
    return map; //{A: 1000, B: 1900, C: 500,D: 0}
  }

  Map<String, int> makeMustPayAmountMap() {
    Map<String, int> map = {};
    for (final member in group.members) {
      int allPaidAmount = 0;
      for (final payment in group.paymentRecords!) {
        for (final target in payment.targetMembers!) {
          if (member.name == target) {
            allPaidAmount +=
                (payment.amount! / payment.targetMembers!.length).round();
            map[member.name!] = allPaidAmount;
          } else {
            continue;
          }
        }
      }
    }
    print("mustPayAmountMap${map}");
    return map; //{A: 850, B: 1350, C: 1100, D: 100}
  }

  Map<String, int> makeNetPayMap() {
    final paidAmountMap = makePaidAmountMap();
    final mustPayAmountMap = makeMustPayAmountMap();
    Map<String, int> map = {};

    for (final member in group.members) {
      final paidAmount = paidAmountMap[member.name] ?? 0;
      final mustPayAmount = mustPayAmountMap[member.name] ?? 0;
      final netPayAmount = paidAmount - mustPayAmount;
      map[member.name!] = netPayAmount;
    }
    print("netPayMap${map}");
    return map; //{"A": 150, "B": 550, "C": -600, "D": -100}
  }

  void makeSettlementMethods() {
    final debts = makeNetPayMap();
    List<String> debtors = [];
    List<String> creditors = [];
    settlementMethods = [];

    // 債務者と債権者を分ける
    for (final entry in debts.entries) {
      if (entry.value < 0) {
        debtors.add(entry.key);
      } else if (entry.value > 0) {
        creditors.add(entry.key);
      }
    }

    // 債務者から債権者に金額を分配する
    while (debtors.isNotEmpty && creditors.isNotEmpty) {
      String debtor = debtors[0];
      String creditor = creditors[0];

      int debtorAmount = -debts[debtor]!;
      int creditorAmount = debts[creditor]!;

      if (debtorAmount <= creditorAmount) {
        settlementMethods
            .add({'from': debtor, 'to': creditor, 'amount': debtorAmount});

        debts[debtor] = 0;
        debts[creditor] = creditorAmount - debtorAmount;
        debtors.removeAt(0);
      } else {
        settlementMethods
            .add({'from': debtor, 'to': creditor, 'amount': creditorAmount});

        debts[debtor] = -(debtorAmount - creditorAmount);
        debts[creditor] = 0;
        creditors.removeAt(0);
      }
    }
    print("map${settlementMethods}");
    notifyListeners();
  }

// void addSettlementMethod(map) {
//   settlementMethods.add(map);
//   notifyListeners();
// }
}

// class Payment {
// Payment(
// {required this.id,
// required this.name,
// required this.amount,
// required this.insteadMember,
// required this.targetMembers});
//
// String id;
// String name;
// int amount;
// String insteadMember;
// Set<String> targetMembers;
// }
//
//
//
//
// Payment payment1 = Payment(id:"1",name:"支払い1",insteadMember:"A",targetMembers:<String>{"A","B"},amount: 1000);
// Payment payment2 = Payment(id:"2",name:"支払い2",insteadMember: "B",targetMembers: <String>{"B","C"},amount: 1500);
// Payment payment3 = Payment(id:"3",name:"支払い3",insteadMember: "C",targetMembers: <String>{"A","C"},amount: 500);
// Payment payment4 = Payment(id:"4",name:"支払い4",insteadMember: "B",targetMembers: <String>{"A","B","C","D"},amount: 400);
// List<String> members = ["A","B","C","D"];
// List<Payment> paymentRecordsDummy =[payment1,payment2,payment3,payment4];
//
// void makePaidAmountMap() {
// Map<String, int> map={};
//
// for (final member in members) {
// int allPaidAmount = 0;
// for (final payment in paymentRecordsDummy) {
// for(final target in payment.targetMembers){
// if (member == target) {
// allPaidAmount += (payment.amount/payment.targetMembers.length).round();
// map[member] = allPaidAmount;
// } else {
// continue;
// }
// }
//
// }
// }
// print(map);
// }
//
//
// void main() {
// makePaidAmountMap();
// }
