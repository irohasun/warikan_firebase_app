import 'member_domain.dart';

class Payment {
  Payment(
      {this.id,
      this.name,
      this.amount,
      this.insteadMember,
      this.targetMembers});

  String? id = '';
  String? name = '';
  int? amount = 0;
  String? insteadMember = '';
  Set<String>? targetMembers = {};
}
