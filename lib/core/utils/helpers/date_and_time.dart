import 'package:intl/intl.dart';

class MyDateAndTimeFunction {
  // Returns the current date in the format 'dd-MM-yyyy'
  static String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  // Returns the current time in the format 'h:mm a' (e.g., 5:30 PM)
  static String getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(now);
  }

  // Returns the current date and time in the format 'dd-MM-yyyy HH:mm:ss'
  static String getCurrentFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    return formatter.format(now);
  }

  // Extracts and returns only the date part from a given datetime string (format: 'dd-MM-yyyy HH:mm:ss')
  static String extractDateFromDateTime(String dateTimeString) {
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    DateTime dateTime = formatter.parse(dateTimeString);
    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    return dateFormatter.format(dateTime);
  }

  // Extracts and returns only the time part from a given datetime string (format: 'dd-MM-yyyy HH:mm:ss')
  static String extractTimeFromDateTime(String dateTimeString) {
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    DateTime dateTime = formatter.parse(dateTimeString);
    DateFormat timeFormatter = DateFormat('HH:mm:ss');
    return timeFormatter.format(dateTime);
  }

  // Formats the given DateTime object into a string with the specified format (default: 'dd-MM-yyyy')
  static String formatDateToString(DateTime date, {String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).format(date);
  }

  // Returns the current day of the week (e.g., Monday, Tuesday)
  static String getCurrentDayOfWeek() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  // Takes day, month, and year and formats them into a string ('dd-MM-yyyy')
  static String formatDateFromComponents(int day, int month, int year) {
    DateTime date = DateTime(year, month, day);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  // Converts a date string (format: 'dd-MM-yyyy') to a more readable format (e.g., '5 Mar 2024')
  static String formatToReadableDate(String dateString) {
    try {
      // Define the input date format
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateTime dateTime = inputFormat.parse(dateString);

      // Define the output date format (more readable format)
      DateFormat outputFormat = DateFormat('d MMM yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      // If parsing fails, return an error message
      print("Error parsing date: $e");
      return "Invalid Date";
    }
  }
  static DateTime convertStringToDateTime(String dateString) {
    try {
      // Attempt to parse the date string
      final DateTime parsedDate = DateTime.parse(dateString);
      return parsedDate;
    } catch (e) {
      // Handle error if the string cannot be parsed
      throw FormatException("Invalid date string format: $dateString");
    }
  }

}
