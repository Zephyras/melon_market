import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:melon_market/utils/logger.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    initUser();
  }
  //bool _userLoggedIn = false; //로그인안된상태 pivate 처럼 첩근 못하게 _변수로 선언

  User? _user;
  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      logger.d('user status : $user');
      notifyListeners();
    });
  }

  User? get user => _user;
  // void setUserAuth(bool authState) {
  //   _userLoggedIn = authState;
  //   notifyListeners();
  // }

  //bool get userState => _userLoggedIn; //get을 통해서 변수 선언만 할수 있도록 해주기
}
