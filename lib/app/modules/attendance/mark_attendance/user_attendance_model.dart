import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../user_management/manage_user/models/roster_model.dart';


class UserAttendance {
  final DateTime academicPeriodStart;
  final String attendanceString;

  UserAttendance({
    required this.academicPeriodStart,
    required this.attendanceString,
  }) : assert(
  attendanceString.isEmpty ||
      attendanceString
          .split('')
          .every((char) => _isValidAttendanceCode(char)),
  'Invalid attendance record: Contains invalid characters.',
  );

  // Private helper method to check if a character is a valid attendance character.
  static bool _isValidAttendanceCode(String char) {
    return AttendanceStatus.values.any((status) => status.code == char);
  }

  // Factory method to create a UserAttendance instance with an empty string.
  factory UserAttendance.createEmptyRecord({
    required DateTime academicPeriodStartDate,
    required int numberOfDays,
  }) {
    assert(numberOfDays >= 0, 'Number of days cannot be negative.');
    final emptyAttendanceRecord =
    ''.padRight(numberOfDays, AttendanceStatus.notApplicable.code);
    return UserAttendance(
      academicPeriodStart: academicPeriodStartDate,
      attendanceString: emptyAttendanceRecord,
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

  // Adjust the attendance record to a new start date.
  UserAttendance adjustToNewStartDate(DateTime newStartDate) {
    final daysToTrim = newStartDate.difference(academicPeriodStart).inDays;
    if (daysToTrim <= 0) return this;

    final updatedAttendanceRecord = daysToTrim >= attendanceString.length
        ? ''
        : attendanceString.substring(daysToTrim);

    return UserAttendance(
      academicPeriodStart: newStartDate,
      attendanceString: updatedAttendanceRecord,
    );
  }

  // Get the date of the first occurrence of a specific status.
  DateTime? findDateOfFirstOccurrence(AttendanceStatus status) {
    final index = attendanceString.indexOf(status.code);
    if (index == -1) return null;

    return academicPeriodStart.add(Duration(days: index));
  }

  // Update the attendance status for a specific date.
  UserAttendance updateAttendanceForDate(
      DateTime date, AttendanceStatus status) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dayOffset = normalizedDate.difference(academicPeriodStart).inDays;

    String newAttendanceRecord = attendanceString;
    DateTime newAcademicPeriodStartDate = academicPeriodStart;

    if (dayOffset < 0) {
      final daysBeforeStart = dayOffset.abs();
      newAcademicPeriodStartDate = normalizedDate;
      newAttendanceRecord = status.code +
          ''.padRight(math.max(daysBeforeStart - 1, 0),
              AttendanceStatus.notApplicable.code) +
          attendanceString;
    } else if (dayOffset >= attendanceString.length) {
      final daysBeyondEnd = math.max(0, dayOffset - attendanceString.length);
      newAttendanceRecord = attendanceString +
          ''.padRight(daysBeyondEnd, AttendanceStatus.notApplicable.code) +
          status.code;
    } else {
      newAttendanceRecord =
          attendanceString.replaceRange(dayOffset, dayOffset + 1, status.code);
    }

    return UserAttendance(
      academicPeriodStart: newAcademicPeriodStartDate,
      attendanceString: newAttendanceRecord,
    );
  }

  // Update the attendance status for a range of dates.
  UserAttendance updateAttendanceForDateRange(
      DateTime startDate, DateTime endDate, AttendanceStatus status) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must not be before start date.');
    }

    int startOffset = startDate.difference(academicPeriodStart).inDays;
    int endOffset = endDate.difference(academicPeriodStart).inDays;

    startOffset = math.max(0, startOffset);
    endOffset = math.max(endOffset, startOffset);

    String newAttendanceRecord = attendanceString;

    if (startOffset >= newAttendanceRecord.length) {
      newAttendanceRecord = newAttendanceRecord.padRight(
          startOffset, AttendanceStatus.notApplicable.code);
    }

    if (endOffset >= newAttendanceRecord.length) {
      newAttendanceRecord = newAttendanceRecord.padRight(
          endOffset + 1, AttendanceStatus.notApplicable.code);
    }

    newAttendanceRecord = newAttendanceRecord.replaceRange(startOffset,
        endOffset + 1, ''.padRight(endOffset - startOffset + 1, status.code));

    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: newAttendanceRecord,
    );
  }

  // Get the attendance status for a specific date.
  AttendanceStatus getAttendanceStatusForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dayOffset = normalizedDate.difference(academicPeriodStart).inDays;
    if (dayOffset < 0 || dayOffset >= attendanceString.length) {
      return AttendanceStatus.notApplicable;
    }
    return AttendanceStatus.fromCode(attendanceString[dayOffset]);
  }

  // Get attendance statuses within a specific date range.
  Map<DateTime, AttendanceStatus> getAttendanceStatusInDateRange(
      DateTime startDate, DateTime endDate) {
    Map<DateTime, AttendanceStatus> attendanceMap = {};
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      attendanceMap[currentDate] = getAttendanceStatusForDate(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return attendanceMap;
  }

  // Calculate the attendance summary (counts of P, A, H, L, E, N).
  UserAttendanceSummary calculateAttendanceSummaryInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    DateTime analysisStartDate = startDate;
    DateTime analysisEndDate = endDate;

    analysisStartDate = analysisStartDate.isBefore(academicPeriodStart)
        ? academicPeriodStart
        : analysisStartDate;
    analysisEndDate = analysisEndDate.isAfter(academicPeriodStart
        .add(Duration(days: attendanceString.length - 1)))
        ? academicPeriodStart.add(Duration(days: attendanceString.length - 1))
        : analysisEndDate;

    int presentCount = 0;
    int absentCount = 0;
    int holidayCount = 0;
    int lateCount = 0;
    int excusedCount = 0;
    int notApplicableCount = 0;

    int workingDaysCount = 0;
    int totalDaysInPeriod = 0; // Total days within the calculation range

    // Monthly attendance data
    List<MonthlyAttendance> monthlyAttendanceList = [];
    Map<String, MonthlyAttendanceBuilder> monthlyBuilders = {};

    // Iterate only within the specified date range.
    DateTime currentDate = analysisStartDate;
    while (!currentDate.isAfter(analysisEndDate)) {
      int dayOffset = currentDate.difference(academicPeriodStart).inDays;

      if (dayOffset >= 0 && dayOffset < attendanceString.length) {
        final attendanceCode = attendanceString[dayOffset];
        final attendanceStatus = AttendanceStatus.fromCode(attendanceCode);

        // Get the month key.
        String monthKey = DateFormat('yyyy-MM').format(currentDate);

        // Get or create the monthly attendance builder
        MonthlyAttendanceBuilder monthlyBuilder =
        monthlyBuilders.putIfAbsent(monthKey, () {
          return MonthlyAttendanceBuilder(month: monthKey);
        });

        switch (attendanceStatus) {
          case AttendanceStatus.present:
            presentCount++;
            monthlyBuilder.presentCount++;
            break;
          case AttendanceStatus.absent:
            absentCount++;
            monthlyBuilder.absentCount++;
            break;
          case AttendanceStatus.holiday:
            holidayCount++;
            monthlyBuilder.holidayCount++;
            break;
          case AttendanceStatus.late:
            lateCount++;
            monthlyBuilder.lateCount++;
            break;
          case AttendanceStatus.excused:
            excusedCount++;
            monthlyBuilder.excusedCount++;
            break;
          case AttendanceStatus.notApplicable:
            notApplicableCount++;
            monthlyBuilder.notApplicableCount++;
            break;
          case AttendanceStatus.working:
            break;
        }

        // Increment workingDays only for statuses that are considered working days
        if (attendanceStatus != AttendanceStatus.holiday &&
            attendanceStatus != AttendanceStatus.notApplicable) {
          workingDaysCount++;
          monthlyBuilder.workingDaysCount++;
        }

        totalDaysInPeriod++;
        monthlyBuilder.totalDaysInMonth++;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    // Calculate percentages based on the filtered data
    double presentPercentage =
    workingDaysCount > 0 ? (presentCount / workingDaysCount) * 100 : 0;
    double absentPercentage =
    workingDaysCount > 0 ? (absentCount / workingDaysCount) * 100 : 0;
    double holidayPercentage =
    totalDaysInPeriod > 0 ? (holidayCount / totalDaysInPeriod) * 100 : 0;
    double latePercentage =
    workingDaysCount > 0 ? (lateCount / workingDaysCount) * 100 : 0;
    double excusedPercentage =
    workingDaysCount > 0 ? (excusedCount / workingDaysCount) * 100 : 0;
    double notApplicablePercentage = totalDaysInPeriod > 0
        ? (notApplicableCount / totalDaysInPeriod) * 100
        : 0;
    double workingPercentage = totalDaysInPeriod > 0
        ? (workingDaysCount / totalDaysInPeriod) * 100
        : 0;

    // Calculate Streaks
    final presentStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.present);
    final absentStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.absent);
    final holidayStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.holiday);
    final lateStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.late);
    final excusedStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.excused);
    final notApplicableStreaks = _getAttendanceStreaksForSummary(
        analysisStartDate, analysisEndDate, AttendanceStatus.notApplicable);

    //Build monthly attendances
    monthlyAttendanceList = monthlyBuilders.values.map((builder) => builder.build()).toList();

    // Sort the streaks lists by length in descending order
    presentStreaks.sort((a, b) => b.length.compareTo(a.length));
    absentStreaks.sort((a, b) => b.length.compareTo(a.length));
    holidayStreaks.sort((a, b) => b.length.compareTo(a.length));
    lateStreaks.sort((a, b) => b.length.compareTo(a.length));
    excusedStreaks.sort((a, b) => b.length.compareTo(a.length));
    notApplicableStreaks.sort((a, b) => b.length.compareTo(a.length));

    return UserAttendanceSummary(
        presentCount: presentCount,
        absentCount: absentCount,
        holidayCount: holidayCount,
        lateCount: lateCount,
        excusedCount: excusedCount,
        notApplicableCount: notApplicableCount,
        workingDaysCount: workingDaysCount,
        presentPercentage: presentPercentage,
        absentPercentage: absentPercentage,
        holidayPercentage: holidayPercentage,
        latePercentage: latePercentage,
        excusedPercentage: excusedPercentage,
        notApplicablePercentage: notApplicablePercentage,
        workingDaysPercentage: workingPercentage,
        currentPresentStreak:
        presentStreaks.isNotEmpty ? presentStreaks.first.length : 0,
        currentAbsentStreak:
        absentStreaks.isNotEmpty ? absentStreaks.first.length : 0,
        currentHolidayStreak:
        holidayStreaks.isNotEmpty ? holidayStreaks.first.length : 0,
        currentLateStreak: lateStreaks.isNotEmpty ? lateStreaks.first.length : 0,
        currentExcusedStreak:
        excusedStreaks.isNotEmpty ? excusedStreaks.first.length : 0,
        currentNotApplicableStreak: notApplicableStreaks.isNotEmpty
            ? notApplicableStreaks.first.length
            : 0,
        presentStreaks: AttendanceStreakList(
            type: AttendanceStatus.present, streaks: presentStreaks),
        absentStreaks: AttendanceStreakList(
            type: AttendanceStatus.absent, streaks: absentStreaks),
        holidayStreaks: AttendanceStreakList(
            type: AttendanceStatus.holiday, streaks: holidayStreaks),
        lateStreaks: AttendanceStreakList(
            type: AttendanceStatus.late, streaks: lateStreaks),
        excusedStreaks: AttendanceStreakList(
            type: AttendanceStatus.excused, streaks: excusedStreaks),
        notApplicableStreaks: AttendanceStreakList(
            type: AttendanceStatus.notApplicable, streaks: notApplicableStreaks),
        monthlyAttendance: monthlyAttendanceList
    );
  }

  List<AttendanceStreak> _getAttendanceStreaksForSummary(
      DateTime analysisStartDate,
      DateTime analysisEndDate,
      AttendanceStatus status) {
    List<AttendanceStreak> streaks = [];
    DateTime? streakStartDate;
    int streakLength = 0;

    DateTime currentDate = academicPeriodStart;

    for (int i = 0; i < attendanceString.length; i++) {
      final date = academicPeriodStart.add(Duration(days: i));
      if (date.isBefore(analysisStartDate) || date.isAfter(analysisEndDate)) {
        continue; // Skip dates outside the analysis range
      }
      if (AttendanceStatus.fromCode(attendanceString[i]) == status) {
        streakLength++;
        streakStartDate ??= date;
      } else if (streakLength > 0) {
        if (streakStartDate != null) {
          // Check if streakStartDate has a value
          streaks.add(AttendanceStreak(
              start: streakStartDate,
              end: date.subtract(const Duration(days: 1)),
              length: streakLength));
        }
        streakStartDate = null;
        streakLength = 0;
      }
    }

    // Handle any remaining streak at the end
    if (streakLength > 0) {
      if (streakStartDate != null) {
        // Check if streakStartDate has a value
        streaks.add(AttendanceStreak(
            start: streakStartDate,
            end: currentDate.subtract(const Duration(days: 1)),
            length: streakLength));
      }
    }

    return streaks;
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

  // Prepare data for a bar chart comparing monthly attendance.
  Map<String, int> getMonthlyAttendanceSummary() {
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
  UserAverageAttendanceSummary calculateAverageAttendanceSummaryInDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
    required String userName,
    String? rollNo,
  }) {
    UserAttendanceSummary userAttendanceSummary =
    calculateAttendanceSummaryInDateRange(
        startDate: startDate, endDate: endDate);

    return UserAverageAttendanceSummary(
      userId: userId,
      userName: userName,
      rollNo: rollNo,
      presentPercentage: userAttendanceSummary.presentPercentage,
      absentPercentage: userAttendanceSummary.absentPercentage,
      holidayPercentage: userAttendanceSummary.holidayPercentage,
      latePercentage: userAttendanceSummary.latePercentage,
      excusedPercentage: userAttendanceSummary.excusedPercentage,
      notApplicablePercentage: userAttendanceSummary.notApplicablePercentage,
      workingPercentage: userAttendanceSummary.workingDaysPercentage,
    );
  }
  // Helper method to format a date.
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Returns a list of months in 'MMMM yyyy' format between [academicPeriodStart]
  /// and the last date covered by [attendanceString].
  List<String> getListOfMonths() {
    List<String> months = [];
    DateTime currentDate = academicPeriodStart;
    DateTime endDate = academicPeriodStart.add(Duration(days: attendanceString.length - 1));

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      months.add(DateFormat('MMMM yyyy').format(currentDate));
      currentDate = DateTime(currentDate.year, currentDate.month + 1); // Move to the first day of the next month
    }

    return months;
  }

  /// Returns a list of years in 'yyyy' format between [academicPeriodStart] and
  /// the last date covered by [attendanceString].  Duplicates are removed.
  List<String> getListOfYears() {
    Set<String> years = {};
    DateTime currentDate = academicPeriodStart;
    DateTime endDate = academicPeriodStart.add(Duration(days: attendanceString.length - 1));

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      years.add(DateFormat('yyyy').format(currentDate));
      currentDate = DateTime(currentDate.year + 1, currentDate.month); // Move to the same month of the next year
    }

    return years.toList();
  }
  DateTime getEndDateOfAttendance() {
    return academicPeriodStart.add(Duration(days: attendanceString.length - 1));
  }
}

class UserAttendanceSummary {
  final int presentCount;
  final int absentCount;
  final int holidayCount;
  final int lateCount;
  final int excusedCount;
  final int notApplicableCount;
  final int workingDaysCount;

  final double presentPercentage;
  final double absentPercentage;
  final double holidayPercentage;
  final double latePercentage;
  final double excusedPercentage;
  final double notApplicablePercentage;
  final double workingDaysPercentage;

  final int currentPresentStreak;
  final int currentAbsentStreak;
  final int currentHolidayStreak;
  final int currentLateStreak;
  final int currentExcusedStreak;
  final int currentNotApplicableStreak;

  final AttendanceStreakList presentStreaks;
  final AttendanceStreakList absentStreaks;
  final AttendanceStreakList holidayStreaks;
  final AttendanceStreakList lateStreaks;
  final AttendanceStreakList excusedStreaks;
  final AttendanceStreakList notApplicableStreaks;

  final List<MonthlyAttendance> monthlyAttendance;

  UserAttendanceSummary({
    required this.presentCount,
    required this.absentCount,
    required this.holidayCount,
    required this.lateCount,
    required this.excusedCount,
    required this.notApplicableCount,
    required this.workingDaysCount,
    required this.presentPercentage,
    required this.absentPercentage,
    required this.holidayPercentage,
    required this.latePercentage,
    required this.excusedPercentage,
    required this.notApplicablePercentage,
    required this.workingDaysPercentage,
    required this.currentPresentStreak,
    required this.currentAbsentStreak,
    required this.currentHolidayStreak,
    required this.currentLateStreak,
    required this.currentExcusedStreak,
    required this.currentNotApplicableStreak,
    required this.presentStreaks,
    required this.absentStreaks,
    required this.holidayStreaks,
    required this.lateStreaks,
    required this.excusedStreaks,
    required this.notApplicableStreaks,
    required this.monthlyAttendance,
  });
}

class AttendanceStreakList {
  final AttendanceStatus type;
  final List<AttendanceStreak> streaks;

  AttendanceStreakList({required this.type, required this.streaks});
}

class AttendanceStreak {
  final DateTime start;
  final DateTime end;
  final int length;

  AttendanceStreak(
      {required this.start, required this.end, required this.length});
}

class MonthlyAttendance {
  final String month;
  final int presentCount;
  final int absentCount;
  final int holidayCount;
  final int lateCount;
  final int excusedCount;
  final int notApplicableCount;
  final int workingDaysCount;
  final int totalDaysInMonth; // add this to the class as we use it to calculate the percentages

  MonthlyAttendance({
    required this.month,
    required this.presentCount,
    required this.absentCount,
    required this.holidayCount,
    required this.lateCount,
    required this.excusedCount,
    required this.notApplicableCount,
    required this.workingDaysCount,
    required this.totalDaysInMonth,
  });
}

class MonthlyAttendanceBuilder {
  final String month;
  int presentCount = 0;
  int absentCount = 0;
  int holidayCount = 0;
  int lateCount = 0;
  int excusedCount = 0;
  int notApplicableCount = 0;
  int workingDaysCount = 0;
  int totalDaysInMonth = 0;

  MonthlyAttendanceBuilder({required this.month});

  MonthlyAttendance build() {
    return MonthlyAttendance(
        month: month,
        presentCount: presentCount,
        absentCount: absentCount,
        holidayCount: holidayCount,
        lateCount: lateCount,
        excusedCount: excusedCount,
        notApplicableCount: notApplicableCount,
        workingDaysCount: workingDaysCount,
        totalDaysInMonth: totalDaysInMonth);
  }
}