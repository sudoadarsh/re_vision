import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import '../constants/date_time_constants.dart';

class BaseTableCalendar extends StatelessWidget {
  const BaseTableCalendar({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    this.onFormatChanged,
    this.onDaySelected,
    this.onPageChanged,
    this.eventLoader,
    this.calendarStyle, this.calendarBuilders,
  }) : super(key: key);

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;

  final Function(CalendarFormat)? onFormatChanged;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(DateTime)? onPageChanged;
  final List<dynamic> Function(DateTime)? eventLoader;
  final CalendarStyle? calendarStyle;
  final CalendarBuilders? calendarBuilders;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week'
      },
      calendarFormat: calendarFormat,
      onFormatChanged: onFormatChanged,
      calendarStyle: calendarStyle ?? const CalendarStyle(),
      focusedDay: focusedDay,
      firstDay: DateTimeC.firstDay,
      lastDay: DateTimeC.lastDay,
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      eventLoader: eventLoader,
      calendarBuilders: calendarBuilders ?? const CalendarBuilders(),
    );
  }
}
