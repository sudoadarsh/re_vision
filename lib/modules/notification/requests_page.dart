import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

import '../../models/user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({
    Key? key,
    required this.req,
  }) : super(key: key);

  final List<Requests> req;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  List<Requests> get _req => widget.req;

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
                _acceptReq(_req[ind].uuid);
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
  void _acceptReq(String? uuid) {
    // Remove the particular request from the current user and add friend.
    _removeRequest(uuid);

    // Update friends in the other user.
    _updateOU(uuid);
  }

  void _removeRequest(String? otherUUID) async {
    List<Requests> reqU = _req.where((e) => e.uuid != otherUUID).toList();
    // widget.frs.add(Friends(uuid: uuid));
    // List frsJson = widget.frs.map((e) => e.toJson()).toList();
    try {
      BaseCloud.update(
        collection: CloudC.users,
        document: BaseAuth.currentUser()?.uid ?? '',
        data: {CloudC.requests: reqU},
      );

      // Update the friends sub list of current user (Add the user).
      BaseCloud.updateSC(
        collection: CloudC.users,
        document: BaseAuth.currentUser()?.uid ?? '',
        subCollection: CloudC.friends,
        subDocument: CloudC.friends,
        data: {
          CloudC.friends: otherUUID,
        },
      );
    } catch (e) {
      debugPrint("Error while updating data of CU: $e");
    }
  }

  void _updateOU(String? uuid) async {
    try {
      // Update the friends sub list of other user (Add the current user).
      BaseCloud.updateSC(
        collection: CloudC.users,
        document: uuid ?? '',
        subCollection: CloudC.friends,
        subDocument: CloudC.friends,
        data: {
          CloudC.friends: BaseAuth.currentUser()?.uid,
        },
      );
    } catch (e) {
      debugPrint("Error while updating data of OU: $e");
    }
  }
}
