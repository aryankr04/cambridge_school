import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../core/utils/constants/enums/attendance_status.dart';

class UserAttendance {
  final DateTime academicPeriodStart;
  final String attendanceString;

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
    return AttendanceStatus.values.any((status) => status.code == char);
  }

  // Factory method to create a UserAttendance instance with an empty string.
  factory UserAttendance.empty({
    required DateTime academicPeriodStart,
    required int numberOfDays,
  }) {
    assert(numberOfDays >= 0, 'Number of days cannot be negative.');
    final emptyString =
        ''.padRight(numberOfDays, AttendanceStatus.notApplicable.code);
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
  UserAttendance updateAttendance(DateTime date, AttendanceStatus status) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final offset = normalizedDate.difference(academicPeriodStart).inDays;

    String newAttendanceString = attendanceString;
    DateTime newAcademicPeriodStart = academicPeriodStart;

    if (offset < 0) {
      final daysBefore = offset.abs();
      newAcademicPeriodStart = normalizedDate;
      newAttendanceString = status.code +
          ''.padRight(math.max(daysBefore - 1, 0),
              AttendanceStatus.notApplicable.code) +
          attendanceString;
    } else if (offset >= attendanceString.length) {
      final daysToAdd = math.max(0, offset - attendanceString.length);
      newAttendanceString = attendanceString +
          ''.padRight(daysToAdd, AttendanceStatus.notApplicable.code) +
          status.code;
    } else {
      newAttendanceString =
          attendanceString.replaceRange(offset, offset + 1, status.code);
    }

    return UserAttendance(
      academicPeriodStart: newAcademicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  // Update the attendance status for a range of dates.
  UserAttendance updateMultiDateAttendance(
      DateTime startDate, DateTime endDate, AttendanceStatus status) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must not be before start date.');
    }

    int startOffset = startDate.difference(academicPeriodStart).inDays;
    int endOffset = endDate.difference(academicPeriodStart).inDays;

    startOffset = math.max(0, startOffset);
    endOffset = math.max(endOffset, startOffset);

    String newAttendanceString = attendanceString;

    if (startOffset >= newAttendanceString.length) {
      newAttendanceString = newAttendanceString.padRight(
          startOffset, AttendanceStatus.notApplicable.code);
    }

    if (endOffset >= newAttendanceString.length) {
      newAttendanceString = newAttendanceString.padRight(
          endOffset + 1, AttendanceStatus.notApplicable.code);
    }

    newAttendanceString = newAttendanceString.replaceRange(startOffset,
        endOffset + 1, ''.padRight(endOffset - startOffset + 1, status.code));

    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  // Get the attendance status for a specific date.
  AttendanceStatus getAttendanceStatus(DateTime date) {
    final offset = date.difference(academicPeriodStart).inDays;
    if (offset < 0 || offset >= attendanceString.length) {
      return AttendanceStatus.notApplicable;
    }
    return AttendanceStatus.fromCode(attendanceString[offset]);
  }

  // Calculate the attendance summary (counts of P, A, H, L, E, N).
  AttendanceData calculateAttendanceSummary() {
    int present = 0;
    int absent = 0;
    int holiday = 0;
    int late = 0;
    int excused = 0;
    int notApplicable = 0;

    for (final char in attendanceString.split('')) {
      switch (AttendanceStatus.fromCode(char)) {
        case AttendanceStatus.present:
          present++;
          break;
        case AttendanceStatus.absent:
          absent++;
          break;
        case AttendanceStatus.holiday:
          holiday++;
          break;
        case AttendanceStatus.late:
          late++;
          break;
        case AttendanceStatus.excused:
          excused++;
          break;
        case AttendanceStatus.notApplicable:
          notApplicable++;
          break;
          case AttendanceStatus.working:
          break;
      }
    }

    int totalDays = attendanceString.length;
    int workingDays = present +
        absent +
        late +
        excused; // Fixed: Correctly calculate working days

    double presentPercentage =
        workingDays > 0 ? (present / workingDays) * 100 : 0;
    double absentPercentage =
        workingDays > 0 ? (absent / workingDays) * 100 : 0;
    double holidayPercentage = totalDays > 0 ? (holiday / totalDays) * 100 : 0;
    double latePercentage = workingDays > 0 ? (late / workingDays) * 100 : 0;
    double excusedPercentage =
        workingDays > 0 ? (excused / workingDays) * 100 : 0;
    double notApplicablePercentage =
        totalDays > 0 ? (notApplicable / totalDays) * 100 : 0;
    double workingPercentage = totalDays > 0
        ? (workingDays / totalDays) * 100
        : 0; // Calculate working percentage

    return AttendanceData(
      present: present,
      absent: absent,
      holiday: holiday,
      late: late,
      excused: excused,
      notApplicable: notApplicable,
      workingDays: workingDays,
      presentPercentage: presentPercentage,
      absentPercentage: absentPercentage,
      holidayPercentage: holidayPercentage,
      latePercentage: latePercentage,
      excusedPercentage: excusedPercentage,
      notApplicablePercentage: notApplicablePercentage,
      workingPercentage: workingPercentage,
    );
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
  int getConsecutiveAttendanceCount(AttendanceStatus status) {
    int maxStreak = 0;
    int currentStreak = 0;

    for (final char in attendanceString.split('')) {
      if (AttendanceStatus.fromCode(char) == status) {
        currentStreak++;
        maxStreak = math.max(maxStreak, currentStreak);
      } else {
        currentStreak = 0;
      }
    }

    return maxStreak;
  }

  // Get the date of the first occurrence of a specific status.
  DateTime? getDateForFirstStatusOccurrence(AttendanceStatus status) {
    final index = attendanceString.indexOf(status.code);
    if (index == -1) return null;

    return academicPeriodStart.add(Duration(days: index));
  }

  // Get the total days covered by the attendance string.
  int getTotalDays() {
    return attendanceString.length;
  }

  // Get attendance statuses within a specific date range.
  Map<DateTime, AttendanceStatus> getAttendanceInRange(
      DateTime startDate, DateTime endDate) {
    Map<DateTime, AttendanceStatus> attendanceMap = {};
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
  List<Map<String, dynamic>> getStreaks(AttendanceStatus status) {
    List<Map<String, dynamic>> streaks = [];
    DateTime? streakStart;
    int streakLength = 0;

    DateTime currentDate = academicPeriodStart;
    for (int i = 0; i < attendanceString.length; i++) {
      if (AttendanceStatus.fromCode(attendanceString[i]) == status) {
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
    AttendanceData summary = calculateAttendanceSummary();
    return {
      'Present': summary.present.toDouble(),
      'Absent': summary.absent.toDouble(),
      'Holiday': summary.holiday.toDouble(),
      'Late': summary.late.toDouble(),
      'Excused': summary.excused.toDouble(),
      'Not Applicable': summary.notApplicable.toDouble(),
    };
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

  AttendanceData getMonthlyAttendanceSummary(DateTime month) {
    DateTime startDate = DateTime(month.year, month.month, 1);
    DateTime endDate = DateTime(month.year, month.month + 1, 0);

    Map<DateTime, AttendanceStatus> attendanceInRange =
        getAttendanceInRange(startDate, endDate);

    int present = 0;
    int absent = 0;
    int holiday = 0;
    int late = 0;
    int excused = 0;
    int notApplicable = 0;
    int working = 0;

    for (var status in attendanceInRange.values) {
      switch (status) {
        case AttendanceStatus.present:
          present++;
          break;
        case AttendanceStatus.absent:
          absent++;
          break;
        case AttendanceStatus.holiday:
          holiday++;
          break;
        case AttendanceStatus.late:
          late++;
          break;
        case AttendanceStatus.excused:
          excused++;
          break;
        case AttendanceStatus.notApplicable:
          notApplicable++;
          break;
        case AttendanceStatus.working:
          working++;
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

    return AttendanceData(
        present: present,
        absent: absent,
        holiday: holiday,
        late: late,
        excused: excused,
        notApplicable: notApplicable,
        workingDays: workingDays,
        presentPercentage: presentPercentage,
        absentPercentage: absentPercentage,
        holidayPercentage: holidayPercentage,
        latePercentage: latePercentage,
        excusedPercentage: excusedPercentage,
        notApplicablePercentage: notApplicablePercentage,
        workingPercentage: workingPercentage);
  }
}

class AttendanceData {
  final int present;
  final int absent;
  final int holiday;
  final int late;
  final int excused;
  final int notApplicable;
  final int workingDays;

  final double presentPercentage;
  final double absentPercentage;
  final double holidayPercentage;
  final double latePercentage;
  final double excusedPercentage;
  final double notApplicablePercentage;
  final double workingPercentage;

  AttendanceData({
    required this.present,
    required this.absent,
    required this.holiday,
    required this.late,
    required this.excused,
    required this.notApplicable,
    required this.workingDays,
    required this.presentPercentage,
    required this.absentPercentage,
    required this.holidayPercentage,
    required this.latePercentage,
    required this.excusedPercentage,
    required this.notApplicablePercentage,
    required this.workingPercentage,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      holiday: json['Holiday'] ?? 0,
      late: json['Late'] ?? 0,
      excused: json['Excused'] ?? 0,
      notApplicable: json['Not Applicable'] ?? 0,
      workingDays: json['Working'] ?? 0,
      presentPercentage: (json['PresentPercentage'] ?? 0.0).toDouble(),
      absentPercentage: (json['AbsentPercentage'] ?? 0.0).toDouble(),
      holidayPercentage: (json['HolidayPercentage'] ?? 0.0).toDouble(),
      latePercentage: (json['LatePercentage'] ?? 0.0).toDouble(),
      excusedPercentage: (json['ExcusedPercentage'] ?? 0.0).toDouble(),
      notApplicablePercentage:
          (json['NotApplicablePercentage'] ?? 0.0).toDouble(),
      workingPercentage: (json['WorkingPercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
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
