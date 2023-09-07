import 'package:warikan_firebase_app/domain/group_domain.dart';
import 'package:warikan_firebase_app/domain/payment_domain.dart';

import '../base_model.dart';

class PaymentListModel extends BaseModel {
  PaymentListModel(this.group);

  Group group;
  Payment? payment;
  List<Map<String, dynamic>> settlementMethods = [];

  Future init() async {
    makeSettlementMethods();
  }

  void addPaymentRecord(Payment result) {
    group.paymentRecords.add(result);
    notifyListeners();
  }

  void updatePayment(int index, Payment result) {
    group.paymentRecords[index] = result;
    notifyListeners();
  }

  void removePaymentRecord(paymentRecord) {
    group.paymentRecords.remove(paymentRecord);
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
      map[member] = 0;

      for (payment in group.paymentRecords) {
        if (member == payment!.insteadMember) {
          allPayAmount += payment!.amount!;
          map[member] = allPayAmount;
        } else {
          allPayAmount += 0;
          map[member] = allPayAmount;
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
      for (final payment in group.paymentRecords) {
        for (final target in payment.targetMembers!) {
          if (member == target) {
            allPaidAmount +=
                (payment.amount! / payment.targetMembers!.length).round();
            map[member] = allPaidAmount;
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
      final paidAmount = paidAmountMap[member] ?? 0;
      final mustPayAmount = mustPayAmountMap[member] ?? 0;
      final netPayAmount = paidAmount - mustPayAmount;
      map[member] = netPayAmount;
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
}
