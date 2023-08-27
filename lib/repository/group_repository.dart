// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../domain/group_domain.dart';
//
// /// ユーザー関連の操作をまとめたクラス
// class GroupRepository {
//   final _db = FirebaseFirestore.instance;
//   final _collectionPath = 'groups';
//
//   // User _toEntity(DocumentSnapshot doc) {
//   //   DateTime? _toDate(dynamic value) =>
//   //       value is Timestamp ? value.toDate() : null;
//   //
//   //   final data = Map<String, dynamic>.from(doc.data());
//   //   return User(
//   //     id: doc.id,
//   //     name: data[UserField.name].toString(),
//   //     createdAt: _toDate(data[UserField.createdAt]),
//   //     updatedAt: _toDate(data[UserField.updatedAt]),
//   //   );
//   // }
//
//   Map<String, dynamic> _toMap(Group group) {
//     return <String, dynamic>{
//       GroupField.id: group.id,
//       GroupField.name: group.name,
//       GroupField.members: group.members,
//       GroupField.createdAt: Timestamp.fromDate(group.createdAt),
//       GroupField.updatedAt: Timestamp.fromDate(group.updatedAt),
//     };
//   }
//
// //  ユーザを取得する
// //  [uid]はFirebaseUser.uidと同じ
// //   Future<User> fetchUser(String uid) async {
// //     if (uid == null) {
// //       return null;
// //     }
// //     try {
// //       final userDoc = await _db.collection(_collectionPath).doc(uid).get();
// //
// //       return _toEntity(userDoc);
// //     } catch (e) {
// //       Logger().e(e.toString());
// //     }
// //     return null;
// //   }
//
//   /// FireStoreにdocumentIDを指定して追加 or 更新する（指定フィールド以外が存在したらそのまま保持する）
//   Future putGroup(Group group) async {
//     if (group.id == null) {
//       return;
//     }
//     await _db.collection(_collectionPath).doc(group.id).set(
//           _toMap(group),
//           SetOptions(merge: true),
//         );
//   }
// }
