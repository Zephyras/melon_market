import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 100, color: Colors.amber),
            Container(height: 100, color: Colors.green),
            Container(height: 100, color: Colors.yellow),
            Container(height: 100, color: Colors.amber),
            Container(height: 100, color: Colors.green),
            Container(height: 100, color: Colors.yellow),
            Container(height: 100, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
