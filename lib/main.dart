import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_shared_prefs/base_shared_prefs.dart';
import 'package:re_vision/base_sqlite/sqlite_helper.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/routes/route_generator.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/base_storage.dart';
import 'package:re_vision/utils/custom_theme_data.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise the firebase.
  await Firebase.initializeApp();
  // Initialise the sqflite.
  await BaseSqlite.init();

  // Initialise the sharedPref.
  await BaseSharedPrefsSingleton.init();
  // Initialise the google auth.
  await BaseAuth.init();
  // Initialise the firebase cloud.
  BaseCloud.init();
  // Initialise the firebase storage singleton.
  FBStorageSingleton.instance.init();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttachmentCubit(),
        ),
      ],
      child: MaterialApp(
        theme: CustomThemeData.themeData,
        onGenerateRoute: RouteGenerator.generate,
        initialRoute: RouteC.homePage,
      ),
    );
  }
}
