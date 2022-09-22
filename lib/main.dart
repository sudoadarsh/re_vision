import 'package:flutter/material.dart';
import 'package:re_vision/constants/route_constants.dart';
import 'package:re_vision/routes/route_generator.dart';
import 'package:re_vision/utils/custom_theme_data.dart';

void main() {
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomThemeData.themeData,
      onGenerateRoute: RouteGenerator.generate,
      initialRoute: RouteConstants.homePage,
    );
  }
}
