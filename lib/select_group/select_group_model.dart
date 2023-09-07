import 'package:warikan_firebase_app/repository/group_repository.dart';

import '../base_model.dart';
import '../domain/group_domain.dart';
import '../login/login_model.dart';

class SelectGroupModel extends BaseModel {
  SelectGroupModel({this.group, this.groups});

  final _uid = LoginModel().getCurrentUserId();
  Group? group;
  List<Group>? groups;

  @override
  Future init() async {
    await fetchGroups();
  }

  Future<void> fetchGroups() async {
    groups = await GroupRepository().fetchGroups(_uid);
    notifyListeners();
  }
}
