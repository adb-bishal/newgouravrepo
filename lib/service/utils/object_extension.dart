import 'package:flutter/foundation.dart';
import 'dart:developer' as devtools show log;

extension LogPrint on Object {
  void printLog({String? message}) => {
        if (kDebugMode) {devtools.log("${message ?? ''}${toString()}")}
      };
}

extension DateTimeExtension on DateTime {
  operator >(DateTime other) {
    if (identical(this, other)) return false;

    if (year > other.year) return true;
    if (month > other.month) return true;
    if (day > other.day) return true;
    if (hour > other.hour) return true;
    if (minute > other.minute) return true;
    if (second > other.second) return true;
    if (millisecond > other.millisecond) return true;
    if (microsecond > other.microsecond) return true;

    return false;
  }
}
