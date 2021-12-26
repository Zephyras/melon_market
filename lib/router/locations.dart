import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:melon_market/screens/home_screen.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: const HomeScreen(), key: const ValueKey('home'))];
  }

  @override
  List get pathBlueprints => ['/'];
}
