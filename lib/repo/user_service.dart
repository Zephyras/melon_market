import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melon_market/constants/data_keys.dart';
import 'package:melon_market/utils/logger.dart';

class UserService {
  //싱글턴 패턴
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  //유저가 로그인할떄 사용유저인지 아니지 유무 체크
  Future createNewUser(Map<String, dynamic> json, String userkey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_USERS).doc(userkey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    //userkey에서 가져온 데이터를 ocumentSnapshot에 넣어보고 존재하지 않으면 넣어주는 조건
    if (!documentSnapshot.exists) {
      await documentReference.set(json); // 존재하지 않으면 기달렸다가 레퍼런스에 데이터 넣어줌
    }
  }

  Future firestoreText() async {
    FirebaseFirestore.instance
        .collection("TESTING_COLLECTION")
        .add({'testing': 'testing value', 'nuber': 111122});
  }

  void firestoreGetText() {
    FirebaseFirestore.instance
        .collection("TESTING_COLLECTION")
        .doc('rsCUtFtysWEMOlrgEuTT')
        .get()
        .then(
          (DocumentSnapshot<Map<String, dynamic>> value) =>
              logger.d(value.data()),
        );
  }
}
