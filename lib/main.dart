import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:melon_market/router/locations.dart';
import 'package:melon_market/screens/auth_screen.dart';
import 'package:melon_market/screens/splash_screen.dart';
import 'package:melon_market/utils/logger.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return false;
      },
      showPage: BeamPage(child: AuthScreen()))
], locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()]));

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
      return MelonApp();
    } else {
      return SplashScreen();
    }
  }
}

class MelonApp extends StatelessWidget {
  const MelonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cafe24',
        hintColor: Colors.grey[350],
        textTheme: TextTheme(
            //headline3: TextStyle(fontFamily: 'Cafe24'),
            button: TextStyle(color: Colors.white)),
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
