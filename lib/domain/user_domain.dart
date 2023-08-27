class UserField {
  static const id = 'id';
  static const name = 'name';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class User {
  User(this.id, this.name,this.createdAt,this.updatedAt);

  String? id = '';
  String name = '';
  DateTime createdAt;
  DateTime updatedAt;

}
