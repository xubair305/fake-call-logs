import 'package:intl/intl.dart';

class AppDatetimeFormatter {
  /// Formats the given [date] into a string in the format 'DD/MM/YYYY'.
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else {
      return DateFormat('EEEE d MMMM').format(dateTime);
    }
  }

  /// Converts the given [timestamp] into a DateTime object.
  static DateTime dateTimeFromInt(int? timestamp) {
    if (timestamp == null) return DateTime.now();
    final parsedDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime(parsedDateTime.year, parsedDateTime.month, parsedDateTime.day);
  }

  /// Returns a string representing the duration in the format 'HH:MM:SS'.
  static String getFormattedDurationText(int? durationInSeconds) {
    if (durationInSeconds == null) return '00:00';
    final duration = Duration(seconds: durationInSeconds);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  /// Converts the given [timestamp] into a DateTime object then into formated Time.
  static String formatIntoAmPm(int? timestamp) {
    if (timestamp == null) return '';
    final parsedDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.jm().format(parsedDateTime);
  }
}
