import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_divider.dart';

import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/base_widgets/link_to_page.dart';
import 'package:re_vision/constants/date_time_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/auth/auth_repo.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_depth_form_field.dart';
import '../../common_button_cubit/common_button_cubit.dart';
import '../../constants/color_constants.dart';
import '../../constants/icon_constants.dart';
import '../../constants/size_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/auth_in_model.dart';
import '../../models/user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';

/// Widget to get the logo of the application.
///
class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(StringC.logoPath).paddingOnly(top: 24, bottom: 24);
  }
}

/// Widget that builds the form, validates the user credentials.
///
class _Form extends StatefulWidget {
  const _Form({
    Key? key,
    this.isLogin = true,
    required this.onTap,
  }) : super(key: key);

  final bool isLogin;
  final VoidCallback onTap;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  // Instance variable to control the toggle of obscure text.
  bool _isVisible = false;

  // The text field controllers.
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;

  // Button cubit to handle authentication.
  late final CommonButtonCubit _authCubit;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();

    _authCubit = CommonButtonCubit(AuthRepo());
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();

    _authCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorC.boxDecorAll(radius: 20).copyWith(color: ColorC.white),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizeC.spaceVertical5,

            // The email field.
            BaseTextFormFieldWithDepth(
              controller: _emailController,
              prefixIcon: IconC.email,
              labelText: StringC.emailOrAppleId,
            ),
            SizeC.spaceVertical10,

            // The username field.
            if (!widget.isLogin) ...[
              BaseTextFormFieldWithDepth(
                controller: _usernameController,
                prefixIcon: IconC.user,
                labelText: StringC.username,
              ),
              SizeC.spaceVertical10
            ],

            // The password field.
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

            // Forget Password.
            widget.isLogin
                ? const LinkToPage(
                    title: StringC.empty, pageName: StringC.forgor, route: "")
                : SizeC.spaceVertical20,

            // The Sign-in/ Log-in button.
            BaseElevatedButton(
              backgroundColor: ColorC.secondary,
              onPressed: () {
                _authCubit.fetchData<User?>(
                  data: AuthInModel(
                    context: context,
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                    login: widget.isLogin,
                  ),
                );
              },
              child: BlocConsumer(
                bloc: _authCubit,
                listener: (context, state) {
                  if (state is CommonButtonSuccess) {
                    User? user = state.data;
                    if (user != null) {
                      // !_loginState ? _saveUserToCloud(user) : null;
                      // // Save the auth state.
                      // BaseSharedPrefsSingleton.setValue("auth", 1);
                      // // Navigate to the dashboard.
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     RouteC.dashboard, (route) => false);
                    }
                  } else if (state is CommonButtonFailure) {
                    // todo: add firebase exception snack bars.
                    debugPrint(state.error.toString());
                  }
                },
                builder: (context, state) {
                  if (state is CommonButtonLoading) {
                    return const CupertinoActivityIndicator().center();
                  }
                  return BaseText(
                    widget.isLogin ? StringC.login : StringC.createAccount,
                    color: ColorC.white,
                    fontWeight: FontWeight.w500,
                  );
                },
              ),
            ),

            // The create account or already have an account link.
            LinkToPage(
              title: widget.isLogin
                  ? StringC.doNotHaveAccount
                  : StringC.alreadyHaveAccount,
              pageName: widget.isLogin ? StringC.createAccount : StringC.login,
              onTap: () {
                _clearFields();
                widget.onTap();
              },
            ),
          ],
        ).paddingDefault(),
      ),
    );
  }

  // -------------------------------- Functions --------------------------------
  void _clearFields() {
    _passwordController.clear();
    _emailController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _saveUserToCloud(User user) async {
    // Modelling the data.
    UserFBDm dataToSave = UserFBDm(
      name: _usernameController.text.trim(),
      email: user.email,
    );

    // Creating the main collection.
    BaseCloud.create(
      collection: CloudC.users,
      document: user.uid,
      data: dataToSave.toJson(),
    );

    // Update the user name of the user.
    user.updateDisplayName(_usernameController.text.trim());
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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        primaryColor: ColorC.primary,
      ),
      child: Scaffold(
        backgroundColor: ColorC.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: AppConfig.height(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (AppConfig.height(context) * 0.05).separation(true),
                  const _Logo(),
                  (AppConfig.height(context) * 0.05).separation(true),
                  Flexible(
                    child: PageView.builder(
                      controller: _pageController,
                      allowImplicitScrolling: true,
                      itemCount: 2,
                      itemBuilder: (context, i) {
                        return _Form(
                          isLogin: i == 0,
                          onTap: () {
                            _pageController.animateToPage(
                                i == 0 ? 1 : 0,
                                duration: DateTimeC.cd500,
                                curve: Curves.easeIn
                            );
                          },
                        ).paddingOnly(left: 4, right: 4);
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  SizeC.spaceVertical5,
                  Row(
                    children: const [
                      BaseDivider(color: ColorC.white),
                      BaseText("Or continue with", color: ColorC.white),
                      BaseDivider(color: ColorC.white),
                    ],
                  ),
                  SizeC.spaceVertical5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AlternateMethods(
                          iconPath: StringC.googlePath, onTap: () {}),
                      _AlternateMethods(
                          iconPath: StringC.applePath, onTap: () {}),
                    ],
                  )
                ],
              ).paddingDefault().paddingDefault(),
            ),
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}
