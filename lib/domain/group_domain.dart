import 'package:warikan_firebase_app/domain/member_domain.dart';
import 'package:warikan_firebase_app/domain/payment_domain.dart';

class GroupField {
  static const id = 'id';
  static const name = 'name';
  static const members = 'members';
// static const createdAt = 'createdAt';
// static const updatedAt = 'updatedAt';
}

class Group {
  Group({
    this.id,
    required this.name,
    required this.members,
    required this.paymentRecords,
  });

  String? id = '';
  String name = '';
  List<Member> members = [];
  List<Payment>? paymentRecords = [];
}

// class Group {
//   Group(
//       {this.id,
//         required this.name,
//         required this.members,
//         this.paymentRecords,
//         required this.createdAt,
//         required this.updatedAt});
//
//   String? id = '';
//   String name = '';
//   List<Member> members = [];
//   List<Payment>? paymentRecords = [];
//   DateTime createdAt;
//   DateTime updatedAt;
// }
