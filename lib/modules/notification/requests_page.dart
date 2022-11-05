import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

import '../../models/user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';

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
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: ColorC.shadowColor,
              backgroundImage: NetworkImage(_req[ind].pic ?? ''),
              onBackgroundImageError: (obj, trace) =>
                  debugPrint('Error in requests pic'),
            ),
            title: BaseText(_req[ind].name ?? ''),
            subtitle: BaseText(_req[ind].email ?? ''),
            trailing: BaseElevatedButton(
              backgroundColor: ColorC.elevatedButton,
              onPressed: () {
                _acceptReq(_req[ind].uuid);
                _req.removeAt(ind);
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

  void _removeRequest(String? uuid) async {
    // List<Requests> reqU = _req.where((e) => e.uuid != uuid).toList();
    // widget.frs.add(Friends(uuid: uuid));
    // List frsJson = widget.frs.map((e) => e.toJson()).toList();
    try {
      // BaseCloud.update(
      //   collection: CloudC.users,
      //   document: BaseAuth.currentUser()?.uid ?? '',
      //   data: {CloudC.requests: reqU, CloudC.friends : frsJson},
      // );
    } catch (e) {
      debugPrint("Error while updating data of CU: $e");
    }
  }

  void _updateOU(String? uuid) async {
    DocumentSnapshot? snap =
        await BaseCloud.readD(collection: CloudC.users, document: uuid ?? '');

    if (snap != null) {
      // UserFBDm snapM = UserFBDm.fromJson(snap);
      // List<Friends> frs = snapM.friends ?? [];
      // frs.add(Friends(uuid: BaseAuth.currentUser()?.uid));

      try {
        // BaseCloud.update(
        //   collection: CloudC.users,
        //   document: BaseAuth.currentUser()?.uid ?? '',
        //   data: {CloudC.friends : frs},
        // );
      } catch (e) {
        debugPrint("Error while updating data of OU: $e");
      }
    }
  }
}
