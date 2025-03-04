import 'package:intl/intl.dart';
import 'dart:math' as math;

class UserAttendance {
  final DateTime academicPeriodStart;
  final String attendanceString;

  static const String validAttendanceChars = 'PAHLEN';

  UserAttendance({
    required this.academicPeriodStart,
    required this.attendanceString,
  }) : assert(
  attendanceString.isEmpty ||
      attendanceString.split('').every((char) => _isValidChar(char)),
  'Invalid attendance string: Contains invalid characters.',
  );

  static bool _isValidChar(String char) {
    return validAttendanceChars.contains(char);
  }

  // Factory method to create a UserAttendance instance with an empty string.
  factory UserAttendance.empty({
    required DateTime academicPeriodStart,
    required int numberOfDays,
  }) {
    assert(numberOfDays >= 0, 'Number of days cannot be negative.');
    final emptyString = ''.padRight(numberOfDays, 'N');
    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: emptyString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'academicPeriodStart': academicPeriodStart.toIso8601String(),
      'attendanceString': attendanceString,
    };
  }

  static UserAttendance? fromMap(Map<String, dynamic> map) {
    try {
      if (!map.containsKey('academicPeriodStart') ||
          !map.containsKey('attendanceString')) {
        return null;
      }

      return UserAttendance(
        academicPeriodStart: DateTime.parse(map['academicPeriodStart'] as String),
        attendanceString: map['attendanceString'] as String,
      );
    } catch (e) {
      print('Exception on UserAttendance fromMap: $e');
      return null;
    }
  }

  UserAttendance updateAttendance(DateTime date, String status) {
    if (!validAttendanceChars.contains(status)) {
      throw ArgumentError(
          'Invalid attendance status. Must be one of: $validAttendanceChars');
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final offset = normalizedDate.difference(academicPeriodStart).inDays;

    String newAttendanceString = attendanceString;
    DateTime newAcademicPeriodStart = academicPeriodStart;

    if (offset < 0) {
      final daysBefore = offset.abs();
      newAcademicPeriodStart = normalizedDate;
      newAttendanceString = status +
          ''.padRight(math.max(daysBefore - 1, 0), 'N') +
          attendanceString;
    } else if (offset >= attendanceString.length) {
      final daysToAdd = math.max(0, offset - attendanceString.length);
      newAttendanceString =
          attendanceString + ''.padRight(daysToAdd, 'N') + status;
    } else {
      newAttendanceString =
          attendanceString.replaceRange(offset, offset + 1, status);
    }

    return UserAttendance(
      academicPeriodStart: newAcademicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  UserAttendance updateMultiDateAttendance(
      DateTime startDate, DateTime endDate, String status) {
    if (!_isValidChar(status)) {
      throw ArgumentError(
          'Invalid attendance status: Must be one of $validAttendanceChars');
    }

    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must not be before start date.');
    }

    int startOffset = startDate.difference(academicPeriodStart).inDays;
    int endOffset = endDate.difference(academicPeriodStart).inDays;

    startOffset = math.max(0, startOffset);
    endOffset = math.max(endOffset, startOffset);

    String newAttendanceString = attendanceString;

    if (startOffset >= newAttendanceString.length) {
      newAttendanceString = newAttendanceString.padRight(startOffset, 'N');
    }

    if (endOffset >= newAttendanceString.length) {
      newAttendanceString = newAttendanceString.padRight(endOffset + 1, 'N');
    }

    newAttendanceString = newAttendanceString.replaceRange(
        startOffset, endOffset + 1, ''.padRight(endOffset - startOffset + 1, status));

    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  String getAttendanceStatus(DateTime date) {
    final offset = date.difference(academicPeriodStart).inDays;
    if (offset < 0 || offset >= attendanceString.length) {
      return 'N';
    }
    return attendanceString[offset];
  }

  Map<String, int> calculateAttendanceSummary() {
    if (attendanceString.isEmpty) {
      return {
        'Present': 0,
        'Absent': 0,
        'Holiday': 0,
        'Late': 0,
        'Excused': 0,
        'Not Applicable': 0,
      };
    }

    final summary = <String, int>{
      'Present': 0,
      'Absent': 0,
      'Holiday': 0,
      'Late': 0,
      'Excused': 0,
      'Not Applicable': 0,
    };

    for (final char in attendanceString.split('')) {
      switch (char) {
        case 'P':
          summary['Present'] = (summary['Present'] ?? 0) + 1;
          break;
        case 'A':
          summary['Absent'] = (summary['Absent'] ?? 0) + 1;
          break;
        case 'H':
          summary['Holiday'] = (summary['Holiday'] ?? 0) + 1;
          break;
        case 'L':
          summary['Late'] = (summary['Late'] ?? 0) + 1;
          break;
        case 'E':
          summary['Excused'] = (summary['Excused'] ?? 0) + 1;
          break;
        case 'N':
          summary['Not Applicable'] = (summary['Not Applicable'] ?? 0) + 1;
          break;
      }
    }

    return summary;
  }

  UserAttendance compact(DateTime newStartDate) {
    final daysToRemove = newStartDate.difference(academicPeriodStart).inDays;
    if (daysToRemove <= 0) return this;

    final newAttendanceString = daysToRemove >= attendanceString.length
        ? ''
        : attendanceString.substring(daysToRemove);

    return UserAttendance(
      academicPeriodStart: newStartDate,
      attendanceString: newAttendanceString,
    );
  }
  // Get the count of consecutive days with a specific status
  int getConsecutiveAttendanceCount(String status) {
    if (!_isValidChar(status)) return 0;

    int maxStreak = 0;
    int currentStreak = 0;

    for (final char in attendanceString.split('')) {
      if (char == status) {
        currentStreak++;
        maxStreak = math.max(maxStreak, currentStreak);
      } else {
        currentStreak = 0;
      }
    }

    return maxStreak;
  }

  // Get the date of the first occurrence of a specific status
  DateTime? getDateForFirstStatusOccurrence(String status) {
    if (!_isValidChar(status)) return null;

    final index = attendanceString.indexOf(status);
    if (index == -1) return null;

    return academicPeriodStart.add(Duration(days: index));
  }

  // Get the total days covered by the attendance string
  int getTotalDays() {
    return attendanceString.length;
  }

  // Get attendance statuses within a specific date range
  Map<DateTime, String> getAttendanceInRange(DateTime startDate, DateTime endDate) {
    Map<DateTime, String> attendanceMap = {};
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      attendanceMap[currentDate] = getAttendanceStatus(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return attendanceMap;
  }
}
