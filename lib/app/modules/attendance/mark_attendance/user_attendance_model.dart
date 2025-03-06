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

  // Private helper method to check if a character is a valid attendance character.
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

  // Convert the UserAttendance object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'academicPeriodStart': academicPeriodStart.toIso8601String(),
      'attendanceString': attendanceString,
    };
  }

  // Create a UserAttendance object from a Map.
  static UserAttendance? fromMap(Map<String, dynamic> map) {
    try {
      if (!map.containsKey('academicPeriodStart') ||
          !map.containsKey('attendanceString')) {
        return null;
      }

      return UserAttendance(
        academicPeriodStart:
            DateTime.parse(map['academicPeriodStart'] as String),
        attendanceString: map['attendanceString'] as String,
      );
    } catch (e) {
      print('Exception on UserAttendance fromMap: $e');
      return null;
    }
  }

  // Update the attendance status for a specific date.
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

  // Update the attendance status for a range of dates.
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

    newAttendanceString = newAttendanceString.replaceRange(startOffset,
        endOffset + 1, ''.padRight(endOffset - startOffset + 1, status));

    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  // Get the attendance status for a specific date.
  String getAttendanceStatus(DateTime date) {
    final offset = date.difference(academicPeriodStart).inDays;
    if (offset < 0 || offset >= attendanceString.length) {
      return 'N';
    }
    return attendanceString[offset];
  }

  // Calculate the attendance summary (counts of P, A, H, L, E, N).
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

  // Compact the attendance string to a new start date.
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

  // Get the count of consecutive days with a specific status.
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

  // Get the date of the first occurrence of a specific status.
  DateTime? getDateForFirstStatusOccurrence(String status) {
    if (!_isValidChar(status)) return null;

    final index = attendanceString.indexOf(status);
    if (index == -1) return null;

    return academicPeriodStart.add(Duration(days: index));
  }

  // Get the total days covered by the attendance string.
  int getTotalDays() {
    return attendanceString.length;
  }

  // Get attendance statuses within a specific date range.
  Map<DateTime, String> getAttendanceInRange(
      DateTime startDate, DateTime endDate) {
    Map<DateTime, String> attendanceMap = {};
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      attendanceMap[currentDate] = getAttendanceStatus(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return attendanceMap;
  }

  // Generate heatmap data for attendance (e.g., for calendar heatmap).
  Map<String, String> getAttendanceHeatmapData() {
    Map<String, String> heatmapData = {};
    DateTime currentDate = academicPeriodStart;

    for (int i = 0; i < attendanceString.length; i++) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      heatmapData[formattedDate] = attendanceString[i];
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return heatmapData;
  }

  // Provide data for a monthly attendance trend line chart.
  Map<String, double> getMonthlyAttendanceTrends() {
    Map<String, double> monthlyTrends = {};
    DateTime currentDate = academicPeriodStart;

    Map<String, int> monthlyPresent = {};
    Map<String, int> monthlyTotal = {};

    for (int i = 0; i < attendanceString.length; i++) {
      String monthKey = DateFormat('yyyy-MM').format(currentDate);
      monthlyTotal[monthKey] = (monthlyTotal[monthKey] ?? 0) + 1;

      if (attendanceString[i] == 'P') {
        monthlyPresent[monthKey] = (monthlyPresent[monthKey] ?? 0) + 1;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    for (String month in monthlyTotal.keys) {
      monthlyTrends[month] =
          (monthlyPresent[month] ?? 0) / monthlyTotal[month]! * 100;
    }

    return monthlyTrends;
  }

  // Identify and return streaks of a particular status (e.g., 'P' for Present).
  List<Map<String, dynamic>> getStreaks(String status) {
    List<Map<String, dynamic>> streaks = [];
    DateTime? streakStart;
    int streakLength = 0;

    DateTime currentDate = academicPeriodStart;
    for (int i = 0; i < attendanceString.length; i++) {
      if (attendanceString[i] == status) {
        streakLength++;
        streakStart ??= currentDate;
      } else if (streakLength > 0) {
        streaks.add({
          'start': streakStart,
          'end': currentDate.subtract(const Duration(days: 1)),
          'length': streakLength,
        });
        streakStart = null;
        streakLength = 0;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    if (streakLength > 0) {
      streaks.add({
        'start': streakStart,
        'end': currentDate.subtract(const Duration(days: 1)),
        'length': streakLength,
      });
    }

    return streaks;
  }

  // Analyze and visualize attendance consistency.
  double getAttendanceConsistency() {
    int changes = 0;

    for (int i = 1; i < attendanceString.length; i++) {
      if (attendanceString[i] != attendanceString[i - 1]) {
        changes++;
      }
    }

    return changes / attendanceString.length * 100;
  }

  // Prepare data for pie chart visualization of attendance summary.
  Map<String, double> getPieChartData() {
    Map<String, int> summary = calculateAttendanceSummary();
    return summary.map((key, value) => MapEntry(key, value.toDouble()));
  }

  // Prepare data for a bar chart comparing weekly attendance.
  Map<String, int> getWeeklyAttendanceData() {
    Map<String, int> weeklyData = {};
    DateTime currentDate = academicPeriodStart;
    int weekNumber = 1;

    for (int i = 0; i < attendanceString.length; i += 7) {
      int presentCount = 0;
      for (int j = 0; j < 7 && (i + j) < attendanceString.length; j++) {
        if (attendanceString[i + j] == 'P') {
          presentCount++;
        }
      }
      weeklyData['Week $weekNumber'] = presentCount;
      weekNumber++;
    }

    return weeklyData;
  }

  // Provide data for trend analysis using line charts.
  Map<String, double> getLineChartData() {
    Map<String, double> lineChartData = {};
    DateTime currentDate = academicPeriodStart;

    for (int i = 0; i < attendanceString.length; i++) {
      lineChartData[formatDate(currentDate)] =
          attendanceString[i] == 'P' ? 1.0 : 0.0;
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return lineChartData;
  }

  // Prepare data for a bar chart comparing monthly attendance.
  Map<String, int> getMonthlyAttendanceData() {
    Map<String, int> monthlyPresent = {};
    Map<String, int> monthlyAbsent = {};
    Map<String, int> monthlyData = {};
    DateTime currentDate = academicPeriodStart;

    for (int i = 0; i < attendanceString.length; i++) {
      String monthKey = DateFormat('yyyy-MM').format(currentDate);

      if (attendanceString[i] == 'P') {
        monthlyPresent[monthKey] = (monthlyPresent[monthKey] ?? 0) + 1;
      } else if (attendanceString[i] == 'A') {
        monthlyAbsent[monthKey] = (monthlyAbsent[monthKey] ?? 0) + 1;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    for (String month in monthlyPresent.keys) {
      monthlyData['${month}_P'] = monthlyPresent[month]!;
    }
    for (String month in monthlyAbsent.keys) {
      monthlyData['${month}_A'] = monthlyAbsent[month]!;
    }

    return monthlyData;
  }

  // Helper method to format a date.
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Map<String, dynamic> getMonthlyAttendanceSummary(DateTime month) {
    DateTime startDate = DateTime(month.year, month.month, 1);
    DateTime endDate = DateTime(month.year, month.month + 1, 0);

    Map<DateTime, String> attendanceInRange =
        getAttendanceInRange(startDate, endDate);

    int present = 0;
    int absent = 0;
    int holiday = 0;
    int late = 0;
    int excused = 0;
    int notApplicable = 0;

    for (var status in attendanceInRange.values) {
      switch (status) {
        case 'P':
          present++;
          break;
        case 'A':
          absent++;
          break;
        case 'H':
          holiday++;
          break;
        case 'L':
          late++;
          break;
        case 'E':
          excused++;
          break;
        case 'N':
          notApplicable++;
          break;
      }
    }

    int totalDays = attendanceInRange.length;
    int workingDays = present + absent + late + excused;

    double presentPercentage =
        totalDays > 0 ? (present / workingDays) * 100 : 0;
    double absentPercentage = totalDays > 0 ? (absent / workingDays) * 100 : 0;
    double holidayPercentage = totalDays > 0 ? (holiday / totalDays) * 100 : 0;
    double latePercentage = totalDays > 0 ? (late / workingDays) * 100 : 0;
    double excusedPercentage =
        totalDays > 0 ? (excused / workingDays) * 100 : 0;
    double notApplicablePercentage =
        totalDays > 0 ? (notApplicable / totalDays) * 100 : 0;
    double workingPercentage =
        totalDays > 0 ? (workingDays / totalDays) * 100 : 0;

    return {
      'Present': present,
      'Absent': absent,
      'Holiday': holiday,
      'Late': late,
      'Excused': excused,
      'Not Applicable': notApplicable,
      'Working': workingDays,
      'PresentPercentage': presentPercentage,
      'AbsentPercentage': absentPercentage,
      'HolidayPercentage': holidayPercentage,
      'LatePercentage': latePercentage,
      'ExcusedPercentage': excusedPercentage,
      'NotApplicablePercentage': notApplicablePercentage,
      'WorkingPercentage': workingPercentage,
    };
  }
}
