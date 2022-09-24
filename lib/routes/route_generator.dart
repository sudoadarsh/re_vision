import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/constants/route_constants.dart';
import 'package:re_vision/modules/login_page.dart';

import '../modules/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    // can use later to pass values between screen.
    // final args = settings.arguments;

    Widget page;

    switch (settings.name) {
      case RouteConstants.loginPage:
        page = const LoginPage();
        break;
      case RouteConstants.homePage:
        page = const HomePage();
        break;
      default:
        page = const Scaffold(
          body: SizedBox.shrink(),
        );
    }

    return MaterialPageRoute(builder: (_) => page);
  }
}

