import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_depth_form_field.dart';

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
      textAlign: TextAlign.center,
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
  // Instance variable to control the toggle of obscure text.
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Message(),
          SizeConstants.spaceVertical20,
          const BaseTextFormFieldWithDepth(
            prefixIcon: IconConstants.username,
            labelText: StringConstants.username,
          ),
          SizeConstants.spaceVertical10,
          StatefulBuilder(builder: (context, sst) {
            return BaseTextFormFieldWithDepth(
              prefixIcon: IconConstants.password,
              labelText: StringConstants.password,
              suffixIcon: IconButton(
                onPressed: () {
                  sst(() => _isVisible = !_isVisible);
                },
                icon: _isVisible
                    ? IconConstants.visibilityOff
                    : IconConstants.visible,
              ),
              obscureText: !_isVisible,
            );
          }),
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

/// Social media methods.
///
class _AlternateMethods extends StatelessWidget {
  const _AlternateMethods({Key? key}) : super(key: key);

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            _divider,
            BaseText(StringConstants.orContinueWith),
            _divider,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconConstants.google,
            SizeConstants.spaceHorizontal20,
            IconConstants.apple
          ],
        ).paddingDefault(),
      ],
    );
  }
}

/// To build the [LoginPage.]
///
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
        child: SingleChildScrollView(
          child: SizedBox(
            height: AppConfig.height(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _Logo(),
                _Form(),
                _AlternateMethods(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
