import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:table_calendar/table_calendar.dart';

import '../base_widgets/base_table_calendar.dart';
import '../constants/date_time_constants.dart';
import '../constants/decoration_constants.dart';

class _AppBar {
  static PreferredSizeWidget appBar() {
    return AppBar(
      title: const BaseText(StringConstants.empty),
      backgroundColor: ColorConstants.primary,
      actions: [
        IconButton(
          onPressed: () {},
          icon: IconConstants.add,
          color: ColorConstants.button,
        )
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

  @override
  void initState() {
    _focusedDay = DateTimeConstants.todayTime;
    _selectedDay = DateTimeConstants.getTodayDateFormatted();
    _calendarFormat = CalendarFormat.week;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar.appBar(),
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
}
