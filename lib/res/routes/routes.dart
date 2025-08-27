
import 'package:breeze/view/homeScreen.dart';

import '../../res/routes/routeNames.dart';
import 'package:breeze/view/splashScreen.dart';
import 'package:get/get.dart';


class AppRoutes {
  static appRoutes() => [
    GetPage(name: RouteName.splashScreen, page: () { return SplaashScreen(); }, transition: Transition.fadeIn,transitionDuration: Duration(seconds: 3)),
    GetPage(name: RouteName.homeScreen, page: () { return HomeScreen(); }, transition: Transition.fadeIn,transitionDuration: Duration(seconds: 3)),
  ];
}
