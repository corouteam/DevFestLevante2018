import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatTime(DateTime dateTime) {
    final dateFormat = new DateFormat('HH:mm');

    return dateFormat.format(dateTime);
  }

  static String formatSimpleDate(DateTime dateTime) {
    final dateFormat = DateFormat('EEE d');

    return dateFormat.format(dateTime);
  }

  static String formatTalkDateTimeStart(DateTime dateTime) {
    final dateFormat = new  DateFormat.MMMEd("en_US").add_jm();
    return dateFormat.format(dateTime);
  }

  static String formatTalkTimeEnd(DateTime dateTime) {
    final dateFormat = new  DateFormat('HH:mm a');
    return dateFormat.format(dateTime);
  }
}