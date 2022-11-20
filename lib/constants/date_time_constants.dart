import 'package:intl/intl.dart';

class DateTimeC {
  static DateTime todayTime = DateTime.now();
  static DateTime firstDay = DateTime.utc(2022, 08, 06);
  static DateTime lastDay = DateTime.utc(2030, 3, 14);

  static DateTime getTodayDateFormatted() {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000';
    return DateTime.parse(formattedDate);
  }

  static DateTime subtractDays(int days) {
    return todayTime.subtract(Duration(days: days));
  }

  /* Function to reformat the selected date. */
  static String reformatSelectedDate(DateTime selectedDate) {
    return selectedDate.toString().replaceAll('Z', '');
  }

  /* Function to compare the time to today. */
  static bool compareTimeToToday(String? time) {
    try {
      DateTime timeParsed = DateTime.parse(time ?? '');
      return timeParsed.isBefore(
          DateTimeC.todayTime.subtract(const Duration(days: 1)));
    } catch (e) {
      return false;
    }
  }

  /// Constant duration of 500 ms.
  static const Duration cd500 = Duration(milliseconds: 500);

  /// Constant duration of 500 ms.
  static const Duration cd200 = Duration(milliseconds: 200);

  /// Today date in yMMMMd (String).
  static String yMMMdToday = DateFormat.yMMMMd('en_US').format(DateTime.now());
}
