import 'package:intl/intl.dart';

/// A utility class for formatting Dart `DateTime` objects into various string representations.
class MyDateTimeFormatter {
  /// Private constructor to prevent instantiation.  This class is meant to
  /// be used statically.
  MyDateTimeFormatter._();

  /// Predefined date formatters for common formats.  You can also create
  /// custom formats using `DateFormat`.

  /// Short date format: dd/MM/yyyy (e.g., 05/03/2024)
  static final DateFormat europeanShortDate = DateFormat('dd/MM/yyyy');

  /// Long date format: d MMMM, yyyy (e.g., 5 March, 2024)
  static final DateFormat prettyLongDate = DateFormat('d MMMM, yyyy');

  /// Short date and time: dd/MM/yyyy H:mm (e.g., 05/03/2024 14:45) - 24-hour time
  static final DateFormat europeanShortDateTime = DateFormat('dd/MM/yyyy H:mm');

  /// Long date and time: MMMM d, yyyy h:mm (e.g., March 5, 2024 2:45) - 12-hour time
  static final DateFormat americanLongDateTime = DateFormat('MMMM d, yyyy h:mm');

  /// ISO 8601 format: yyyy-MM-ddTHH:mm:ss.SSSZ (e.g., 2024-03-05T14:45:30.123Z)
  static final DateFormat iso8601 = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');

  /// Time only: H:mm:ss (e.g., 14:45:30) - 24-hour time
  static final DateFormat twentyFourHourTime = DateFormat('H:mm:ss');

  /// Time only with AM/PM: H:mm a (e.g., 14:45 PM) - 12-hour time
  static final DateFormat twelveHourTime = DateFormat('H:mm a');

  ///  Date and time format: d MMMM yyyy 'at' h:mm a (e.g., 5 March 2024 at 2:45 PM)
  static final DateFormat prettyDateTime = DateFormat('d MMMM yyyy \'at\' h:mm a');



  /// Formats a `DateTime` object to a short date string (dd/MM/yyyy).
  ///
  /// Returns the formatted string.  Returns an empty string if `dateTime` is null.
  static String formatEuropeanShortDate(DateTime? dateTime) {
    return dateTime == null ? '' : europeanShortDate.format(dateTime);
  }

  /// Formats a `DateTime` object to a long date string (d MMMM, yyyy).
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatPrettyLongDate(DateTime? dateTime) {
    return dateTime == null ? '' : prettyLongDate.format(dateTime);
  }

  /// Formats a `DateTime` object to a short date and time string (dd/MM/yyyy H:mm).
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatEuropeanShortDateTime(DateTime? dateTime) {
    return dateTime == null ? '' : europeanShortDateTime.format(dateTime);
  }

  /// Formats a `DateTime` object to a long date and time string (MMMM d, yyyy h:mm).
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatAmericanLongDateTime(DateTime? dateTime) {
    return dateTime == null ? '' : americanLongDateTime.format(dateTime);
  }

  /// Formats a `DateTime` object to an ISO 8601 string (yyyy-MM-ddTHH:mm:ss.SSSZ).
  ///
  /// Returns the formatted string.  Returns an empty string if `dateTime` is null.
  static String formatISO8601(DateTime? dateTime) {
    return dateTime == null ? '' : iso8601.format(dateTime.toUtc()); // Important: Convert to UTC for consistent ISO formatting
  }

  /// Formats a `DateTime` object to a time-only string (H:mm:ss).
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatTwentyFourHourTime(DateTime? dateTime) {
    return dateTime == null ? '' : twentyFourHourTime.format(dateTime);
  }

  /// Formats a `DateTime` object to a time-only string (H:mm a).
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatTwelveHourTime(DateTime? dateTime) {
    return dateTime == null ? '' : twelveHourTime.format(dateTime);
  }


  /// Formats a `DateTime` object to the custom format "d MMMM yyyy 'at' h:mm a".
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatPrettyDateTime(DateTime? dateTime) {
    return dateTime == null ? '' : prettyDateTime.format(dateTime);
  }


  /// Formats a `DateTime` object using a custom pattern.
  ///
  /// [dateTime]: The `DateTime` object to format.
  /// [pattern]: The `DateFormat` pattern string (e.g., 'EEEE, MMMM d, yyyy').  See the `intl` package documentation for details.
  ///
  /// Returns the formatted string. Returns an empty string if `dateTime` is null.
  static String formatCustom(DateTime? dateTime, String pattern) {
    if (dateTime == null) {
      return '';
    }
    try {
      final format = DateFormat(pattern);
      return format.format(dateTime);
    } catch (e) {
      print('Error formatting DateTime with pattern: $pattern. Error: $e');
      return ''; // Or handle the error in a more appropriate way
    }
  }

  /// Parses a string into a DateTime object using the specified format.
  ///
  /// [dateTimeString]: The string to parse.
  /// [pattern]: The `DateFormat` pattern string used to format the date time (e.g., 'EEEE, MMMM d, yyyy').  See the `intl` package documentation for details.
  ///
  /// Returns a `DateTime` object if the string is successfully parsed.
  /// Returns `null` if parsing fails.
  static DateTime? parseString(String? dateTimeString, String pattern) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }

    try {
      final format = DateFormat(pattern);
      return format.parse(dateTimeString);
    } catch (e) {
      print('Error parsing DateTime string: $dateTimeString with pattern: $pattern. Error: $e');
      return null; // Or handle the error in a more appropriate way
    }
  }
}