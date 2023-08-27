import 'package:flutter/cupertino.dart';
import 'package:warikan_firebase_app/domain/group_domain.dart';
import 'package:warikan_firebase_app/domain/member_domain.dart';

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
    member = Member(name: '');
  }

  void addMembersName(text) {
    Member addMember = Member(name: text);
    group!.members.add(addMember);
    notifyListeners();
  }

  void removeMembersName(int index) {
    group!.members.removeAt(index);
    notifyListeners();
  }

  Set<String> getAllTargetMembers() {
    Set<String> allTargetMembers = {};
    group!.paymentRecords!.forEach((Payment p) {
      Set<String> pts = p.targetMembers!;
      allTargetMembers.addAll(pts);
      print(allTargetMembers);
    });
    return allTargetMembers;
  }

  Set<String> getAllInsteadMembers() {
    Set<String> allInsteadMembers = {};
    group!.paymentRecords!.forEach((Payment p) {
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

  void registerGroup(groupName, members) {}

// Future addMemberToFirebase() async {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final currentUserId = _auth.currentUser.uid;
//   final userDocId = currentUserId;
//   if (memberName.isEmpty) {
//     throw ('名前を入力してください!');
//   }
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userDocId)
//       .collection('friends')
//       .add(
//     {
//       'createdAt': Timestamp.now(),
//       'name': memberName,
//     },
//   );
// }

// Future updateMember(Member member) async {
//   final document =
//       FirebaseFirestore.instance.collection('friends').doc(member.documentID);
//   await document.update(
//     {
//       'updateAt': Timestamp.now(),
//       'name': memberName,
//     },
//   );
// }
}
