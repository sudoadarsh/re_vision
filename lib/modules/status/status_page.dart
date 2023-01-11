import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/topic_user_dm.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';

import '../../base_widgets/base_text.dart';

typedef FBSnap = List<QueryDocumentSnapshot<Map<String, dynamic>>>;

class StatusPageArguments {
  final String primaryKey;

  StatusPageArguments({required this.primaryKey});
}

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key, required this.primaryKey}) : super(key: key);

  final String primaryKey;

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FBSnap>(
      future: fetchUsersOfTopic(),
      builder: (BuildContext context, AsyncSnapshot<FBSnap> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator().center();
        } else if (snapshot.hasData) {
          List<TopicUserDm> data =
              snapshot.data?.map((e) => TopicUserDm.fromJson(e)).toList() ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: const AssetImage(StringC.defaultPPPath),
                  foregroundImage: NetworkImage(data[i].picURL ?? ""),
                  onForegroundImageError: (_, __) {
                    debugPrint('Error loading profile image.');
                  },
                ),
                title: BaseText(data[i].name ?? ""),
                subtitle: BaseText(data[i].email ?? ""),
              );
            },
          );
        }
        // todo: handle error.
        return const BaseText("Error");
      },
    );
  }

  // ------------------------- Class methods -----------------------------------

  Future<FBSnap> fetchUsersOfTopic() async {
    return BaseCloud.readSC(
        collection: CloudC.topic,
        document: widget.primaryKey,
        subCollection: CloudC.users);
  }
}
