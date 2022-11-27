import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_rounded_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/base_widgets/sliver_section_header.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/friend_dm.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/models/topic_dm.dart';
import 'package:re_vision/models/user_dm.dart';
import 'package:re_vision/modules/notification/notifications_page.dart';
import 'package:re_vision/modules/profile/profile_page.dart';
import 'package:re_vision/modules/search_page/search_page.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

import '../../common_cubit/common__cubit.dart';
import '../../constants/date_time_constants.dart';
import '../../state_management/topic/topic_repo.dart';

enum CurrentS { dashboard, progress, notifications, profile }

/// The Dashboard page.
///
class _DashBoardPage extends StatefulWidget {
  const _DashBoardPage({Key? key}) : super(key: key);

  @override
  State<_DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<_DashBoardPage> {
  /// Custom cubit to fetch the data from the database.
  late final CommonCubit _dbCubit;

  @override
  void initState() {
    super.initState();

    _dbCubit = CommonCubit(TopicRepo());

    // Fetch the database data.
    _dbCubit.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const BaseText(StringC.dashboard),
          actions: [
            IconButton(
              onPressed: () {},
              icon: IconC.settings,
            ),
          ],
        ),
        _sliverPadding(
          SliverToBoxAdapter(
            child: BaseTextFormFieldWithDepth(
              hintText: StringC.findFriends,
              readOnly: true,
              prefixIcon: IconC.search,
              // Open up the dialog.
              onTap: _navToSearch,
            ).paddingOnly(bottom: 8),
          ),
        ),

        // Revision Header.
        const SliverSectionHeader(header: StringC.revision),
        SliverPadding(
          padding: const EdgeInsets.only(left: 16),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: BlocBuilder(
                bloc: _dbCubit,
                builder: (context, state) {
                  List<TopicDm> topics = [];

                  if (state is CommonCubitStateLoading) {
                    return const CupertinoActivityIndicator().center();
                  } else if (state is CommonCubitStateLoaded) {
                    topics =
                        state.data.map((e) => TopicDm.fromJson(e)).toList();
                    topics.removeWhere(
                        (element) => element.scheduledTo == StringC.done);

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Completed revisions stat.
                        _StatCard(
                          subtitle: StringC.completed,
                          stat: state.data.length - topics.length,
                          link: StringC.view,
                          onLinkTap: () {},
                          color: ColorC.primaryComp,
                        ),
                        SizeC.spaceHorizontal5,
                        // Failed revision stat.
                        _StatCard(
                          subtitle: StringC.missed,
                          stat: topics
                              .where((e) =>
                                  DateTime.tryParse(e.scheduledTo ?? "")
                                      ?.isBefore(
                                    DateTimeC.todayTime.subtract(
                                      const Duration(days: 1),
                                    ),
                                  ) ??
                                  false)
                              .toList()
                              .length,
                          link: StringC.view,
                          onLinkTap: () {},
                          color: ColorC.buttonComp,
                        ),
                      ],
                    );
                  }

                  return SizeC.none;
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  // --------------------------------- Functions -------------------------------

  /// Default sliver padding.
  SliverPadding _sliverPadding(SliverToBoxAdapter child) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      sliver: child,
    );
  }

  /// To open the search friends dialog.
  void _navToSearch() async {
    List<Map<String, UserFBDm>>? reqsMade =
        await Navigator.of(context).push<List<Map<String, UserFBDm>>>(
      MaterialPageRoute(
        builder: (_) => const SearchPage(),
      ),
    );

    if (reqsMade == null || reqsMade.isEmpty) return;

    final User? currentU = BaseAuth.currentUser();

    for (Map<String, UserFBDm> user in reqsMade) {
      await BaseCloud.createSC(
        collection: CloudC.users,
        document: user.keys.first,
        subCollection: CloudC.requests,
        subDocument: currentU?.uid ?? '',
        data: ReqsDm(
          uuid: currentU?.uid,
          email: currentU?.email,
          name: currentU?.displayName,
          status: 0,
        ).toJson(),
      );
    }
  }
}

/// The stat card.
///
class _StatCard extends StatelessWidget {
  const _StatCard({
    Key? key,
    required this.stat,
    required this.subtitle,
    required this.link,
    required this.onLinkTap,
    required this.color,
  }) : super(key: key);

  final int stat;
  final String subtitle;
  final String link;
  final VoidCallback onLinkTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorC.boxDecorAll(radius: 10).copyWith(
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseText(
                stat.toString(),
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              TextButton(
                onPressed: onLinkTap,
                child: Row(
                  children: [
                    BaseText(link),
                    const Icon(Icons.keyboard_arrow_right_rounded)
                  ],
                ),
              ),
            ],
          ),
          BaseText(subtitle, color: ColorC.subtitle),
        ],
      ).paddingDefault(),
    );
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  /// The current visible screen in the dashboard.
  CurrentS _currentS = CurrentS.dashboard;

  /// Boolean to control the notifications.
  bool _newNotifications = false;

  /// Array that contains all the requests for the user.
  List<ReqsDm> _requests = [];

  /// Array that stores the friends of the user.
  List<QueryDocumentSnapshot<JSON>> _friends = [];

  @override
  void initState() {
    super.initState();
    _getFriends();
    _fetchReqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            _getS(),
            _bottomNavigation(context),
          ],
        ),
      ),
    );
  }

  // The bottom navigation.
  Positioned _bottomNavigation(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: SizedBox(
        width: AppConfig.width(context),
        height: 80,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(AppConfig.height(context), 80),
              painter: CustomNavigationPainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: BaseElevatedRoundedButton(
                backgroundColor: ColorC.elevatedButton,
                child: IconC.mainLogo,
                onPressed: () {
                  // Navigate to home screen.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteC.homePage, (route) => false);
                },
              ),
            ),
            SizedBox(
              height: 80,
              width: AppConfig.width(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dashboard.
                  _bottomNavButton(CurrentS.dashboard, _currentS,
                      icon: IconC.dashboard, additionalCB: () {}),
                  // Search.
                  _bottomNavButton(
                    CurrentS.progress,
                    _currentS,
                    icon: IconC.progress,
                    additionalCB: () {},
                  ),
                  (AppConfig.width(context) * 0.20).separation(false),
                  // Notifications.
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      _bottomNavButton(CurrentS.notifications, _currentS,
                          icon: IconC.notification, additionalCB: () {
                        _newNotifications = false;
                      }),
                      _newNotifications
                          ? Positioned(
                              bottom: -0,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorC.secondary),
                                height: 5,
                                width: 5,
                              ),
                            )
                          : SizeC.none,
                    ],
                  ),
                  // Profile.
                  _bottomNavButton(CurrentS.profile, _currentS,
                      icon: IconC.profile, additionalCB: () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Bottom navigation buttons.
  IconButton _bottomNavButton(
    CurrentS val,
    CurrentS grpVal, {
    required Icon icon,
    required VoidCallback additionalCB,
  }) {
    return IconButton(
      onPressed: () {
        _currentS = val;
        additionalCB();
        setState(() {});
      },
      icon: icon,
      color: val == grpVal ? ColorC.button : ColorC.white,
    );
  }

  // -----------------------Functions-------------------------------------------

  /// To get the current screen.
  Widget _getS() {
    switch (_currentS) {
      case CurrentS.dashboard:
        return const _DashBoardPage();
      case CurrentS.progress:
        return Container();
      case CurrentS.profile:
        return ProfilePage(
          friends: _friends.map((e) => FriendDm.fromJson(e)).toList(),
        );
      case CurrentS.notifications:
        return NotificationsPage(req: _requests);
      default:
        return const _DashBoardPage();
    }
  }

  /// Function to fetch the number of requests.
  void _fetchReqs() async {
    List<QueryDocumentSnapshot<JSON>> res = await BaseCloud.readSC(
      collection: CloudC.users,
      document: BaseAuth.currentUser()?.uid ?? "",
      subCollection: CloudC.requests,
    );

    // Mapping the response to [ReqDm] model.
    _requests = res.map((e) => ReqsDm.fromJson(e.data())).toList();

    if (_requests.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _newNotifications = true;
        setState(() {});
      });
    }
  }

  /// To get the friends of the current user.
  Future<void> _getFriends() async {
    _friends = await BaseCloud.readSC(
      collection: CloudC.users,
      document: BaseAuth.currentUser()?.uid ?? "",
      subCollection: CloudC.friends,
    );
  }
}

class CustomNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double x = size.width;
    final double y = size.height;

    Paint paint = Paint()
      ..color = ColorC.primary
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, 20);

    path.quadraticBezierTo(x * 0.20, 0, x * 0.35, 0);
    path.quadraticBezierTo(x * 0.40, 0, x * 0.40, 20);
    path.arcToPoint(
      Offset(x * 0.60, 20),
      radius: const Radius.circular(20.0),
      clockwise: false,
    );
    path.quadraticBezierTo(x * 0.60, 0, x * 0.65, 0);
    path.quadraticBezierTo(x * 0.80, 0, x, 20);
    path.lineTo(x, y);
    path.lineTo(0, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
