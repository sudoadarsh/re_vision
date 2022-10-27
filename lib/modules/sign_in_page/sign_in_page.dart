import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_shared_prefs/base_shared_prefs.dart';
import 'package:re_vision/base_widgets/base_social_button.dart';
import 'package:re_vision/common_button_cubit/common_button_cubit.dart';
import 'package:re_vision/common_cubit/common__cubit.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/user_dm.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/state_management/sign_in/sign_in_repo.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BaseText(
            StringC.appName,
            fontWeight: FontWeight.w300,
            fontSize: 34.0,
            textAlign: TextAlign.center,
          ),
          Lottie.asset(StringC.lottieSign,
              height: AppConfig.height(context) * 0.5),
          const BaseText(
            StringC.welcome,
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            textAlign: TextAlign.center,
          ),
          const _GoogleSingInButton(),
          BaseSocialButton(
            icon: IconC.apple,
            title: StringC.continueWithApple,
            onPressed: () {},
          ),
          // const LinkToPage(
          //   title: StringConstants.alreadyHaveAccount,
          //   pageName: StringConstants.login,
          //   route: RouteConstants.loginPage,
          // ),
        ],
      ).paddingHorizontal8(),
    );
  }
}

// The google sign_in method.
class _GoogleSingInButton extends StatefulWidget {
  const _GoogleSingInButton({Key? key}) : super(key: key);

  @override
  State<_GoogleSingInButton> createState() => _GoogleSingInButtonState();
}

class _GoogleSingInButtonState extends State<_GoogleSingInButton> {
  @override
  void initState() {
    super.initState();

    _googleCubit = CommonButtonCubit(SignInRepo());
  }

  // The cubit for google sign-in.
  late final CommonButtonCubit _googleCubit;

  @override
  void dispose() {
    super.dispose();

    _googleCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _googleCubit,
      listener: (context, state) {
        if (state is CommonButtonSuccess) {
          User? user = state.data;

          if (user != null) {
            // Save user data to the database.
            saveUserToCloud(user);
            // Save the auth state.
            BaseSharedPrefsSingleton.setValue("auth", 1);
            // Navigate to dashboard.
            Navigator.of(context).pushNamed(RouteC.dashboard);
          }
        }
      },
      builder: (context, state) {

        // Loading.
        if (state is CommonCubitStateLoading) {
          return const CupertinoActivityIndicator().center();
        }

        // Button to login in with google.
        return BaseSocialButton(
          icon: IconC.google,
          title: StringC.continueWithGoogle,
          onPressed: () {
            _googleCubit.fetchData(data: context);
          },
        );
      },
    );
  }

  Future<void> saveUserToCloud(User user) async {

    // Modelling the data.
    UserFBDm dataToSave = UserFBDm(
      name: user.displayName,
      email: user.email,
      uuid: user.uid,
      requestR: [],
      requestS: [],
      friends: []
    );

    BaseCloud.create(
      collection: CloudConstants.usersCollection,
      document: user.uid,
      data: dataToSave.toJson(),
    );
  }
}
