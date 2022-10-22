import 'package:flutter/material.dart';
import 'package:re_vision/modules/dashboard/dashboard_page.dart';
import 'package:re_vision/routes/route_constants.dart';

import '../modules/home_page/home_page.dart';
import '../modules/sign_in_page/sign_in_page.dart';
import '../modules/topic_page/topic_page.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case RouteConstants.signPage:
        page = const SignInPage();
        break;
      case RouteConstants.dashboard:
        page = const DashBoard();
        break;
      case RouteConstants.homePage:
        page = const HomePage();
        break;
      case RouteConstants.topicPage:
        final args = settings.arguments as TopicPageArguments;
        page = TopicPage(selectedDay: args.selectedDay, topicDm: args.topicDm);
        break;
      // case RouteConstants.loginPage:
      //   page = const LoginPage();
      //   break;
      default:
        page = const Scaffold(
          body: SizedBox.shrink(),
        );
    }

    return MaterialPageRoute(builder: (_) => page);
  }
}

