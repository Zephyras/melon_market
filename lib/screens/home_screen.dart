import 'package:flutter/material.dart';
import 'package:melon_market/states/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('홈 화면')),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                  onPressed: () {
                    context.read<UserProvider>().setUserAuth(false);
                  },
                  child: Text('로그아웃'))
            ],
          ),
        ),
      ),
    );
  }
}
