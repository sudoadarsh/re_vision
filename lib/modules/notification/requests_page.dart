import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/models/friend_dm.dart';

import '../../models/user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';

class FrRequestsPage extends StatefulWidget {
  const FrRequestsPage({
    Key? key,
    required this.req,
  }) : super(key: key);

  final List<FrReqDm> req;

  @override
  State<FrRequestsPage> createState() => _FrRequestsPageState();
}

class _FrRequestsPageState extends State<FrRequestsPage> {
  List<FrReqDm> get _req => widget.req;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.frRequests),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: _req.length,
        itemBuilder: (context, ind) {
          return ListTile(
            title: BaseText(_req[ind].name ?? ''),
            subtitle: BaseText(_req[ind].email ?? ''),
            trailing: BaseElevatedButton(
              backgroundColor: ColorC.elevatedButton,
              onPressed: () {
                _acceptReq(_req[ind]);
                _req.removeAt(ind);
                setState(() {});
              },
              size: const Size(80, 40),
              child: const BaseText(StringC.accept),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------Functions-----------------------------------
  void _acceptReq(FrReqDm req) {
    // Remove the particular request from the current user and add friend.
    _removeRequest(req);

    // Update friends in the other user.
    _updateOU(req);
  }

  void _removeRequest(FrReqDm req) async {
    // todo: remove a friend request
  }

  void _updateOU(FrReqDm req) async {
    User? cUser = BaseAuth.currentUser();

    try {
      // Update the friends sub list of other user (Add the current user).
      BaseCloud.createSC(
        collection: CloudC.users,
        document: req.uuid ?? '',
        subCollection: CloudC.friends,
        subDocument: cUser?.uid ?? "",
        data: FriendDm(
                name: cUser?.displayName, email: cUser?.email, uuid: cUser?.uid)
            .toJson(),
      );
    } catch (e) {
      debugPrint("Error while updating data of OU: $e");
    }
  }
}
