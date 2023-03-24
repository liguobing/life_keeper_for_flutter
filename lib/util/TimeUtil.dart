import 'package:flutter/services.dart';

class TimeUtil {
  ///获取当日开始时间
  static num getStartOfCurrentDay() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    var dateTime = DateTime(year, month, day, 0, 0, 0, 0, 0);
    return dateTime.millisecondsSinceEpoch;
  }

  ///获取当日结束时间
  static num getEndOfCurrentDay() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    var dateTime = DateTime(year, month, day, 23, 59, 59, 999, 999);
    return dateTime.millisecondsSinceEpoch;
  }

  ///获取指定日期开始时间
  static num getStartOfDay(int year, int month, int day) {
    DateTime time = DateTime(year, month, day, 0, 0, 0, 0, 0);
    return time.millisecondsSinceEpoch;
  }

  ///获取指定日期结束时间
  static num getEndOfDay(int year, int month, int day) {
    DateTime time = DateTime(year, month, day, 23, 59, 59, 999, 999);
    return time.millisecondsSinceEpoch;
  }

  ///获取当月开始时间
  static num getStartOfCurrentMonth() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    var dateTime = DateTime(year, month, 1, 0, 0, 0, 0, 0);
    return dateTime.millisecondsSinceEpoch;
  }

  ///获取当月结束时间
  static num getEndOfCurrentMonth() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    var dateTime = DateTime(year, month + 1, 1, 23, 59, 59, 999, 999);
    return dateTime.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
  }

  ///获取某年某月一共有多少天
  static int getDaysOfMonth(int year, int month) {
    int days = 0;
    if (month != 2) {
      switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
          days = 31;
          break;
        case 4:
        case 6:
        case 9:
        case 11:
          days = 30;
      }
    } else {
      // 闰年
      if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
        days = 29;
      else
        days = 28;
    }
    return days;
  }

  ///将数据库内保存的数值时间转为"时:分"时间
  static String doubleTimeToString(num time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    int hour = dateTime.hour;
    String hourStr = hour >= 10 ? "$hour" : "0$hour";
    int minute = dateTime.minute;
    String minuteStr = minute >= 10 ? "$minute" : "0$minute";
    return "$hourStr:$minuteStr";
  }

  ///将 long 时间转为 年-月-日 星期几
  static String doubleTimeToYearMonthDayWeek(DateTime time) {
    int year = time.year;
    int month = time.month;
    int day = time.day;
    int week = time.weekday;
    List<String> weeksEnglish = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
    String monthStr = month > 9 ? "$month" : "0$month";
    String dayStr = day > 9 ? "$day" : "0$day";
    String weekStr = weeksEnglish[week - 1];
    return "$year-$monthStr-$dayStr $weekStr";
  }

  ///将 long 时间转为 年-月-日
  static String doubleTimeToYearMonthDay(DateTime time) {
    int year = time.year;
    int month = time.month;
    int day = time.day;
    String monthStr = month > 9 ? "$month" : "0$month";
    String dayStr = day > 9 ? "$day" : "0$day";
    return "$year-$monthStr-$dayStr";
  }

  ///将 long 时间转为时:分
  static String doubleTimeToHourMinute(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String hourStr = hour > 9 ? "$hour" : "0$hour";
    String minuteStr = minute > 9 ? "$minute" : "0$minute";
    return "$hourStr:$minuteStr";
  }

  ///从 DateTime 中获取年月日的 long 值
  static int dateTimeToLong(DateTime time) {
    DateTime dt = DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
    return dt.millisecondsSinceEpoch;
  }

  ///是否超过当前时间
  static bool greaterCurrentDay(DateTime dateTime) {
    DateTime currTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0);
    int currentMilliseconds = currTime.millisecondsSinceEpoch;
    return dateTime.millisecondsSinceEpoch > currentMilliseconds;
  }

  ///获取某年某月的开始时间
  static int getStartOfMonth(int year, int month) {
    DateTime time = DateTime(year, month, 1, 0, 0, 0, 0, 0);
    return time.millisecondsSinceEpoch;
  }

  ///获取某年某月的结束时间
  static int getEndOfMonth(int year, int month) {
    int count = getDaysOfMonth(year, month);
    DateTime time = DateTime(year, month, count, 23, 59, 59, 999, 999);
    return time.millisecondsSinceEpoch;
  }
}
