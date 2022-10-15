import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_shared_prefs/base_shared_prefs.dart';
import 'package:re_vision/base_sqlite/sqlite_helper.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/routes/route_generator.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';
import 'package:re_vision/utils/custom_theme_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise the sqflite.
  await BaseSqlite.init();
  // Initialise the sharedPref.
  await BaseSharedPrefsSingleton.init();
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttachmentCubit(),
      child: MaterialApp(
        theme: CustomThemeData.themeData,
        onGenerateRoute: RouteGenerator.generate,
        initialRoute: RouteConstants.loginPage,
      ),
    );
  }
}
