import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../base_widgets/base_depth_form_field.dart';

/// Widget to get the logo of the application.
///
class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(StringConstants.logoPath, scale: 4);
  }
}

/// Widget that displays the name of the application.
///
class _Message extends StatelessWidget {
  const _Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseText(
      StringConstants.appName,
      fontWeight: FontWeight.w300,
      fontSize: 24.0,
    );
  }
}

/// Widget that builds the form, validates the user credentials.
///
class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BaseTextFormFieldWithDepth(
            prefix: IconConstants.username,
            labelText: StringConstants.username,
          ),
          SizeConstants.spaceVertical10,
          const BaseTextFormFieldWithDepth(
            prefix: IconConstants.password,
            labelText: StringConstants.password,
          ),
          SizeConstants.spaceVertical10,
          BaseElevatedButton(
            backgroundColor: ColorConstants.loginButton,
            onPressed: () {},
            child: const BaseText(
              StringConstants.login,
              color: ColorConstants.white,
            ),
          )
        ],
      ).paddingDefault(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Logo(),
            const _Message(),
            SizeConstants.spaceVertical20,
            const _Form(),
          ],
        ),
      ),
    );
  }
}
