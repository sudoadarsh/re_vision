import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/common_cubit/common__cubit.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/topic_dm.dart';
import 'package:re_vision/modules/topic_page/topic_page.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/state_management/topic/topic_repo.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../base_shared_prefs/base_shared_prefs.dart';
import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_rounded_elevated_button.dart';
import '../../base_widgets/base_table_calendar.dart';
import '../../constants/date_time_constants.dart';
import '../../constants/decoration_constants.dart';
import '../../models/schemas.dart';

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar(
      {Key? key, required this.selectedDay, required this.databaseCubit})
      : super(key: key);

  final DateTime selectedDay;
  final CommonCubit databaseCubit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const BaseText(StringConstants.empty),
      backgroundColor: ColorConstants.primary,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              RouteConstants.topicPage,
              arguments: TopicPageArguments(selectedDay: selectedDay),
            ).then((value) => databaseCubit.fetchData());
          },
          icon: const Icon(Icons.add_circle, color: ColorConstants.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _Cards extends StatelessWidget {
  const _Cards({Key? key, required this.topic}) : super(key: key);

  final TopicDm topic;

  static const Widget _divider =
  Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Card(
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
            StringConstants.tapToSeeMore,
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BaseElevatedRoundedButton(
                  onPressed: () {}, child: IconConstants.complete),
              BaseElevatedRoundedButton(
                  onPressed: () {}, child: IconConstants.delete)
            ],
          )
        ],
      ).paddingDefault(),
    );
  }
}

class _TopicCards extends StatelessWidget {
  final List<TopicDm> topics;

  const _TopicCards({required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _Cards(topic: topics[index]);
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
    _focusedDay = DateTimeConstants.todayTime;
    _selectedDay = DateTimeConstants.getTodayDateFormatted();
    _calendarFormat = CalendarFormat.week;

    _databaseCubit = CommonCubit(TopicRepo());

    _databaseCubit.fetchData();

    _createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(selectedDay: _selectedDay, databaseCubit: _databaseCubit),
      body: Column(
        children: [
          BaseTableCalendar(
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
            calendarBuilders : _calendarBuilders()
          ),
          Flexible(
            child: BlocConsumer(
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
                return _TopicCards(topics: filteredTopics);
              },
            ),
          )
        ],
      ),
    );
  }

  void sst() => setState(() {});

  final CalendarStyle _calendarStyle = CalendarStyle(
    selectedDecoration: DecorationConstants.circleShape
        .copyWith(color: ColorConstants.secondary),
    todayDecoration:
    DecorationConstants.circleShape.copyWith(color: ColorConstants.primary),
    markersAlignment: Alignment.bottomRight,
  );

  // To create the database.
  Future _createDatabase() async {
    bool exists =
        BaseSharedPrefsSingleton.getBool(StringConstants.localDbKey) ?? false;
    if (!exists) {
      debugPrint('Creating database.');
      /* Set the shared prefs value that the database has been created. */
      await BaseSharedPrefsSingleton.setValue(
        StringConstants.localDbKey,
        true,
      );
      /* Create the topic table. */
      await BaseSqlite.createTable(
        tableName: StringConstants.topicTable,
        model: Schemas.topicSchema,
      );
    }
  }

  // To filter the topics according to the selected date.
  List<TopicDm> filterTopics(DateTime date) {
    List<TopicDm> filteredTasks = _topics
        .where((element) =>
    element.scheduledTo == DateTimeConstants.reformatSelectedDate(date))
        .toList();
    return filteredTasks;
  }

  // Custom calendar builder.
  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(markerBuilder: (context, date, events) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.button,
        ),
        child: events.isNotEmpty
            ? BaseText(
          events.length.toString(),
          fontSize: 12.0,
          color: ColorConstants.secondary,
        ).paddingAll4()
            : const SizedBox.shrink(),
      );
    });
  }

}
