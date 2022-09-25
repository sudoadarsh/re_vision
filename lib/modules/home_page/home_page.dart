import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../base_shared_prefs/base_shared_prefs.dart';
import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_rounded_elevated_button.dart';
import '../../base_widgets/base_table_calendar.dart';
import '../../constants/date_time_constants.dart';
import '../../constants/decoration_constants.dart';
import '../../models/schemas.dart';

class _AppBar {
  static PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const BaseText(StringConstants.empty),
      backgroundColor: ColorConstants.primary,
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to add/ update topic page.
            Navigator.of(context).pushNamed(RouteConstants.topicPage);
          },
          icon: IconConstants.add,
          color: ColorConstants.button,
        )
      ],
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({Key? key}) : super(key: key);

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _divider,
              BaseText(
                'Level 1',
                fontWeight: FontWeight.w300,
                fontSize: 16.0,
              ),
              _divider
            ],
          ),
          const BaseText('Topic information and data.'),
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

class _TopicCards extends StatefulWidget {
  const _TopicCards({Key? key}) : super(key: key);

  @override
  State<_TopicCards> createState() => _TopicCardsState();
}

class _TopicCardsState extends State<_TopicCards> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return const _Cards();
        },
      ),
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

  @override
  void initState() {
    _focusedDay = DateTimeConstants.todayTime;
    _selectedDay = DateTimeConstants.getTodayDateFormatted();
    _calendarFormat = CalendarFormat.week;

    _createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar.appBar(context),
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
            // eventLoader: (day) {
            //   // todo: to build the notifications
            // },
          ),
          const _TopicCards()
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

  Future _createDatabase() async {
    bool? exists =
    BaseSharedPrefsSingleton.checkKey(StringConstants.localDbKey);

    switch (exists) {
      case true:
        return null;
      default:
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

}
