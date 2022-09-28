import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_sqlite/sqlite_helper.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/routes/route_generator.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttachmentCubit(),
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        theme: CustomThemeData.themeData,
        onGenerateRoute: RouteGenerator.generate,
        initialRoute: RouteConstants.topicPage,
      ),
    );
  }
}
