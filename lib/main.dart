import 'package:flutter/material.dart';
import 'package:melon_market/splash_screen.dart';
import 'package:melon_market/utils/logger.dart';

void main() {
  logger.d('My first log by logger!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<Object>(
        future: Future.delayed(Duration(seconds: 3), () => 300),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _splashLodingWidget(snapshot));
        });
  }

  StatelessWidget _splashLodingWidget(AsyncSnapshot<Object> snapshot) {
    if (snapshot.hasError) {
      print('error occur while loading.');
      return Text('Error occur');
    } else if (snapshot.hasData) {
      return melonApp();
    } else {
      return SplashScreen();
    }
  }
}

class melonApp extends StatelessWidget {
  const melonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}
