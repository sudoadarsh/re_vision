import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/string_constants.dart';
import '../../models/friend_dm.dart';

class FriendsPageArguments {
  final String title;
  final List<FriendDm> frs;
  final bool fromProfile;

  FriendsPageArguments({
    required this.title,
    required this.frs,
    this.fromProfile = false,
  });
}

// todo: add ui for when no friends.
class FriendsPage extends StatefulWidget {
  const FriendsPage(
      {Key? key,
      required this.title,
      required this.frs,
      required this.fromProfile})
      : super(key: key);

  final String title;
  final List<FriendDm> frs;
  final bool fromProfile;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: ColorC.button, title: BaseText(widget.title)),
      body: ListView.builder(
        itemCount: widget.frs.length,
        itemBuilder: (ctx, i) {
          return _FriendsList(
              frs: widget.frs, fromProfile: widget.fromProfile, i: i);
        },
      ),
    );
  }
}

class _FriendsList extends StatefulWidget {
  const _FriendsList({
    Key? key,
    required this.frs,
    required this.fromProfile,
    required this.i,
  }) : super(key: key);

  final List<FriendDm> frs;
  final bool fromProfile;
  final int i;

  @override
  State<_FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<_FriendsList> {
  bool _isSend = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BaseText(widget.frs[widget.i].name ?? ""),
      subtitle: BaseText(widget.frs[widget.i].email ?? ""),
      trailing: widget.fromProfile ? SizeC.none : _trailing(),
    );
  }

  /// For when this page is called from topics.
  Widget _trailing() {
    return BaseElevatedButton(
      size: const Size(80, 40),
      backgroundColor: !_isSend ? ColorC.elevatedButton : null,
      onPressed: () {
        _isSend = !_isSend;
        setState(() {});
      },
      child: !_isSend
          ? const BaseText(StringC.send)
          : const BaseText(StringC.undo),
    );
  }
}
