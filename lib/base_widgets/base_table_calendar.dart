import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_vision/constants/icon_constants.dart';

import 'package:table_calendar/table_calendar.dart';

import '../constants/date_time_constants.dart';
import 'base_text.dart';

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
    this.calendarStyle,
    this.calendarBuilders,
    this.headerVisible, this.onCalendarCreated,
  }) : super(key: key);

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final bool? headerVisible;

  final Function(CalendarFormat)? onFormatChanged;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(DateTime)? onPageChanged;
  final List<dynamic> Function(DateTime)? eventLoader;
  final CalendarStyle? calendarStyle;
  final CalendarBuilders? calendarBuilders;
  final Function(PageController)? onCalendarCreated;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: headerVisible ?? true,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week'
      },
      onCalendarCreated: onCalendarCreated,
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

/// Custom header for the [BaseTableCalendar].
class CustomCalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const CustomCalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseText(
          DateFormat.yMMM().format(focusedDay),
          fontSize: 16,
        ),
        Row(
          children: [
            IconButton(onPressed: onLeftArrowTap, icon: IconC.arrowB),
            IconButton(onPressed: onRightArrowTap, icon: IconC.arrowF),
          ],
        )
      ],
    );
  }
}
