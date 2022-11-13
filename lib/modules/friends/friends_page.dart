import 'package:flutter/cupertino.dart';
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
  const FriendsPage({
    Key? key,
    required this.title,
    required this.frs,
    required this.fromProfile,
  }) : super(key: key);

  final String title;
  final List<FriendDm> frs;
  final bool fromProfile;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<FriendDm> sendReqs = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: ColorC.button, title: BaseText(widget.title)),
        body: ListView.builder(
          itemCount: widget.frs.length,
          itemBuilder: (ctx, i) {
            return _FriendsList(
              frs: widget.frs,
              fromProfile: widget.fromProfile,
              i: i,
              send: (fr) {
                sendReqs.add(fr);
                setState(() {});
              },
              undo: (fr) {
                sendReqs = sendReqs
                    .where((element) => element.email != fr.email)
                    .toList();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  // ------------------------------- Functions ---------------------------------
  Future<bool> _onWillPop() async {

    if (sendReqs.isEmpty || widget.fromProfile) {
      return true;
    }

    NavigatorState nav = Navigator.of(context);

    bool confirmed = (await showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const BaseText(StringC.alert),
            content: RichText(
              textAlign: TextAlign.center,
              maxLines: 10,
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(text: StringC.sureWantToSent),
                  TextSpan(
                    text:
                    "${StringC.toThesePeople} ${sendReqs.map((e) => "${e.name}")}",
                  )
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const BaseText(StringC.confirm),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              CupertinoDialogAction(
                child: const BaseText(StringC.cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        })) ??
        false;

    if (!confirmed) {
      return false;
    } else {
     nav.pop<List<FriendDm>>(sendReqs);
     return true;
    }
  }
}

class _FriendsList extends StatefulWidget {
  const _FriendsList({
    Key? key,
    required this.frs,
    required this.fromProfile,
    required this.i,
    required this.send,
    required this.undo,
  }) : super(key: key);

  final List<FriendDm> frs;
  final bool fromProfile;
  final int i;
  final Function(FriendDm) send;
  final Function(FriendDm) undo;

  @override
  State<_FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<_FriendsList> {
  bool _isUndo = false;

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
      backgroundColor: !_isUndo ? ColorC.elevatedButton : null,
      onPressed: () {
        !_isUndo
            ? widget.send(widget.frs[widget.i])
            : widget.undo(widget.frs[widget.i]);
        _isUndo = !_isUndo;
        setState(() {});
      },
      child: !_isUndo
          ? const BaseText(StringC.send)
          : const BaseText(StringC.undo),
    );
  }
}
