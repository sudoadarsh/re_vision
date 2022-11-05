import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/base_widgets/link_to_page.dart';
import 'package:re_vision/constants/date_time_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_depth_form_field.dart';
import '../../constants/color_constants.dart';
import '../../constants/icon_constants.dart';
import '../../constants/size_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/social_auth/base_auth.dart';

/// Widget to get the logo of the application.
///
class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(StringC.logoPath, scale: 4)
        .paddingOnly(top: 24, bottom: 24);
  }
}

/// Widget that displays the name of the application.
///
class _Message extends StatelessWidget {
  const _Message({Key? key, required this.msg}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return BaseText(
      msg,
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

  // The text field controllers.
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // To alter between login and sign-in.
  bool _loginState = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Message(msg: StringC.appName),
          SizeC.spaceVertical20,
          BaseTextFormFieldWithDepth(
            controller: _emailController,
            prefixIcon: IconC.user,
            labelText: StringC.emailOrAppleId,
          ),
          SizeC.spaceVertical20,
          StatefulBuilder(builder: (context, sst) {
            return BaseTextFormFieldWithDepth(
              controller: _passwordController,
              prefixIcon: IconC.password,
              labelText: StringC.password,
              suffixIcon: IconButton(
                onPressed: () {
                  sst(() => _isVisible = !_isVisible);
                },
                icon: _isVisible ? IconC.visibilityOff : IconC.visible,
              ),
              obscureText: !_isVisible,
            );
          }),
          AnimatedCrossFade(
            duration: DateTimeC.cd500,
            firstChild: const LinkToPage(
                title: StringC.empty, pageName: StringC.forgor, route: ""),
            secondChild: SizeC.spaceVertical20,
            crossFadeState: _loginState
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          BaseElevatedButton(
            backgroundColor: ColorC.elevatedButton,
            onPressed: () => loginNow(),
            child: BaseText(
              _loginState ? StringC.login : StringC.signIn,
              color: ColorC.white,
            ),
          ),
          AnimatedCrossFade(
            duration: DateTimeC.cd200,
            firstChild: LinkToPage(
              title: StringC.doNotHaveAccount,
              pageName: StringC.signIn,
              onTap: () {
                _loginState = !_loginState;
                setState(() {});
              },
            ),
            secondChild: LinkToPage(
              title: StringC.alreadyHaveAccount,
              pageName: StringC.login,
              onTap: () {
                _loginState = !_loginState;
                setState(() {});
              },
            ),
            crossFadeState: _loginState
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          )
        ],
      ).paddingDefault(),
    );
  }

  // ----------------------------------Functions--------------------------------
  Future<User?> loginNow() async {
    return await BaseAuth.login(
      context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}

/// Alternate Login methods.
///
class _AlternateMethods extends StatelessWidget {
  const _AlternateMethods({
    Key? key,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: ColorC.white),
        child: Image.asset(iconPath, scale: 18),
      ),
    ).paddingDefault();
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
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: ColorC.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: AppConfig.height(context),
              child: Column(
                children: [
                  Container(
                    decoration: DecorC.boxDecorAll(radius: 20)
                        .copyWith(color: ColorC.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _Logo(),
                        _Form(),
                        SizedBox(),
                      ],
                    ).paddingDefault(),
                  ).paddingDefault(),
                ],
              ),
            ),
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          _AlternateMethods(iconPath: StringC.googlePath, onTap: () {}),
          _AlternateMethods(iconPath: StringC.applePath, onTap: () {}),
        ],
      ),
    );
  }
}
