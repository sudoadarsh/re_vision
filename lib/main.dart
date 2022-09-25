import 'package:flutter/material.dart';
import 'package:re_vision/base_sqlite/sqlite_helper.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/routes/route_generator.dart';
import 'package:re_vision/utils/custom_theme_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BaseSqlite.init();
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
