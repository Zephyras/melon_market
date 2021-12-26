import 'package:flutter/material.dart';
import 'package:melon_market/screens/start/address_page.dart';
import 'package:melon_market/screens/start/intro_page.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            IntroPage(_pageController),
            AddressPage(),
            Container(
              color: Colors.accents[5],
            )
          ]),
    );
  }
}
