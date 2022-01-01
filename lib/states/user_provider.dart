import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:melon_market/constants/shared_pref_keys.dart';
import 'package:melon_market/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    initUser();
  }
  //bool _userLoggedIn = false; //로그인안된상태 pivate 처럼 첩근 못하게 _변수로 선언

  User? _user;

  //유저데이터를 받아오고 파이어베이스에서 로그인 되어 잇는지 체크 하는 함수
  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      logger.d('user status : $user');
      notifyListeners();
    });
  }

  //주소 로케이션데이터를 이족에 가져와서 파이어스토어에 저장해기
  void setNewUser(User? user) async {
    _user = user;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String address = prefs.getString(SHARED_ADDRESS) ?? "";
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;
    }
  }

  User? get user => _user;
  // void setUserAuth(bool authState) {
  //   _userLoggedIn = authState;
  //   notifyListeners();
  // }

  //bool get userState => _userLoggedIn; //get을 통해서 변수 선언만 할수 있도록 해주기
}
