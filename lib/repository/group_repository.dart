import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warikan_firebase_app/repository/payment_repository.dart';

import '../domain/group_domain.dart';
import '../domain/payment_domain.dart';

/// ユーザー関連の操作をまとめたクラス
class GroupRepository {
  final _db = FirebaseFirestore.instance;
  final _collectionPath = 'groups';

  Group _toEntity(DocumentSnapshot doc) {
    DateTime? _toDate(dynamic value) =>
        value is Timestamp ? value.toDate() : null;

    final data = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
    return Group(
      uid: data[GroupField.uid].toString(),
      id: data[GroupField.id].toString(),
      name: data[GroupField.name].toString(),
      members: _toEntityForMembers(data[GroupField.members]),
      paymentRecords: _toEntityForPayment(data[GroupField.paymentRecords]),
      createdAt: _toDate(data[GroupField.createdAt]),
      updatedAt: _toDate(data[GroupField.updatedAt]),
    );
  }

  List<Payment> _toEntityForPayment(dynamic paymentData) {
    List<Payment> tmp = [];
    for (final payData in paymentData) {
      tmp.add(PaymentRepository().toEntity(payData));
    }

    return tmp;
  }

  List<String> _toEntityForMembers(dynamic membersData) {
    List<String> tmp = [];
    for (final memData in membersData) {
      tmp.add(memData.toString());
    }

    return tmp;
  }

  List<dynamic> _toPaymentMapList(Group group) {
    final tmp = group.paymentRecords
        .map((payment) => PaymentRepository().toMap(payment))
        .toList();
    return tmp;
  }

  Map<String, dynamic> _toMap(Group group) {
    return <String, dynamic>{
      GroupField.uid: group.uid,
      GroupField.id: group.id,
      GroupField.name: group.name,
      GroupField.members: group.members,
      GroupField.paymentRecords: _toPaymentMapList(group),
      GroupField.createdAt: Timestamp.fromDate(group.createdAt!),
      GroupField.updatedAt: Timestamp.fromDate(group.updatedAt!),
    };
  }

// ユーザを取得する
// [uid]はFirebaseUser.uidと同じ
  Future<List<Group>> fetchGroups(String uid) async {
    List<Group> tmp;
    final collectionRef = _db.collection(_collectionPath);
    final snapshot = await collectionRef.where("uid", isEqualTo: uid).get();

    if (snapshot != null) {
      tmp = await snapshot.docs.map(_toEntity).toList();
      return tmp;
    } else {
      return [];
    }
  }

// FireStoreにdocumentIDを指定して追加 or 更新する（指定フィールド以外が存在したらそのまま保持する）
  Future addGroup(Group group) async {
    final ref = _db.collection(_collectionPath).doc();
    final groupForAdd = Group(
        uid: group.uid,
        id: ref.id,
        name: group.name,
        members: group.members,
        paymentRecords: group.paymentRecords,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    await ref.set(
      _toMap(groupForAdd),
      SetOptions(merge: true),
    );
    return groupForAdd;
  }

  Future<void> makeGroupForUpdatePayment(Payment payment, Group group) async {
    group.paymentRecords.add(payment);
  }

  Future<Group> updateGroup(Group group) async {
    final ref = _db.collection(_collectionPath).doc(group.id);
    final groupForUpdate = Group(
        uid: group.uid,
        id: group.id,
        name: group.name,
        members: group.members,
        paymentRecords: group.paymentRecords,
        createdAt: group.createdAt,
        updatedAt: DateTime.now());

    await ref.set(
      _toMap(groupForUpdate),
      SetOptions(merge: true),
    );
    return groupForUpdate;
  }
}
