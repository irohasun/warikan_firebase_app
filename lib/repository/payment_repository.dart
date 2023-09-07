import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warikan_firebase_app/domain/payment_domain.dart';

import '../domain/group_domain.dart';

/// Paymentのデータ関連の操作をまとめたクラス
class PaymentRepository {
  final _db = FirebaseFirestore.instance;
  final _collectionPath = 'payments';

  Payment toEntity(dynamic data) {
    DateTime? _toDate(dynamic value) =>
        value is Timestamp ? value.toDate() : null;

    return Payment(
      gid: data[PaymentField.gid].toString(),
      id: data[PaymentField.id].toString(),
      name: data[PaymentField.name].toString(),
      amount: data[PaymentField.amount],
      insteadMember: data[PaymentField.insteadMember].toString(),
      targetMembers: _toSetForTargetMember(data[PaymentField.targetMembers]),
      createdAt: _toDate(data[PaymentField.createdAt]),
      updatedAt: _toDate(data[PaymentField.updatedAt]),
    );
  }

  Set<String> _toSetForTargetMember(dynamic data) {
    final tmp = <String>{};
    for (final tarMem in data) {
      tmp.add(tarMem.toString());
    }
    return tmp;
  }

  Map<String, dynamic> toMap(Payment payment) {
    return <String, dynamic>{
      PaymentField.gid: payment.gid,
      PaymentField.id: payment.id,
      PaymentField.name: payment.name,
      PaymentField.amount: payment.amount,
      PaymentField.insteadMember: payment.insteadMember,
      PaymentField.targetMembers: payment.targetMembers,
      PaymentField.createdAt: Timestamp.fromDate(payment.createdAt!),
      PaymentField.updatedAt: Timestamp.fromDate(payment.updatedAt!),
    };
  }

  Future<Payment> fetchPayments(String gid) async {
    final groupDoc = await _db.collection(_collectionPath).doc(gid).get();

    return toEntity(groupDoc);
  }

  // FireStoreにdocumentIDを指定して追加 or 更新する（指定フィールド以外が存在したらそのまま保持する）
  Future addPayment(Payment payment, Group group) async {
    final ref = _db.collection(_collectionPath).doc();
    final paymentForAdd = Payment(
        gid: payment.gid,
        id: ref.id,
        name: payment.name,
        amount: payment.amount,
        insteadMember: payment.insteadMember,
        targetMembers: payment.targetMembers,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    await ref.set(
      toMap(paymentForAdd),
      SetOptions(merge: true),
    );
    return paymentForAdd;
  }

  Future updatePayment(Payment payment, Group group) async {
    final ref = _db.collection(_collectionPath).doc(payment.id);
    final paymentForUpdate = Payment(
        gid: payment.gid,
        id: payment.id,
        name: payment.name,
        amount: payment.amount,
        insteadMember: payment.insteadMember,
        targetMembers: payment.targetMembers,
        createdAt: payment.createdAt,
        updatedAt: DateTime.now());

    await ref.set(
      toMap(paymentForUpdate),
      SetOptions(merge: true),
    );
    return paymentForUpdate;
    ;
  }

  Future deletePayment(Payment payment) async {
    final ref = _db.collection(_collectionPath).doc(payment.id);
    await ref.delete();
  }
}
