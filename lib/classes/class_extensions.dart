import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/logic_blocks.dart';
import '/classes/enumerations.dart';

extension BooleanCopy on bool {
  bool get copy => this;
  bool get COPY => this;
}

extension StringCopy on String {
  String get copy => this;
  String get COPY => this;
}

extension DoubleCopy on double {
  double get copy => this;
  double get COPY => this;
}

extension ListExtension on List {
  dynamic get second => elementAt(1);

  dynamic get third => elementAt(2);
}

bool not(bool booleanValue) => !booleanValue;

extension ColorExtension on Color {
  Color get copy => Color.fromARGB(alpha, red, green, blue);
}

class TypeConversion {
  static String STRING_FROM_DURATION(Duration DURATION) => DURATION.toString();

  static Duration DURATION_FROM_STRING(String STRING) {
    List<String> li = STRING.split(':');
    int hours = int.parse(li[0]);
    int minutes = int.parse(li[1]);
    List<String> secondAndMicroseconds = li.last.split('.');
    int seconds = int.parse(secondAndMicroseconds[0]);
    int microseconds = int.parse(secondAndMicroseconds[1]);
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      microseconds: microseconds,
    );
  }

  static String STRING_FROM_DATETIME(DateTime DATETIME) {
    return DATETIME.toString();
  }

  static DateTime DATETIME_FROM_STRING(String STRING) {
    List<String> DATE_AND_TIME = STRING.split(' ');
    String REVERSE_DATE = DATE_AND_TIME.first;
    List<String> HH_MM_SS_MS = (DATE_AND_TIME.last).split('.');
    List<String> YYYY_MONTH_DAY = REVERSE_DATE.split('-');
    int YEAR = int.parse(YYYY_MONTH_DAY[0]);
    int MONTH = int.parse(YYYY_MONTH_DAY[1]);
    int DAY = int.parse(YYYY_MONTH_DAY[2]);

    List<String> HH_MM_SS = (HH_MM_SS_MS[0]).split(':');
    int HOUR = int.parse(HH_MM_SS[0]);
    int MINUTE = int.parse(HH_MM_SS[1]);
    int SECOND = int.parse(HH_MM_SS[2]);

    int MILLISECOND = 0;
    int MICROSECOND = 0;

    if (HH_MM_SS_MS[1].length == 3) {
      MILLISECOND = int.parse(HH_MM_SS_MS[1]);
    } else if (HH_MM_SS_MS[1].length == 6) {
      MICROSECOND = int.parse(HH_MM_SS_MS[1]);
    }

    return DateTime(
        YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, MILLISECOND, MICROSECOND);
  }

  static String STRING_FROM_BOOL(bool BOOL) {
    return BOOL.toString();
  }

  static bool BOOL_FROM_STRING(String STRING) {
    switch (STRING) {
      case 'false':
        return false;
      case 'true':
        return true;
      default:
        throw Exception('value of input should be either "true" or "false"');
    }
  }

  static String STRING_FROM_TIMERBASE(TimerBase TIMERBASE) {
    return TIMERBASE.toString();
  }

  static TimerBase TIMERBASE_FROM_STRING(String STRING) {
    switch (STRING) {
      case 'TimerBase.hour':
        return TimerBase.hour;
      case 'TimerBase.minute':
        return TimerBase.minute;
      case 'TimerBase.one':
        return TimerBase.one;
      case 'TimerBase.ten':
        return TimerBase.ten;
      case 'TimerBase.zeroPointOne':
        return TimerBase.zeroPointOne;
      default:
        throw Exception(
            'value of input string does not match any value of enum TimerBase');
    }
  }

  static String STRING_FROM_PORT_TYPE(PortType PORT_TYPE) {
    return PORT_TYPE.toString();
  }

  static PortType PORT_TYPE_FROM_STRING(String STRING) {
    switch (STRING) {
      case 'PortType.boolean':
        return PortType.boolean;
      case 'PortType.doubleInteger':
        return PortType.doubleInteger;
      case 'PortType.integer':
        return PortType.integer;
      case 'PortType.real':
        return PortType.real;
      default:
        throw Exception('string contains value other than PortType');
    }
  }

  static String STRING_FROM_INTEGER(Integer INTEGER) {
    return INTEGER.VALUE.toString();
  }

  static Integer INTEGER_FROM_STRING(String STRING) {
    return Integer.FROM_INT(int.parse(STRING));
  }

  static String STRING_FROM_REAL(Real REAL) {
    return REAL.VALUE.toString();
  }

  static Real REAL_FROM_STRING(String STRING) {
    return Real.FROM_DOUBLE(double.parse(STRING));
  }

  static String STRING_FROM_INT(int INT) {
    return INT.toString();
  }

  static int INT_FROM_STRING(String STRING) {
    return int.parse(STRING);
  }
}
