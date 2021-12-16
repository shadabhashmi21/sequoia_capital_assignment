import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String dateFormatDDMMYYYY = "dd-MM-yyyy";
  static const String dateFormatYYYYMMDD = "yyyy-MM-dd";

  static String convertDateTimeToString(
      DateTime dateTime, String outputPattern) {
    return DateFormat(outputPattern).format(dateTime);
  }
}
