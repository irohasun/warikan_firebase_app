import 'package:warikan_firebase_app/domain/payment_domain.dart';

class GroupField {
  static const uid = 'uid';
  static const id = 'id';
  static const name = 'name';
  static const members = 'members';
  static const paymentRecords = 'paymentRecords';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class Group {
  Group(
      {this.uid,
      this.id,
      required this.name,
      required this.members,
      required this.paymentRecords,
      this.createdAt,
      this.updatedAt});

  String? uid = '';
  String? id = '';
  String name = '';
  List<String> members = [];
  List<Payment> paymentRecords = [];
  DateTime? createdAt;
  DateTime? updatedAt;
}
