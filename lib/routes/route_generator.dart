import 'package:flutter/material.dart';
import 'package:re_vision/modules/dashboard/dashboard_page.dart';
import 'package:re_vision/modules/friends/friends_page.dart';
import 'package:re_vision/modules/topic_page/topic_page_v1.dart';
import 'package:re_vision/routes/route_constants.dart';

import '../modules/home_page/home_page.dart';
import '../modules/login_page/login_page.dart';
import '../modules/topic_page/topic_page.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      // case RouteC.signPage:
      //   page = const SignInPage();
      //   break;
      case RouteC.dashboard:
        page = const DashBoard();
        break;
      case RouteC.homePage:
        page = const HomePage();
        break;
      case RouteC.topicPage:
        final args = settings.arguments as TopicPageArguments;
        // page = TopicPage(selectedDay: args.selectedDay, topicDm: args.topicDm);
        page = TopicPageV1(selectedDay: args.selectedDay, topicDm: args.topicDm);
        break;
      case RouteC.loginPage:
        page = const LoginPage();
        break;
      case RouteC.friendsPage:
        final args = settings.arguments as FriendsPageArguments;
        page = FriendsPage(
          title: args.title,
          frs: args.frs,
          fromProfile: args.fromProfile,
        );
        break;
      default:
        page = const Scaffold(
          body: SizedBox.shrink(),
        );
    }

    return MaterialPageRoute(builder: (_) => page);
  }
}

