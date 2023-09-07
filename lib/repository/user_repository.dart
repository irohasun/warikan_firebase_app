import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_domain.dart';

/// ユーザー関連の操作をまとめたクラス
class UserRepository {
  final _db = FirebaseFirestore.instance;
  final _collectionPath = 'users';


  // User _toEntity(DocumentSnapshot doc) {
  //   DateTime? _toDate(dynamic value) =>
  //       value is Timestamp ? value.toDate() : null;
  //
  //   final data = Map<String, dynamic>.from(doc.data());
  //   return User(
  //     id: doc.id,
  //     name: data[UserField.name].toString(),
  //     createdAt: _toDate(data[UserField.createdAt]),
  //     updatedAt: _toDate(data[UserField.updatedAt]),
  //   );
  // }

  Map<String, dynamic> _toMap(User user) {
    return <String, dynamic>{
      UserField.id: user.id,
      UserField.name: user.name,
      UserField.createdAt: Timestamp.fromDate(user.createdAt),
      UserField.updatedAt: Timestamp.fromDate(user.updatedAt),
    };
  }

  /// ユーザを取得する
  /// [uid]はFirebaseUser.uidと同じ
  // Future<User> fetchUser(String uid) async {
  //   if (uid == null) {
  //     return null;
  //   }
  //   try {
  //     final userDoc = await _db.collection(_collectionPath).doc(uid).get();
  //
  //     return _toEntity(userDoc);
  //   } catch (e) {
  //     Logger().e(e.toString());
  //   }
  //   return null;
  // }

  /// FirestoreにdocumentIDを指定して追加 or 更新する（指定フィールド以外が存在したらそのまま保持する）
  Future putUser(User user) async {
    if (user.id == null) {
      return;
    }
    await _db.collection(_collectionPath).doc(user.id).set(
          _toMap(user),
          SetOptions(merge: true),
        );
  }
}
