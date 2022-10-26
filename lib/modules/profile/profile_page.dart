import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../base_widgets/base_separator.dart';
import '../../utils/social_auth/base_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// To get the information of the currently logged in user.
  late final User? _cu;

  @override
  void initState() {
    _cu = BaseAuth.currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorC.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _UserSection(cu: _cu),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorC.primary,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    _simpleCards(StringC.findFriends, onTap: (){}, icon: IconC.pfCardTrailing)
                  ],
                ).paddingDefault(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ----------------------------------Functions--------------------------------

  /// The simple Profile cards.
  Widget _simpleCards(String title,
      {required VoidCallback onTap, required Icon icon}) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: BaseText(title),
        trailing: icon,
      ),
    );
  }
}

/// The user details sections.
class _UserSection extends StatelessWidget {
  const _UserSection({Key? key, this.cu}) : super(key: key);

  final User? cu;

  User? get _cu => cu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.0,
          backgroundColor: ColorC.white,
          backgroundImage: NetworkImage(_cu?.photoURL ?? ''),
          onBackgroundImageError: (obj, trace) =>
              const Icon(Icons.image_not_supported_outlined).center(),
        ),
        BaseText(
          _cu?.displayName ?? '',
          fontSize: 24.0,
          fontWeight: FontWeight.w300,
          overflow: TextOverflow.ellipsis,
        ),
        BaseText(
          _cu?.email ?? '',
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
          overflow: TextOverflow.ellipsis,
          color: ColorC.subtitle,
        ),
        _genTable(
          headings: [StringC.starsProf, StringC.friends],
          values: ["25", "25"],
        ),
        SizeC.spaceVertical10,
        BaseElevatedButton(
          backgroundColor: ColorC.white,
          elevation: 4.0,
          size: const Size.fromHeight(40),
          onPressed: () {},
          child: const BaseText("Edit profile"),
        ),
        SizeC.spaceVertical10,
        const BaseSeparator(title: StringC.separator),
      ],
    ).paddingDefault();
  }

  // ----------------------------------Functions--------------------------------
  /// Generate Table row for Stars and friends.
  Table _genTable({
    required List<String> headings,
    required List<String> values,
  }) {
    assert(values.length.isEven);

    return Table(
      defaultColumnWidth: const FractionColumnWidth(0.15),
      children: List.generate(values.length, (index) {
        if (index < (values.length / 2 + 1) && index != 0) {
          return TableRow(children: [
            BaseText(values[index - 1], textAlign: TextAlign.center),
            BaseText(values[index - 1], textAlign: TextAlign.center),
          ]);
        }
        return TableRow(
          children: [
            BaseText(headings[0],
                fontWeight: FontWeight.bold, textAlign: TextAlign.center),
            BaseText(headings[1],
                fontWeight: FontWeight.bold, textAlign: TextAlign.center)
          ],
        );
      }),
    );
  }
}
