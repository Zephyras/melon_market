import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  bool _userLoggedIn = false; //로그인안된상태 pivate 처럼 첩근 못하게 _변수로 선언

  void setUserAuth(bool authState) {
    _userLoggedIn = authState;
    notifyListeners();
  }

  bool get userState => _userLoggedIn; //get을 통해서 변수 선언만 할수 있도록 해주기
}
