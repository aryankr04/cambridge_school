import 'package:intl/intl.dart'; // Import for date formatting and parsing

enum Month {
  january(label: 'January', shortName: 'Jan', monthNumber: 1),
  february(label: 'February', shortName: 'Feb', monthNumber: 2),
  march(label: 'March', shortName: 'Mar', monthNumber: 3),
  april(label: 'April', shortName: 'Apr', monthNumber: 4),
  may(label: 'May', shortName: 'May', monthNumber: 5),
  june(label: 'June', shortName: 'Jun', monthNumber: 6),
  july(label: 'July', shortName: 'Jul', monthNumber: 7),
  august(label: 'August', shortName: 'Aug', monthNumber: 8),
  september(label: 'September', shortName: 'Sep', monthNumber: 9),
  october(label: 'October', shortName: 'Oct', monthNumber: 10),
  november(label: 'November', shortName: 'Nov', monthNumber: 11),
  december(label: 'December', shortName: 'Dec', monthNumber: 12);

  const Month({
    required this.label,
    required this.shortName,
    required this.monthNumber,
  });

  final String label;
  final String shortName;
  final int monthNumber;

  static List<String> labelsList(){
    return Month.values.map((status) => status.label).toList();

  }

  static Month fromString(String monthName) {
    return Month.values.firstWhere(
          (month) => month.label.toLowerCase() == monthName.toLowerCase(),
    );
  }

  static Month fromMonthNumber(int monthNumber) {
    return Month.values.firstWhere(
          (month) => month.monthNumber == monthNumber,
    );
  }

  String formatted(String pattern, int year) {
    final DateTime dateTime = DateTime(year, monthNumber);
    final DateFormat formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  DateTime getFirstDayOfYear(int year) => DateTime(year, monthNumber, 1);

  DateTime getLastDayOfYear(int year) =>
      DateTime(year, monthNumber + 1, 0); // Day 0 of next month

  int getDaysInMonth(int year) =>
      DateTime(year, monthNumber + 1, 0).day;
}