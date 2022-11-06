import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_shared_prefs/base_shared_prefs.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

import '../../base_widgets/base_text.dart';

/// The profile pic.
class _ProfilePic extends StatelessWidget {
  const _ProfilePic({Key? key, required this.profileURL}) : super(key: key);

  final String profileURL;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: ColorC.white),
        ),
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage(StringC.defaultPPPath),
          foregroundImage: NetworkImage(profileURL),
          onForegroundImageError: (_, __) {
            debugPrint('Error loading profile image.');
          },
        ),
      ],
    );
  }
}

/// The edit button.
class _EditProfile extends StatelessWidget {
  const _EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseElevatedButton(
      onPressed: () {},
      size: const Size(50, 30),
      child: const BaseText(StringC.editProfile),
    );
  }
}

/// The user stats.
class _UserStats extends StatelessWidget {
  const _UserStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          DecorC.boxDecorAll(radius: 10).copyWith(color: ColorC.primaryComp),
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statContent("20", StringC.revisionProf),
            const VerticalDivider(),
            _statContent("20", StringC.starsProf),
            const VerticalDivider(),
            _statContent("20", StringC.friends),
          ],
        ),
      ),
    ).paddingOnly(left: 16, right: 16);
  }

  /// The Stat content.
  Column _statContent(String title, String subtitle) {
    return Column(
      children: [
        BaseText(title, fontSize: 20),
        BaseText(
          subtitle,
          fontWeight: FontWeight.w300,
          color: ColorC.subtitle,
        ),
      ],
    );
  }
}

/// The section header.
///
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    Key? key,
    required this.header,
  }) : super(key: key);

  final String header;

  @override
  Widget build(BuildContext context) {
    return BaseText(
      header,
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: ColorC.subtitle,
    );
  }
}

/// The profile page.

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: DecorC.boxDecorAll(radius: 10.0)
                  .copyWith(color: ColorC.primary),
              child: Column(
                children: [
                  const _ProfilePic(profileURL: ""),
                  SizeC.spaceVertical10,
                  const BaseText(
                    "Adarsh Sudarsanan",
                    color: ColorC.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                  const BaseText("adarshs@meditab.com", color: ColorC.subtitle),
                  SizeC.spaceVertical10,
                  const _EditProfile(),
                  SizeC.spaceVertical10,
                  const _UserStats(),
                ],
              ).paddingDefault(),
            ),
            SizeC.spaceVertical10,
            Expanded(
              child: ListView(
                children: [
                  const _SectionHeader(header: StringC.account),
                  ListTile(
                    onTap: () => _logoutAlert(context),
                    contentPadding: EdgeInsets.zero,
                    title: const BaseText(StringC.logout),
                    trailing: IconC.logout,
                  ),
                ],
              ),
            )
          ],
        ).paddingDefault(),
      ),
    );
  }

  // ------------------------------ Functions ----------------------------------

  /// Function to display the dialog alerting the user about the logout.
  void _logoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text(StringC.logout),
        content: const Text(StringC.logoutDesc),
        actions: [
          CupertinoDialogAction(
            child: const BaseText(StringC.ok),
            onPressed: () {
              BaseSharedPrefsSingleton.clear();
              BaseAuth.signOut(context, to: RouteC.loginPage);
            },
          ),
          CupertinoDialogAction(
            child: const BaseText(StringC.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
