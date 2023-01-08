import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_notifications.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/modules/notification/invites_page.dart';
import 'package:re_vision/modules/notification/requests_page.dart';

import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: BaseCloud.db
            ?.collection(CloudC.users)
            .doc(BaseAuth.currentUser()?.uid ?? "")
            .collection(CloudC.requests)
            .snapshots(),
        builder: (context, snap) {
          List<ReqsDm> frReqs = [];
          List<ReqsDm> topicReqs = [];
          if (snap.hasData) {
            List<ReqsDm> data =
                snap.data?.docs.map((e) => ReqsDm.fromJson(e)).toList() ?? [];
            frReqs = data.where((e) => e.primaryId == null).toList();
            topicReqs = data.where((e) => e.primaryId != null).toList();
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const BaseText(StringC.notifications),
              ),
              SliverToBoxAdapter(
                child: _RequestsTile(
                  title: StringC.frRequests,
                  list: frReqs,
                  image: StringC.friendPath,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FrRequestsPage(req: frReqs),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: _RequestsTile(
                  title: StringC.revisionInvites,
                  list: topicReqs,
                  image: StringC.revisionReqsPath,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => InvitesPage(topicInvites: topicReqs),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The follow requests tile.
class _RequestsTile extends StatelessWidget {
  const _RequestsTile({
    Key? key,
    required this.list,
    required this.onTap,
    required this.image,
    required this.title,
  }) : super(key: key);

  final List list;
  final VoidCallback onTap;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: ColorC.shadowColor,
            backgroundImage: AssetImage(image),
          ),
          list.isNotEmpty
              ? Positioned(
                  right: -5,
                  child: BaseBadge(
                    color: ColorC.secondary,
                    child: BaseText(
                      list.length.toString(),
                      fontSize: 12.0,
                      color: ColorC.white,
                    ),
                  ),
                )
              : SizeC.none
        ],
      ),
      title: BaseText(title),
      subtitle: const BaseText(StringC.tapToSeeMore),
    );
  }
}
