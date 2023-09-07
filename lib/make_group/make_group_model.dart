import 'package:flutter/cupertino.dart';
import 'package:warikan_firebase_app/domain/group_domain.dart';
import 'package:warikan_firebase_app/domain/member_domain.dart';
import 'package:warikan_firebase_app/login/login_model.dart';
import 'package:warikan_firebase_app/repository/group_repository.dart';

import '../base_model.dart';
import '../domain/payment_domain.dart';

class MakeGroupModel extends BaseModel {
  MakeGroupModel({this.group});

  Group? group;
  Member? member;
  List<Member> members = [];

  final TextEditingController groupTextController = TextEditingController();
  final TextEditingController memberTextController = TextEditingController();

  @override
  Future init() async {
    group = Group(name: '', members: [], paymentRecords: []);
  }

  void addMembersName(text) {
    String addMember = text;
    group!.members.add(addMember);
    notifyListeners();
  }

  void removeMembersName(int index) {
    group!.members.removeAt(index);
    notifyListeners();
  }

  Set<String> getAllTargetMembers() {
    Set<String> allTargetMembers = {};
    group!.paymentRecords.forEach((Payment p) {
      Set<String> pts = p.targetMembers!;
      allTargetMembers.addAll(pts);
      print(allTargetMembers);
    });
    return allTargetMembers;
  }

  Set<String> getAllInsteadMembers() {
    Set<String> allInsteadMembers = {};
    group!.paymentRecords.forEach((Payment p) {
      String pi = p.insteadMember!;
      allInsteadMembers.add(pi);
      print(allInsteadMembers);
    });
    return allInsteadMembers;
  }

  bool isPossibleRemove(String memberName) {
    bool isPossible = true;
    final atm = getAllTargetMembers();
    final aim = getAllInsteadMembers();

    if (atm.contains(memberName) || aim.contains(memberName)) {
      isPossible = !isPossible;
    }
    return isPossible;
  }

  Future registerGroup() async {
    startLoading();
    final addedGroup = await GroupRepository().addGroup(
      Group(
        uid: LoginModel().getCurrentUserId(),
        id: null,
        name: groupTextController.text,
        members: group!.members,
        paymentRecords: group!.paymentRecords,
      ),
    );
    group = addedGroup;
  }

  Future updateGroup() async {
    startLoading();
    final updatedGroup = await GroupRepository().updateGroup(group!);
    group = updatedGroup;
  }
}
