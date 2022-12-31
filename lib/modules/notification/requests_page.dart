import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/models/friend_dm.dart';
import 'package:re_vision/models/reqs_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';

class FrRequestsPage extends StatefulWidget {
  const FrRequestsPage({
    Key? key,
    required this.req,
  }) : super(key: key);

  final List<ReqsDm> req;

  @override
  State<FrRequestsPage> createState() => _FrRequestsPageState();
}

class _FrRequestsPageState extends State<FrRequestsPage> {
  List get _req => widget.req;

  User? cUser = BaseAuth.currentUser();

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
              backgroundColor: ColorC.secondary,
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
  void _acceptReq(var req) {
    // Remove the particular request from the current user and add friend.
    _removeRequest(req);

    // Update friends in the other user.
    _updateFCollection(req);
  }

  void _removeRequest(ReqsDm req) async {
    // Remove the request from the current user.
    BaseCloud.deleteSC(
        collection: CloudC.users,
        document: cUser?.uid ?? "",
        subCollection: CloudC.requests,
        subDocument: req.uuid ?? "",
    );
  }

  void _updateFCollection(ReqsDm req) async {

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

      // Update the friends sub list of the current user.
      BaseCloud.createSC(
          collection: CloudC.users,
          document: cUser?.uid ?? '',
          subCollection: CloudC.friends,
          subDocument: req.uuid ?? '',
          data: FriendDm(
            name: req.name, email: req.email, uuid: req.uuid
          ).toJson(),
      );
    } catch (e) {
      debugPrint("Error while updating data of OU: $e");
    }
  }
}
