import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_notifications.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/modules/notification/invites_page.dart';
import 'package:re_vision/modules/notification/requests_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
    required this.req,
  }) : super(key: key);

  final List<ReqsDm> req;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<ReqsDm> _frReqs;
  late List<ReqsDm> _topicReqs;

  @override
  void initState() {
    super.initState();

    _frReqs = widget.req.where((e) => e.primaryId == null).toList();
    _topicReqs = widget.req.where((e) => e.primaryId != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const BaseText(StringC.notifications),
          ),
          SliverToBoxAdapter(
            child: _RequestsTile(
              title: StringC.frRequests,
              list: _frReqs,
              image: StringC.friendPath,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => FrRequestsPage(req: _frReqs)),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _RequestsTile(
              title: StringC.revisionInvites,
              list: _topicReqs,
              image: StringC.revisionReqsPath,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => InvitesPage(topicInvites: _topicReqs)),
                );
              },
            ),
          ),
        ],
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
