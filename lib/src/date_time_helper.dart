// Package imports:
import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime getDateTimeFromTimeStamp({required int givenTimeStamp}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(givenTimeStamp * 1000);
    return dateTime;
  }
}

String _ABBR_MONTH = 'MMM';
String _DAY = 'd';
String _ABBR_WEEKDAY = 'E';
String _WEEKDAY = 'EEEE';
String _ABBR_STANDALONE_MONTH = 'LLL';
String _STANDALONE_MONTH = 'LLLL';
String _NUM_MONTH = 'M';
String _NUM_MONTH_DAY = 'Md';
String _NUM_MONTH_WEEKDAY_DAY = 'MEd';
String _ABBR_MONTH_DAY = 'MMMd';
String _ABBR_MONTH_WEEKDAY_DAY = 'MMMEd';
String _MONTH = 'MMMM';
String _MONTH_DAY = 'MMMMd';
String _MONTH_WEEKDAY_DAY = 'MMMMEEEEd';
String _ABBR_QUARTER = 'QQQ';
String _QUARTER = 'QQQQ';
String _YEAR = 'y';
String _YEAR_NUM_MONTH = 'yM';
String _YEAR_NUM_MONTH_DAY = 'yMd';
String _YEAR_NUM_MONTH_WEEKDAY_DAY = 'yMEd';
String _YEAR_ABBR_MONTH = 'yMMM';
String _YEAR_ABBR_MONTH_DAY = 'yMMMd';
String _YEAR_ABBR_MONTH_WEEKDAY_DAY = 'yMMMEd';
String _YEAR_MONTH = 'yMMMM';
String _YEAR_MONTH_DAY = 'yMMMMd';
String _YEAR_MONTH_WEEKDAY_DAY = 'yMMMMEEEEd';
String _YEAR_ABBR_QUARTER = 'yQQQ';
String _YEAR_QUARTER = 'yQQQQ';
String _HOUR24 = 'H';
String _HOUR24_MINUTE = 'Hm';
String _HOUR24_MINUTE_SECOND = 'Hms';
String _HOUR = 'j';
String _HOUR_MINUTE = 'jm';
String _HOUR_MINUTE_SECOND = 'jms';

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
extension DateTimeExtension on DateTime {
  /// Convert DateTime to String
  ///
  /// 2020-04-03T11:57:00
  String toDateTimeString() {
    return DateFormat('yyyy-MM-ddThh:mm:ss').format(this);
  }

  /// DATE TIME CUSTOME FORMATTER
  String toCustomFormatter({DateTimeFormatter? formatter}) {
    switch (formatter) {
      case DateTimeFormatter.DDMMYYYY:
        return DateFormat('dd-MM-yyyy').format(this);

      case DateTimeFormatter.DDMMMYYYY:
        return DateFormat('dd-MMM-yyyy').format(this);

      case DateTimeFormatter.ABBR_MONTH:
        return DateFormat(_ABBR_MONTH).format(this);

      case DateTimeFormatter.DAY:
        return DateFormat(_DAY).format(this);

      case DateTimeFormatter.ABBR_WEEKDAY:
        return DateFormat(_ABBR_WEEKDAY).format(this);

      case DateTimeFormatter.WEEKDAY:
        return DateFormat(_WEEKDAY).format(this);

      case DateTimeFormatter.ABBR_STANDALONE_MONTH:
        return DateFormat(_ABBR_STANDALONE_MONTH).format(this);

      case DateTimeFormatter.STANDALONE_MONTH:
        return DateFormat(_STANDALONE_MONTH).format(this);

      case DateTimeFormatter.NUM_MONTH:
        return DateFormat(_NUM_MONTH).format(this);

      case DateTimeFormatter.NUM_MONTH_DAY:
        return DateFormat(_NUM_MONTH_DAY).format(this);

      case DateTimeFormatter.NUM_MONTH_WEEKDAY_DAY:
        return DateFormat(_NUM_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.ABBR_MONTH_DAY:
        return DateFormat(_ABBR_MONTH_DAY).format(this);

      case DateTimeFormatter.ABBR_MONTH_WEEKDAY_DAY:
        return DateFormat(_ABBR_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.MONTH:
        return DateFormat(_MONTH).format(this);

      case DateTimeFormatter.MONTH_DAY:
        return DateFormat(_MONTH_DAY).format(this);

      case DateTimeFormatter.MONTH_WEEKDAY_DAY:
        return DateFormat(_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.ABBR_QUARTER:
        return DateFormat(_ABBR_QUARTER).format(this);

      case DateTimeFormatter.QUARTER:
        return DateFormat(_QUARTER).format(this);

      case DateTimeFormatter.YEAR:
        return DateFormat(_YEAR).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH:
        return DateFormat(_YEAR_NUM_MONTH).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH_DAY:
        return DateFormat(_YEAR_NUM_MONTH_DAY).format(this);

      case DateTimeFormatter.YEAR_NUM_MONTH_WEEKDAY_DAY:
        return DateFormat(_YEAR_NUM_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH:
        return DateFormat(_YEAR_ABBR_MONTH).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH_DAY:
        return DateFormat(_YEAR_ABBR_MONTH_DAY).format(this);

      case DateTimeFormatter.YEAR_ABBR_MONTH_WEEKDAY_DAY:
        return DateFormat(_YEAR_ABBR_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.YEAR_MONTH:
        return DateFormat(_YEAR_MONTH).format(this);

      case DateTimeFormatter.YEAR_MONTH_DAY:
        return DateFormat(_YEAR_MONTH_DAY).format(this);

      case DateTimeFormatter.YEAR_MONTH_WEEKDAY_DAY:
        return DateFormat(_YEAR_MONTH_WEEKDAY_DAY).format(this);

      case DateTimeFormatter.YEAR_ABBR_QUARTER:
        return DateFormat(_YEAR_ABBR_QUARTER).format(this);

      case DateTimeFormatter.YEAR_QUARTER:
        return DateFormat(_YEAR_QUARTER).format(this);

      case DateTimeFormatter.HOUR24:
        return DateFormat(_HOUR24).format(this);

      case DateTimeFormatter.HOUR24_MINUTE:
        return DateFormat(_HOUR24_MINUTE).format(this);

      case DateTimeFormatter.HOUR24_MINUTE_SECOND:
        return DateFormat(_HOUR24_MINUTE_SECOND).format(this);

      case DateTimeFormatter.HOUR:
        return DateFormat(_HOUR).format(this);

      case DateTimeFormatter.HOUR_MINUTE:
        return DateFormat(_HOUR_MINUTE).format(this);

      case DateTimeFormatter.HOUR_MINUTE_SECOND:
        return DateFormat(_HOUR_MINUTE_SECOND).format(this);

      default:
        return DateFormat('yyyy-MM-ddThh:mm:ss').format(this);
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
