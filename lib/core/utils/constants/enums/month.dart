import 'package:intl/intl.dart'; // Import for date formatting and parsing

enum Month {
  january(name: 'January', shortName: 'Jan', monthNumber: 1),
  february(name: 'February', shortName: 'Feb', monthNumber: 2),
  march(name: 'March', shortName: 'Mar', monthNumber: 3),
  april(name: 'April', shortName: 'Apr', monthNumber: 4),
  may(name: 'May', shortName: 'May', monthNumber: 5),
  june(name: 'June', shortName: 'Jun', monthNumber: 6),
  july(name: 'July', shortName: 'Jul', monthNumber: 7),
  august(name: 'August', shortName: 'Aug', monthNumber: 8),
  september(name: 'September', shortName: 'Sep', monthNumber: 9),
  october(name: 'October', shortName: 'Oct', monthNumber: 10),
  november(name: 'November', shortName: 'Nov', monthNumber: 11),
  december(name: 'December', shortName: 'Dec', monthNumber: 12);

  const Month({
    required this.name,
    required this.shortName,
    required this.monthNumber,
  });

  final String name;
  final String shortName;
  final int monthNumber;

  static List<Month> getMonthList() {
    return Month.values; // Returns a list of all Month enum values
  }

  static Month? fromString(String monthName) {
    try {
      return Month.values.firstWhere(
          (month) => month.name.toLowerCase() == monthName.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  static Month? fromMonthNumber(int monthNumber) {
    try {
      return Month.values
          .firstWhere((month) => month.monthNumber == monthNumber);
    } catch (e) {
      return null;
    }
  }

  String formatted(String pattern, int year) {
    final DateTime dateTime = DateTime(year, monthNumber);
    final DateFormat formatter =
        DateFormat(pattern); // Use intl package for formatting
    return formatter.format(dateTime);
  }

  // Add more methods as needed:
  // Example: Get the first day of the month for a given year
  DateTime getFirstDayOfYear(int year) {
    return DateTime(year, monthNumber, 1);
  }

  // Example: Get the last day of the month for a given year
  DateTime getLastDayOfYear(int year) {
    return DateTime(year, monthNumber + 1,
        0); // Day 0 of next month is the last of this month
  }

  // Example: Get the number of days in the month for a given year
  int getDaysInMonth(int year) {
    return DateTime(year, monthNumber + 1, 0).day;
  }

}
