import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_widgets/base_social_button.dart';
import 'package:re_vision/common_button_cubit/common_button_cubit.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/sign_in/sign_in_repo.dart';
import 'package:re_vision/utils/app_config.dart';

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
            StringConstants.appName,
            fontWeight: FontWeight.w300,
            fontSize: 34.0,
            textAlign: TextAlign.center,
          ),
          Lottie.asset(StringConstants.lottieSign,
              height: AppConfig.height(context) * 0.5),
          const BaseText(
            StringConstants.continueWith,
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            textAlign: TextAlign.center,
          ),
          const _GoogleSingInButton(),
          BaseSocialButton(
            icon: IconConstants.apple,
            title: StringConstants.apple,
            onPressed: () {},
          ),
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
    return BlocBuilder(
      bloc: _googleCubit,
      builder: (context, state) {
        if (state is CommonButtonSuccess) {
          User? user = state.data;

          if (user != null) {
            // Navigate to dashboard.
            // print(user.displayName);
          }
        }

        // Button to login in with google.
        return BaseSocialButton(
          icon: IconConstants.google,
          title: StringConstants.gmail,
          onPressed: () {
            _googleCubit.fetchData(data: context);
          },
        );
      },
    );
  }
}
