// Package imports:
import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime getDateTimeFromTimeStamp({required int givenTimeStamp}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(givenTimeStamp * 1000);
    return dateTime;
  }
}

String abbrMonth = 'MMM';
String days = 'd';
String abbrWeekday = 'E';
String weekday = 'EEEE';
String abbrStandaloneMonth = 'LLL';
String standaloneMonth = 'LLLL';
String numMonth = 'M';
String numMonthDay = 'Md';
String numMonthWeekdayDay = 'MEd';
String abbrMonthDay = 'MMMd';
String abbrMonthWeekdayDay = 'MMMEd';
String months = 'MMMM';
String monthDay = 'MMMMd';
String monthWeekdayDay = 'MMMMEEEEd';
String abbrQuarter = 'QQQ';
String quarter = 'QQQQ';
String years = 'y';
String yearNumMonth = 'yM';
String yearNumMonthDay = 'yMd';
String yearNumMonthWeekdayDay = 'yMEd';
String yearAbbrMonth = 'yMMM';
String yearAbbrMonthDay = 'yMMMd';
String yearAbbrMonthWeekdayDay = 'yMMMEd';
String yearMonth = 'yMMMM';
String yearMonthDay = 'yMMMMd';
String yearMonthWeekdayDay = 'yMMMMEEEEd';
String yearAbbrQuarter = 'yQQQ';
String yearQuarter = 'yQQQQ';
String hour24 = 'H';
String hour24Minute = 'Hm';
String hour24MinuteSecond = 'Hms';
String hour = 'j';
String hourMinute = 'jm';
String hourMinuteSecond = 'jms';

enum DateTimeFormatter {
  /// 06-10-2022
  DDMMYYYY,

  /// 06-Oct-2022
  DDMMMYYYY,

  /// MMM
  ABBR_MONTH,

  /// d
  DAY,

  /// E
  ABBR_WEEKDAY,

  /// EEEE
  WEEKDAY,

  /// LLL
  ABBR_STANDALONE_MONTH,

  /// LLLL
  STANDALONE_MONTH,

  ///M
  NUM_MONTH,

  ///Md
  NUM_MONTH_DAY,

  ///MEd
  NUM_MONTH_WEEKDAY_DAY,

  ///MMMd
  ABBR_MONTH_DAY,

  ///MMMEd
  ABBR_MONTH_WEEKDAY_DAY,

  ///MMMM
  MONTH,

  /// MMMMd
  MONTH_DAY,

  ///MMMMEEEEd
  MONTH_WEEKDAY_DAY,

  ///QQQ
  ABBR_QUARTER,

  ///QQQQ
  QUARTER,

  ///y
  YEAR,

  ///yM
  YEAR_NUM_MONTH,

  /// yMd
  YEAR_NUM_MONTH_DAY,

  ///yMEd
  YEAR_NUM_MONTH_WEEKDAY_DAY,

  ///yMMM
  YEAR_ABBR_MONTH,

  ///yMMMd
  YEAR_ABBR_MONTH_DAY,

  ///yMMMEd
  YEAR_ABBR_MONTH_WEEKDAY_DAY,

  ///yMMMM
  YEAR_MONTH,

  ///yMMMMd
  YEAR_MONTH_DAY,

  ///yMMMMEEEEd
  YEAR_MONTH_WEEKDAY_DAY,

  ///yQQQ
  YEAR_ABBR_QUARTER,

  ///yQQQQ
  YEAR_QUARTER,

  ///H
  HOUR24,

  ///Hm
  HOUR24_MINUTE,

  ///Hms
  HOUR24_MINUTE_SECOND,

  ///j
  HOUR,

  ///jm
  HOUR_MINUTE,

  ///jms
  HOUR_MINUTE_SECOND,
}

/// Extension for DateTime
/// Extension for DateTime
extension DateTimeExtension on DateTime {
  /// Convert DateTime to String
  ///
  /// 2020-04-03T11:57:00
  String toDateTimeString() {
    return DateFormat('yyyy-MM-ddThh:mm:ss').format(this);
  }

  /// DATE TIME CUSTOM FORMATTER
  String toCustomFormatter({DateTimeFormatter? formatter, String? customFormat}) {
    switch (formatter) {
      case DateTimeFormatter.DDMMYYYY:
        return DateFormat('dd-MM-yyyy').format(this);

      case DateTimeFormatter.DDMMMYYYY:
        return DateFormat('dd-MMM-yyyy').format(this);

      case DateTimeFormatter.ABBR_MONTH:
        return DateFormat(abbrMonth).format(this);

      case DateTimeFormatter.DAY:
        return DateFormat(days).format(this);

      case DateTimeFormatter.ABBR_WEEKDAY:
        return DateFormat(abbrWeekday).format(this);

      case DateTimeFormatter.WEEKDAY:
        return DateFormat(weekday).format(this);

      case DateTimeFormatter.ABBR_STANDALONE_MONTH:
        return DateFormat(abbrStandaloneMonth).format(this);

      case DateTimeFormatter.STANDALONE_MONTH:
        return DateFormat(standaloneMonth).format(this);

      case DateTimeFormatter.NUM_MONTH:
        return DateFormat(numMonth).format(this);

      case DateTimeFormatter.NUM_MONTH_DAY:
        return DateFormat(numMonthDay).format(this);

      case DateTimeFormatter.NUM_MONTH_WEEKDAY_DAY:
        return DateFormat(numMonthWeekdayDay).format(this);

      case DateTimeFormatter.ABBR_MONTH_DAY:
        return DateFormat(abbrMonthDay).format(this);

      case DateTimeFormatter.ABBR_MONTH_WEEKDAY_DAY:
        return DateFormat(abbrMonthWeekdayDay).format(this);

      case DateTimeFormatter.MONTH:
        return DateFormat(months).format(this);

      case DateTimeFormatter.MONTH_DAY:
        return DateFormat(monthDay).format(this);

      case DateTimeFormatter.MONTH_WEEKDAY_DAY:
        return DateFormat(monthWeekdayDay).format(this);

      case DateTimeFormatter.ABBR_QUARTER:
        return DateFormat(abbrQuarter).format(this);

      case DateTimeFormatter.QUARTER:
        return DateFormat(quarter).format(this);

      case DateTimeFormatter.YEAR:
        return DateFormat(years).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH:
        return DateFormat(yearNumMonth).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH_DAY:
        return DateFormat(yearNumMonthDay).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH_WEEKDAY_DAY:
        return DateFormat(yearNumMonthWeekdayDay).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH:
        return DateFormat(yearAbbrMonth).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH_DAY:
        return DateFormat(yearAbbrMonthDay).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH_WEEKDAY_DAY:
        return DateFormat(yearAbbrMonthWeekdayDay).format(this);

      case DateTimeFormatter.YEAR_MONTH:
        return DateFormat(yearMonth).format(this);

      case DateTimeFormatter.YEAR_MONTH_DAY:
        return DateFormat(yearMonthDay).format(this);

      case DateTimeFormatter.YEAR_MONTH_WEEKDAY_DAY:
        return DateFormat(yearMonthWeekdayDay).format(this);

      case DateTimeFormatter.YEAR_ABBR_QUARTER:
        return DateFormat(yearAbbrQuarter).format(this);

      case DateTimeFormatter.YEAR_QUARTER:
        return DateFormat(yearQuarter).format(this);

      case DateTimeFormatter.HOUR24:
        return DateFormat(hour24).format(this);

      case DateTimeFormatter.HOUR24_MINUTE:
        return DateFormat(hour24Minute).format(this);

      case DateTimeFormatter.HOUR24_MINUTE_SECOND:
        return DateFormat(hour24MinuteSecond).format(this);

      case DateTimeFormatter.HOUR:
        return DateFormat(hour).format(this);

      case DateTimeFormatter.HOUR_MINUTE:
        return DateFormat(hourMinute).format(this);

      case DateTimeFormatter.HOUR_MINUTE_SECOND:
        return DateFormat(hourMinuteSecond).format(this);

      default:
        return DateFormat(customFormat??'yyyy-MM-ddThh:mm:ss').format(this);
    }
  }

  // Check this is now
  bool isToday() {
    final now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime dayCheck = DateTime(year, month, day);
    return today == dayCheck;
  }

  // Check this is yesterday
  bool isYesterday() {
    final now = DateTime.now();
    final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    final DateTime dayCheck = DateTime(year, month, day);
    return yesterday == dayCheck;
  }
}
