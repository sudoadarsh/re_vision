import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_widgets/base_social_button.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(StringConstants.lottieSign,
              height: AppConfig.height(context) * 0.5),
          const BaseText(
            'Create an account with...',
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            textAlign: TextAlign.center,
          ),
          BaseSocialButton(
            icon: IconConstants.google,
            title: StringConstants.gmail,
            onPressed: () {},
          ),
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
