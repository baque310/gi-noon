import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noon/core/localization/language.dart';

extension DateExtension on DateTime {
  bool get isToday =>
      year == DateTime.now().year &&
      month == DateTime.now().month &&
      day == DateTime.now().day;

  bool get isYesterday =>
      year == DateTime.now().year &&
      month == DateTime.now().month &&
      day == DateTime.now().day - 1;

  String get formatDateToYearMonthDay {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get formatDateToYearMonthDayWithTime {
    String timeFormat = DateFormat('hh:mm').format(this);
    return '${DateFormat('yyyy-MM-dd').format(this)}  $timeFormat';
  }

  String get formatDateTime {
    String timeFormat = DateFormat('hh:mm').format(this);
    return timeFormat;
  }

  String get formatDateTimeWithAmPm {
    return '$formatDateTime $formatAmPm';
  }

  String get formatAmPm {
    var ampm = DateFormat('a').format(this).toUpperCase();
    return ampm == 'AM' ? AppLanguage.am.tr : AppLanguage.pm.tr;
  }

  String get getDayFromDate {
    return DateFormat.EEEE().format(this);
  }
}
