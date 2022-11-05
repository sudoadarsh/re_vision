import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_notifications.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/modules/notification/requests_page.dart';

import '../../models/user_dm.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
    required this.req,
  }) : super(key: key);

  final List<Requests> req;
  // final List<Friends> frs;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

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
            child: _RequestsTile(req: widget.req),
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
    required this.req,
    // required this.frs,
  }) : super(key: key);

  final List<Requests> req;
  // final List<Friends> frs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RequestsPage(req: req)),
        );
      },
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundColor: ColorC.shadowColor,
            backgroundImage: AssetImage(StringC.friendPath),
          ),
          req.isNotEmpty
              ? Positioned(
                  right: -5,
                  child: BaseBadge(
                    color: ColorC.secondary,
                    child: BaseText(
                      req.length.toString(),
                      fontSize: 12.0,
                      color: ColorC.white,
                    ),
                  ),
                )
              : SizeC.none
        ],
      ),
      title: const BaseText(StringC.frRequests),
      subtitle: const BaseText(StringC.tapToSeeMore),
    );
  }
}
