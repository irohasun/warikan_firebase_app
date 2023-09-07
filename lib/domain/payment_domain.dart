class PaymentField {
  static const gid = 'uid';
  static const id = 'id';
  static const name = 'name';
  static const amount = 'amount';
  static const insteadMember = 'insteadMember';
  static const targetMembers = 'targetMembers';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class Payment {
  Payment(
      {this.gid,
      this.id,
      this.name,
      this.amount,
      this.insteadMember,
      this.targetMembers,
      this.createdAt,
      this.updatedAt});

  String? gid = '';
  String? id = '';
  String? name = '';
  int? amount = 0;
  String? insteadMember = '';
  Set<String>? targetMembers = {};
  DateTime? createdAt;
  DateTime? updatedAt;
}
