import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_notification_badge.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/dashboard/dashboard_view.dart';
import 'package:re_vision/modules/dashboard/widgets/db_app_bar.dart';
import 'package:re_vision/modules/notification/notifications_page.dart';
import 'package:re_vision/modules/profile/profile_page.dart';

import '../../base_widgets/base_depth_form_field.dart';
import '../../base_widgets/sliver_section_header.dart';
import '../../common_cubit/common__cubit.dart';
import '../../constants/date_time_constants.dart';
import '../../constants/icon_constants.dart';
import '../../constants/size_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/friend_dm.dart';
import '../../models/reqs_dm.dart';
import '../../models/topic_dm.dart';
import '../../models/user_dm.dart';
import '../../state_management/topic/topic_repo.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';
import '../overview/overview_page.dart';
import '../search_page/search_page.dart';

class BaseNavigator extends StatefulWidget {
  const BaseNavigator({Key? key}) : super(key: key);

  @override
  State<BaseNavigator> createState() => _BaseNavigatorState();
}

class _BaseNavigatorState extends State<BaseNavigator> {
  /// The selected page from the [BottomNavigationBar].
  late int _selectedIndex;

  /// The list of pages.
  late List<Widget> _pages;

  /// Array that stores the friends of the user.
  List<QueryDocumentSnapshot<JSON>> _friends = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _getFriends();

    _pages = [
      // The dashboard page.
      const DashboardPageV1(),
      // The notifications page.
      const NotificationsPage(),
      // The profile page.
      ProfilePage(friends: _friends.map((e) => FriendDm.fromJson(e)).toList()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // Dashboard navigation item.
          const BottomNavigationBarItem(
            icon: IconC.dashboard,
            label: StringC.dashboard,
          ),

          // The notification navigation item.
          BottomNavigationBarItem(
            icon: StreamBuilder(
              stream: BaseCloud.db
                  ?.collection(CloudC.users)
                  .doc(BaseAuth.currentUser()?.uid ?? "")
                  .collection(CloudC.requests)
                  .snapshots(),
              builder: (context, snap) {
                List<ReqsDm> data = [];
                if (snap.hasData) {
                  data = snap.data?.docs
                          .map((e) => ReqsDm.fromJson(e))
                          .where((e) => e.status == 0)
                          .toList() ??
                      [];
                }
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    IconC.notification,
                    data.isNotEmpty
                        ? const Positioned(
                            top: -2,
                            child: BaseNotificationBadge(),
                          )
                        : SizeC.none
                  ],
                );
              },
            ),
            label: StringC.notifications,
          ),

          // The profile navigation item.
          const BottomNavigationBarItem(
            icon: IconC.profile,
            label: StringC.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: ColorC.secondary,
        selectedIconTheme: const IconThemeData(size: 30),
        selectedItemColor: ColorC.primary,
        onTap: (i) {
          if (_selectedIndex == i) return;
          _selectedIndex = i;
          setState(() {});
        },
      ),
    );
  }

  // ---------------------------- Class methods --------------------------------
  /// To get the friends of the current user.
  Future<void> _getFriends() async {
    _friends = await BaseCloud.readSC(
      collection: CloudC.users,
      document: BaseAuth.currentUser()?.uid ?? "",
      subCollection: CloudC.friends,
    );
  }
}

class DashboardPageV1 extends StatefulWidget {
  const DashboardPageV1({Key? key}) : super(key: key);

  @override
  State<DashboardPageV1> createState() => DashboardPageV1State();
}

class DashboardPageV1State extends State<DashboardPageV1> with DashBoardView {
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
  void dispose() {
    super.dispose();
    _dbCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // The app bar.
        const DBAppBar(),

        // Search friends Text Form Field.
        _sliverPadding(
          SliverToBoxAdapter(
            child: BaseTextFormFieldWithDepth(
              hintText: StringC.findFriends,
              readOnly: true,
              prefixIcon: IconC.search,
              // Open up the dialog.
              onTap: () => _navToSearch(context),
            ).paddingOnly(bottom: 8),
          ),
        ),

        // Revision Header.
        const SliverSectionHeader(header: StringC.overview),

        // The completed and missed Revisions card.
        SliverPadding(
          padding: const EdgeInsets.only(left: 16),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: BlocBuilder(
                bloc: _dbCubit,
                builder: (context, state) {
                  List<TopicDm> completed = [];
                  List<TopicDm> missed = [];

                  if (state is CommonCubitStateLoading) {
                    return const CupertinoActivityIndicator().center();
                  } else if (state is CommonCubitStateLoaded) {
                    // Completed revisions.
                    completed = state.data
                        .map((e) => TopicDm.fromJson(e))
                        .toList()
                        .where((e) => e.scheduledTo == StringC.done)
                        .toList();

                    // Missed revisions.
                    missed = state.data
                        .map((e) => TopicDm.fromJson(e))
                        .toList()
                        .where((e) =>
                            DateTime.tryParse(e.scheduledTo ?? "")?.isBefore(
                              DateTimeC.todayTime.subtract(
                                const Duration(days: 1),
                              ),
                            ) ??
                            false)
                        .toList();

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Completed revisions stat.
                        statCard(
                          subtitle: StringC.completed,
                          stat: completed.length,
                          link: StringC.view,
                          color: ColorC.primary,
                          onLinkTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => OverViewPage(
                                        topics: completed,
                                        title: StringC.completed),
                                  ),
                                )
                                .whenComplete(() => _dbCubit.fetchData());
                          },
                        ),
                        SizeC.spaceHorizontal5,
                        // Failed revision stat.
                        statCard(
                          subtitle: StringC.missed,
                          stat: missed.length,
                          link: StringC.view,
                          color: ColorC.secondary,
                          onLinkTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (_) => OverViewPage(
                                      topics: missed, title: StringC.missed),
                                ))
                                .whenComplete(() => _dbCubit.fetchData());
                          },
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

  // ---------------------------- Class methods --------------------------------

  /// Default sliver padding.
  SliverPadding _sliverPadding(SliverToBoxAdapter child) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      sliver: child,
    );
  }

  /// To open the search friends dialog.
  void _navToSearch(BuildContext context) async {
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
          picURL: currentU?.photoURL,
          status: 0,
        ).toJson(),
      );
    }
  }
}
