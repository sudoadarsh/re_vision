import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_widgets/base_confirmation_dialog.dart';
import 'package:re_vision/base_widgets/base_expanded_section.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/common_cubit/common__cubit.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/attachment_data_dm.dart';
import 'package:re_vision/models/friend_dm.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/models/topic_dm.dart';
import 'package:re_vision/modules/topic_page/topic_page.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/state_management/topic/topic_repo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../base_shared_prefs/base_shared_prefs.dart';
import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_bottom_modal_sheet.dart';
import '../../base_widgets/base_rounded_elevated_button.dart';
import '../../base_widgets/base_table_calendar.dart';
import '../../constants/date_time_constants.dart';
import '../../constants/decoration_constants.dart';
import '../../constants/size_constants.dart';
import '../../models/schemas.dart';
import '../../models/topic_user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';
import '../../utils/social_auth/base_auth.dart';
import '../friends/friends_page.dart';

class _Cards extends StatelessWidget {
  const _Cards({
    Key? key,
    required this.topic,
    required this.databaseCubit,
    required this.selectedDay,
    required this.onRevisionShared,
  }) : super(key: key);

  final TopicDm topic;
  final CommonCubit databaseCubit;
  final DateTime selectedDay;
  final VoidCallback onRevisionShared;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(
              RouteC.topicPage,
              arguments: TopicPageArguments(
                selectedDay: selectedDay,
                topicDm: topic,
              ),
            )
            .then((value) => databaseCubit.fetchData());
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizeC.spaceVertical5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LevelChip(iteration: topic.iteration ?? 0),
                (topic.label != null && topic.label!.isNotEmpty)
                    ? TopicLabelChip(label: topic.label!)
                    : SizeC.none
              ],
            ),
            BaseText(topic.topic ?? ''),
            const BaseText(
              StringC.tapToSeeMore,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // The user group.
                topic.isOnline == 1
                    ? BaseElevatedRoundedButton(
                        onPressed: () {},
                        child: IconC.userGrp,
                      )
                    : SizeC.none,
                // complete a task.
                BaseElevatedRoundedButton(
                  onPressed: () async {
                    bool? done = await showDialog(
                          context: context,
                          builder: (_) => _confirmDialog(
                            _,
                            title: StringC.completeAlert,
                            assetName: StringC.lottieComplete,
                          ),
                        ) ??
                        false;
                    done ? _completeTask() : null;
                  },
                  child: IconC.complete,
                ),
                // delete a task.
                BaseElevatedRoundedButton(
                  onPressed: () async {
                    bool? done = await showDialog(
                          context: context,
                          builder: (_) => _confirmDialog(
                            _,
                            title: StringC.deleteAlert,
                            assetName: StringC.lottieDelete,
                          ),
                        ) ??
                        false;
                    done ? _deleteTask() : null;
                  },
                  child: IconC.delete,
                ),
                // share the task.
                BaseElevatedRoundedButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => BaseModalSheetWithNotch(
                        context: _,
                        child: _ShareOptions(
                          topic: topic,
                          onRevisionShare: onRevisionShared,
                        ),
                      ),
                    );
                  },
                  child: IconC.share,
                ),
              ],
            ),
          ],
        ).paddingOnly(left: 8, right: 8, bottom: 8),
      ).paddingHorizontal8(),
    );
  }

  // Complete the task.
  Future<void> _completeTask() async {
    try {
      await BaseSqlite.update(
        tableName: StringC.topicTable,
        data: topic.iteration != 3
            ? topic.copyWith(
                iteration: (topic.iteration ?? 0) + 1,
                scheduledTo: _getDuration(),
              )
            : topic.copyWith(scheduledTo: StringC.done),
        where: StringC.id,
        whereArgs: topic.id,
      );
      databaseCubit.fetchData();
    } catch (e) {
      debugPrint(e.toString());
      // todo: handle error.
    }
  }

  // Delete the task.
  Future<void> _deleteTask() async {
    try {
      await BaseSqlite.delete(
        tableName: StringC.topicTable,
        where: StringC.id,
        whereArgs: topic.id,
      );
      databaseCubit.fetchData();
    } catch (e) {
      debugPrint(e.toString());
      // todo: catch error.
    }
  }

  // To get scheduled to time.
  String _getDuration() {
    int iteration = topic.iteration ?? 1;

    String returnString;

    switch (iteration) {
      case 1:
        returnString = DateTime.parse(topic.scheduledTo!)
            .add(const Duration(days: 1))
            .toString();
        break;
      case 2:
        returnString = DateTime.parse(topic.scheduledTo!)
            .add(const Duration(days: 7))
            .toString();
        break;
      default:
        returnString = StringC.done;
        break;
    }
    return returnString;
  }

  // The Dialog to display for confirmation of delete/completion.
  BaseConfirmationDialog _confirmDialog(
    BuildContext context, {
    required String assetName,
    required String title,
  }) {
    return BaseConfirmationDialog(
        title: title, content: Lottie.asset(assetName, height: 80, width: 80));
  }
}

/// The modified level chips.
class LevelChip extends StatelessWidget {
  const LevelChip({Key? key, required this.iteration}) : super(key: key);

  final int iteration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorC.boxDecorAll(radius: 10.0)
          .copyWith(color: _getColor(iteration)),
      child: BaseText(
        'Level $iteration',
        fontWeight: FontWeight.w500,
        color: _getTxTColor(iteration),
      ).paddingHorizontal8(),
    );
  }

  /// To get the correct color for the iteration label.
  Color _getColor(int iteration) {
    switch (iteration) {
      case 1:
        return ColorC.bronze;
      case 2:
        return ColorC.silver;
      case 3:
        return ColorC.gold;
      default:
        return ColorC.secondaryComp;
    }
  }

  Color _getTxTColor(int iteration) {
    switch (iteration) {
      case 1:
        return ColorC.bronzeD;
      case 2:
        return ColorC.silverD;
      case 3:
        return ColorC.goldD;
      default:
        return ColorC.secondaryComp;
    }
  }
}

/// The topic Label chip.
class TopicLabelChip extends StatelessWidget {
  const TopicLabelChip({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          DecorC.boxDecorAll(radius: 10.0).copyWith(color: ColorC.primary),
      child: BaseText(
        label,
        fontWeight: FontWeight.w500,
        color: ColorC.secondaryComp,
      ).paddingHorizontal8(),
    );
  }
}

/// The share options.
///
class _ShareOptions extends StatelessWidget {
  const _ShareOptions({
    Key? key,
    required this.topic,
    required this.onRevisionShare,
  }) : super(key: key);

  final TopicDm topic;
  final VoidCallback onRevisionShare;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: [
          // To share attachments to friends.
          ListTile(
            title: const BaseText(StringC.shareRevision),
            leading: IconC.mainLogoMin,
            onTap: onRevisionShare,
          ),
          // To share attachments view other media.
          ListTile(
            title: const BaseText(StringC.shareAttachments),
            leading: IconC.attachments,
            onTap: () => _shareAttachments(context),
          ),
        ],
      ),
    );
  }

  // -------------------------------- Functions --------------------------------

  /// Method to share attachments.
  void _shareAttachments(BuildContext context) {
    try {
      List<dynamic> data = jsonDecode(topic.attachments ?? '');
      List<AttachmentDataDm> dataDm = data
          .map((e) => AttachmentDataDm.fromJson(e))
          .toList()
        ..where((element) => element.type != 0);

      if (dataDm.isEmpty) return;

      Share.shareXFiles(dataDm.map((e) => XFile(e.data ?? "")).toList());
    } on Exception catch (e) {
      debugPrint("Error while sharing attachments: $e");
      showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const BaseText(StringC.oops),
            content: const BaseText(StringC.errorShareAttach),
            actions: [
              CupertinoDialogAction(
                child: const BaseText(StringC.ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class _TopicCards extends StatefulWidget {
  final List<TopicDm> topics;
  final CommonCubit databaseCubit;
  final DateTime selectedDay;
  final List<QueryDocumentSnapshot<JSON>> friends;

  const _TopicCards({
    required this.topics,
    required this.databaseCubit,
    required this.selectedDay,
    required this.friends,
  });

  @override
  State<_TopicCards> createState() => _TopicCardsState();
}

class _TopicCardsState extends State<_TopicCards> {
  late final List<FriendDm> data;
  late final User? cUser;

  @override
  void initState() {
    super.initState();
    cUser = BaseAuth.currentUser();
    data = widget.friends.map((e) => FriendDm.fromJson(e.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.topics.length,
      itemBuilder: (context, index) {
        return _Cards(
          topic: widget.topics[index],
          databaseCubit: widget.databaseCubit,
          selectedDay: widget.selectedDay,
          onRevisionShared: () async {
            var reqsSent = await Navigator.of(context).pushNamed(
              RouteC.friendsPage,
              arguments:
                  FriendsPageArguments(title: StringC.sendToFr, frs: data),
            );

            if (reqsSent == null) return;

            _addSentReqs(index, reqsSent as List<FriendDm>);
            _updateCRevision(index);
          },
        );
      },
    );
  }

  /// Add revision sent requests to respective users.
  void _addSentReqs(int index, List<FriendDm> reqs) async {
    try {
      List data = jsonDecode(widget.topics[index].attachments ?? "");

      List<AttachmentDataDm> dataDmArr =
          data.map((e) => AttachmentDataDm.fromJson(e)).toList();

      List<AttachmentDataDm> filteredData =
          dataDmArr.where((element) => element.type == 0).toList();

      TopicDm topic =
          widget.topics[index].copyWith(attachments: jsonEncode(filteredData));

      // Add the revision data in the topics collection.
      await BaseCloud.create(
        collection: CloudC.topic,
        document: widget.topics[index].id ?? "",
        data: {StringC.revision: topic.toJson()},
      );

      // Add the current user in the users sub-collection of users.
      await BaseCloud.createSC(
        collection: CloudC.topic,
        document: widget.topics[index].id ?? "",
        subCollection: CloudC.users,
        subDocument: cUser?.uid ?? "",
        data: TopicUserDm(
          name: cUser?.displayName,
          email: cUser?.email,
          uuid: cUser?.uid,
          status: 0,
        ).toJson(),
      );

      // Add the rest of the users in the sub-collection as well.
      // Send invite requests to other users as well.
      for (FriendDm fr in reqs) {
        await BaseCloud.createSC(
          collection: CloudC.topic,
          document: widget.topics[index].id ?? "",
          subCollection: CloudC.users,
          subDocument: fr.uuid ?? "",
          data: TopicUserDm(
            name: fr.name,
            email: fr.email,
            uuid: fr.uuid,
            status: 0,
          ).toJson(),
        );

        await BaseCloud.createSC(
          collection: CloudC.users,
          document: fr.uuid ?? "",
          subCollection: CloudC.requests,
          subDocument: widget.topics[index].id ?? "",
          data: ReqsDm(
                  topic: widget.topics[index].topic,
                  primaryId: widget.topics[index].id,
                  name: cUser?.displayName,
                  email: cUser?.email,
                  status: 0,
                  uuid: cUser?.uid)
              .toJson(),
        );
      }
    } on Exception catch (e) {
      // TODO: cannot share revision.
      debugPrint(e.toString());
    }
  }

  /// Update the isOnline field of the current revision.
  void _updateCRevision(int index) async {
    TopicDm topic = widget.topics[index].copyWith(isOnline: 1);

    await BaseSqlite.update(
      tableName: StringC.topicTable,
      data: topic,
      where: StringC.id,
      whereArgs: topic.id,
    );

    widget.databaseCubit.fetchData();
  }
}

/// Widget o show when the number of revision is empty.
///
class _EmptyTopics extends StatelessWidget {
  const _EmptyTopics({
    Key? key,
    required this.isPast,
    required this.onPressed,
  }) : super(key: key);

  final bool isPast;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(StringC.lottieNoTopics),
        isPast
            ? SizeC.none
            : InkWell(
                onTap: onPressed,
                child: Card(
                  shape: DecorC.roundedRectangleBorder,
                  child: const BaseText(
                    StringC.noTopics,
                    fontWeight: FontWeight.w300,
                  ).paddingDefault(),
                ),
              ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;

  // The database cubit.
  late final CommonCubit _databaseCubit;

  // To store the topics for all the days.
  List<TopicDm> _topics = [];

  // The list of labels of the visible topics.
  List<String?> _labels = [];

  // The list of selected labels.
  List<String> _selectedLabels = [];

  // To store the friends of the current user.
  List<QueryDocumentSnapshot<JSON>> _friends = [];

  // Page controller to swipe between dates.
  late PageController _dateController;

  // Boolean to control the calendar expansion.
  late bool _calendarVisible;

  // To store the initial index for the page view controller.
  int initialPage = -1;

  @override
  void initState() {
    _calendarVisible = false;

    _getFriends();

    _focusedDay = DateTimeC.todayTime;
    _selectedDay = DateTimeC.getTodayDateFormatted();
    _calendarFormat = CalendarFormat.week;

    _databaseCubit = CommonCubit(TopicRepo());

    _databaseCubit.fetchData();

    _createDatabase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = DateTimeC.reformatSelectedDate(_selectedDay) ==
        DateTimeC.getTodayDateFormatted().toString();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isInnerScrolled) {
          return [
            // The app bar.
            SliverAppBar.large(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const BaseText(StringC.revision),
              actions: [
                // Navigate to dashboard page.
                Card(
                  shape: DecorC.roundedRectangleBorder,
                  child: IconButton(
                    color: ColorC.primary,
                    onPressed: () {
                      if (BaseAuth.currentUser() != null) {
                        Navigator.of(context).pushNamed(RouteC.dashboard);
                        return;
                      }
                      _loginRequest();
                    },
                    icon: IconC.dashboard,
                  ),
                ),

                // Navigate to the add topic screen.
                Card(
                  shape: DecorC.roundedRectangleBorder,
                  child: IconButton(
                    onPressed: _navigateToTopicPage,
                    icon: IconC.add,
                  ),
                )
              ],
            ),

            // Today's Topic section.
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BaseText(
                    isToday ? StringC.todaySTopic : StringC.topics,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                  Row(
                    children: [
                      Card(
                        shape: DecorC.roundedRectangleBorder,
                        elevation: _calendarVisible ? 4.0 : 1.0,
                        child: IconButton(
                          color: ColorC.primary,
                          onPressed: isToday
                              ? null
                              : () {
                                  _dateController.animateToPage(
                                    initialPage,
                                    duration: DateTimeC.cd300,
                                    curve: Curves.easeIn,
                                  );
                                  _selectedDay =
                                      DateTimeC.getTodayDateFormatted();
                                  sst();
                                },
                          icon: IconC.goToToday,
                        ),
                      ),
                      Card(
                        shape: DecorC.roundedRectangleBorder,
                        elevation: _calendarVisible ? 4.0 : 1.0,
                        child: IconButton(
                          color: ColorC.primary,
                          onPressed: () {
                            _calendarVisible = !_calendarVisible;
                            sst();
                          },
                          icon: IconC.calendar,
                        ),
                      ),
                    ],
                  )
                ],
              ).paddingOnly(left: 16, right: 4),
            ),

            // The calendar.
            SliverToBoxAdapter(
              child: BaseExpandedSection(
                expand: _calendarVisible,
                child: Column(
                  children: [
                    CustomCalendarHeader(
                      focusedDay: _selectedDay,
                      onLeftArrowTap: () {
                        _dateController.previousPage(
                            duration: DateTimeC.cd300, curve: Curves.easeIn);
                      },
                      onRightArrowTap: () {
                        _dateController.nextPage(
                            duration: DateTimeC.cd300, curve: Curves.easeIn);
                      },
                    ).paddingOnly(left: 16),
                    BaseTableCalendar(
                            onCalendarCreated: (controller) {
                              return _dateController = controller;
                            },
                            headerVisible: false,
                            selectedDay: _selectedDay,
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            onDaySelected: (selectedDay, focusedDay) {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                              _labels = filterTopics(_selectedDay)
                                  .map((e) => e.label)
                                  .where((e) => e != null)
                                  .toList();
                              sst();
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: _calendarStyle,
                            eventLoader: (day) {
                              return filterTopics(day);
                            },
                            calendarBuilders: _calendarBuilders())
                        .paddingOnly(left: 3, right: 3),
                  ],
                ),
              ),
            ),

            // The labels.
            if (_labels.isNotEmpty) SliverPadding(
              padding: const EdgeInsets.only(left: 10),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _labels.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          if (_selectedLabels.contains(_labels[i])) {
                            _selectedLabels.remove(_labels[i]);
                            sst();
                            return;
                          }

                          _selectedLabels.add(_labels[i]!);
                          sst();
                        },
                        child: Chip(
                          avatar: _selectedLabels.contains(_labels[i])
                              ? const CircleAvatar(
                                  backgroundColor: ColorC.white,
                                  foregroundColor: ColorC.primary,
                                  child: IconC.complete,
                                )
                              : null,
                          elevation: 4,
                          label: BaseText(
                            _labels[i] ?? "",
                            color: ColorC.secondaryComp,
                            fontSize: 12,
                          ),
                          backgroundColor: ColorC.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ];
        },
        body: BlocConsumer(
          bloc: _databaseCubit,
          listener: (context, state) {
            if (state is CommonCubitStateLoaded) {
              List data = state.data;
              _topics = data.map((e) => TopicDm.fromJson(e)).toList();

              _labels = filterTopics(_selectedDay)
                  .map((e) => e.label)
                  .where((e) => e != null)
                  .toList();

              initialPage.isNegative
                  ? initialPage = _dateController.page?.toInt() ?? 0
                  : null;

              sst();
            }
          },
          builder: (context, state) {
            if (state is CommonCubitStateLoading) {
              return const CupertinoActivityIndicator().center();
            }

            // Getting the filtered topics for the day.
            List<TopicDm> filteredTopics = filterTopics(_selectedDay);

            if (_selectedLabels.isNotEmpty) {
              filteredTopics = filteredTopics
                  .where((e) => _selectedLabels.contains(e.label))
                  .toList();
            }

            return filteredTopics.isEmpty
                ? SingleChildScrollView(
                    child: _EmptyTopics(
                      isPast: _selectedDay.isBefore(
                        DateTimeC.todayTime.subtract(const Duration(days: 1)),
                      ),
                      onPressed: _navigateToTopicPage,
                    ),
                  )
                : _TopicCards(
                    topics: filteredTopics,
                    databaseCubit: _databaseCubit,
                    selectedDay: _selectedDay,
                    friends: _friends,
                  );
          },
        ),
      ),
    );
  }

  // ------------------------------ Functions ----------------------------------

  void sst() => setState(() {});

  void _navigateToTopicPage() {
    Navigator.of(context)
        .pushNamed(
          RouteC.topicPage,
          arguments: TopicPageArguments(selectedDay: _selectedDay),
        )
        .then((value) => _databaseCubit.fetchData());
  }

  final CalendarStyle _calendarStyle = CalendarStyle(
    selectedDecoration: DecorC.circleShape.copyWith(color: ColorC.secondary),
    todayDecoration: DecorC.circleShape.copyWith(color: ColorC.primary),
    markersAlignment: Alignment.bottomRight,
  );

  // To create the database.
  Future _createDatabase() async {
    bool exists = BaseSharedPrefsSingleton.getBool(StringC.localDbKey) ?? false;
    if (!exists) {
      debugPrint('Creating database.');
      /* Set the shared prefs value that the database has been created. */
      await BaseSharedPrefsSingleton.setValue(
        StringC.localDbKey,
        true,
      );
      /* Create the topic table. */
      await BaseSqlite.createTable(
        tableName: StringC.topicTable,
        model: Schemas.topicSchema,
      );
    }
  }

  // To filter the topics according to the selected date.
  List<TopicDm> filterTopics(DateTime date) {
    List<TopicDm> filteredTasks = _topics
        .where((element) =>
            element.scheduledTo == DateTimeC.reformatSelectedDate(date))
        .toList();
    return filteredTasks;
  }

  // Custom calendar builder.
  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(markerBuilder: (context, date, events) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorC.secondaryComp,
        ),
        child: events.isNotEmpty
            ? BaseText(
                events.length.toString(),
                fontSize: 12.0,
                color: ColorC.white,
              ).paddingAll4()
            : const SizedBox.shrink(),
      );
    });
  }

  // To get the friends of the current user.
  Future<void> _getFriends() async {
    _friends = BaseAuth.currentUser() == null
        ? []
        : await BaseCloud.readSC(
            collection: CloudC.users,
            document: BaseAuth.currentUser()?.uid ?? "",
            subCollection: CloudC.friends,
          );
  }

  // Dialog asking the user to log into revision app.
  Future<void> _loginRequest() async {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const BaseText(StringC.appName),
        content: Column(
          children: [
            Lottie.asset(StringC.lottieGoSocial, height: 200),
            const BaseText(
              StringC.goSocial,
              maxLines: 3,
            )
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const BaseText(StringC.login),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteC.loginPage);
            },
          ),
          CupertinoDialogAction(
            child: const BaseText(StringC.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
