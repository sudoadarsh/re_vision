import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_widgets/base_cupertino_dialog.dart';
import 'package:re_vision/base_widgets/base_cupertino_dialog_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/common_cubit/common__cubit.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/attachment_data_dm.dart';
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
import '../../models/schemas.dart';

// class _AppBar extends StatelessWidget with PreferredSizeWidget {
//   const _AppBar(
//       {Key? key, required this.selectedDay, required this.databaseCubit})
//       : super(key: key);
//
//   final DateTime selectedDay;
//   final CommonCubit databaseCubit;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: const BaseText(StringConstants.empty),
//       backgroundColor: ColorConstants.primary,
//       actions: [
//         IconButton(
//           onPressed: () {
//             Navigator.of(context)
//                 .pushNamed(
//                   RouteConstants.topicPage,
//                   arguments: TopicPageArguments(selectedDay: selectedDay),
//                 )
//                 .then((value) => databaseCubit.fetchData());
//           },
//           icon: const Icon(Icons.add_circle, color: ColorConstants.white),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(56.0);
// }

class _Cards extends StatelessWidget {
  const _Cards(
      {Key? key,
      required this.topic,
      required this.databaseCubit,
      required this.selectedDay})
      : super(key: key);

  final TopicDm topic;
  final CommonCubit databaseCubit;
  final DateTime selectedDay;

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

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
            Row(
              children: [
                _divider,
                BaseText(
                  'Level ${topic.iteration}',
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0,
                ),
                _divider
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
                        child: _ShareOptions(topic: topic),
                      ),
                    );
                  },
                  child: IconC.share,
                ),
              ],
            ),
          ],
        ).paddingDefault(),
      ),
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
  BaseCupertinoDialog _confirmDialog(
    BuildContext context, {
    required String assetName,
    required String title,
  }) {
    return BaseCupertinoDialog(
      title: title,
      customContent: Lottie.asset(assetName, height: 80, width: 80),
      actions: [
        BaseCupertinoDialogButton(
            color: ColorC.primary,
            onTap: () {
              Navigator.of(context).pop(true);
            },
            title: StringC.ok),
        BaseCupertinoDialogButton(
            color: ColorC.secondary,
            onTap: () {
              Navigator.of(context).pop(false);
            },
            title: StringC.cancel),
      ],
    );
  }
}

/// The share options.
///
class _ShareOptions extends StatelessWidget {
  const _ShareOptions({Key? key, required this.topic}) : super(key: key);

  final TopicDm topic;

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
            onTap: () {},
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

class _TopicCards extends StatelessWidget {
  final List<TopicDm> topics;
  final CommonCubit databaseCubit;
  final DateTime selectedDay;

  const _TopicCards(
      {required this.topics,
      required this.databaseCubit,
      required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _Cards(
            topic: topics[index],
            databaseCubit: databaseCubit,
            selectedDay: selectedDay);
      },
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

  @override
  void initState() {
    print("home page called!");

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
    return Scaffold(
      // appBar: _AppBar(selectedDay: _selectedDay, databaseCubit: _databaseCubit),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorC.elevatedButton,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(
                RouteC.topicPage,
                arguments: TopicPageArguments(selectedDay: _selectedDay),
              )
              .then((value) => _databaseCubit.fetchData());
        },
        child: IconC.add,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isInnerScrolled) {
          return [
            SliverAppBar.large(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const BaseText(StringC.revision),
              actions: [
                // Navigate to dashboard page.
                IconButton(
                  color: ColorC.primary,
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            RouteC.dashboard, (route) => false),
                    icon: IconC.dashboard)
              ],
            ),
            SliverToBoxAdapter(
              child: BaseTableCalendar(
                  selectedDay: _selectedDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    sst();
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      _calendarFormat = format;
                      sst();
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: _calendarStyle,
                  eventLoader: (day) {
                    return filterTopics(day);
                  },
                  calendarBuilders: _calendarBuilders()),
            ),
          ];
        },
        body: BlocConsumer(
          bloc: _databaseCubit,
          listener: (context, state) {
            if (state is CommonCubitStateLoaded) {
              List data = state.data;
              _topics = data.map((e) => TopicDm.fromJson(e)).toList();
              sst();
            }
          },
          builder: (context, state) {
            if (state is CommonCubitStateLoading) {
              return const CupertinoActivityIndicator().center();
            }

            // Getting the filtered topics for the day.
            List<TopicDm> filteredTopics = filterTopics(_selectedDay);
            return _TopicCards(
              topics: filteredTopics,
              databaseCubit: _databaseCubit,
              selectedDay: _selectedDay,
            );
          },
        ),
      ),
    );
  }

  void sst() => setState(() {});

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
          color: ColorC.button,
        ),
        child: events.isNotEmpty
            ? BaseText(
                events.length.toString(),
                fontSize: 12.0,
                color: ColorC.secondary,
              ).paddingAll4()
            : const SizedBox.shrink(),
      );
    });
  }
}
