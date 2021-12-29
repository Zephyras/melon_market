import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:melon_market/router/locations.dart';
import 'package:melon_market/screens/start_screen.dart';
import 'package:melon_market/screens/splash_screen.dart';
import 'package:melon_market/states/user_provider.dart';
import 'package:melon_market/utils/logger.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return context.watch<UserProvider>().userState;
      },
      showPage: BeamPage(child: StartScreen()))
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
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Cafe24',
          hintColor: Colors.grey[350],
          textTheme: TextTheme(
            //headline3: TextStyle(fontFamily: 'Cafe24'),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 2,
              titleTextStyle: TextStyle(fontSize: 24, color: Colors.black87),
              actionsIconTheme: IconThemeData(color: Colors.black87)),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            primary: Colors.white,
            minimumSize: Size(48, 48),
            backgroundColor: Colors.green,
          )),
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
