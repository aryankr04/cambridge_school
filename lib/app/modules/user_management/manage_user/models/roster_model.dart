import 'package:cambridge_school/roles_manager.dart';

import '../../../../../core/utils/constants/enums/attendance_status.dart';
import '../../create_user/models/user_model.dart';
import '../../../attendance/mark_attendance/user_attendance_model.dart';

enum UserRosterType { studentRoster, employeeRoster }

class UserRoster {
  String id;
  UserRosterType rosterType;
  String className;
  String sectionName;
  String classId;
  String schoolId;
  List<UserModel> userList;

  UserRoster({
    required this.id,
    required this.rosterType,
    this.className = '',
    this.sectionName = '',
    this.classId = '',
    required this.schoolId,
    required this.userList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rosterType': rosterType.toString().split('.').last,
      'className': className,
      'sectionName': sectionName,
      'classId': classId,
      'schoolId': schoolId,
      'userList': userList.map((user) => user.toMap()).toList(),
    };
  }

  factory UserRoster.fromMap(Map<String, dynamic> data) {
    return UserRoster(
      id: data['id'] as String? ?? '',
      rosterType: UserRosterType.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            (data['rosterType'] as String? ?? ''),
        orElse: () => UserRosterType.studentRoster,
      ),
      className: data['className'] as String? ?? '',
      sectionName: data['sectionName'] as String? ?? '',
      classId: data['classId'] as String? ?? '',
      schoolId: data['schoolId'] as String? ?? '',
      userList: (data['userList'] as List<dynamic>?)
              ?.map((userJson) =>
                  UserModel.fromMap(userJson as Map<String, dynamic>)!)
              .toList() ??
          [],
    );
  }

  RosterAttendanceSummary calculateAttendanceDataForDate(DateTime date) {
    int presentCount = 0;
    int absentCount = 0;
    int holidayCount = 0;
    int lateCount = 0;
    int excusedCount = 0;
    int notApplicableCount = 0;

    for (UserModel user in userList) {
      final attendance = user.userAttendance;
      if (attendance != null) {
        final status = attendance.getAttendanceStatusForDate(date);
        switch (status) {
          case AttendanceStatus.present:
            presentCount++;
            break;
          case AttendanceStatus.absent:
            absentCount++;
            break;
          case AttendanceStatus.holiday:
            holidayCount++;
            break;
          case AttendanceStatus.late:
            lateCount++;
            break;
          case AttendanceStatus.excused:
            excusedCount++;
            break;
          case AttendanceStatus.notApplicable:
            notApplicableCount++;
            break;
          default:
            break;
        }
      }
    }

    final totalUsers = userList.length;
    final workingDaysCount =
        presentCount + absentCount + lateCount + excusedCount;
    double calculatePercentage(int count) =>
        totalUsers > 0 ? (count / totalUsers) * 100 : 0;

    return RosterAttendanceSummary(
      presentCount: presentCount,
      absentCount: absentCount,
      holidayCount: holidayCount,
      lateCount: lateCount,
      excusedCount: excusedCount,
      notApplicableCount: notApplicableCount,
      workingDaysCount: workingDaysCount,
      presentPercentage: calculatePercentage(presentCount),
      absentPercentage: calculatePercentage(absentCount),
      holidayPercentage: calculatePercentage(holidayCount),
      latePercentage: calculatePercentage(lateCount),
      excusedPercentage: calculatePercentage(excusedCount),
      notApplicablePercentage: calculatePercentage(notApplicableCount),
      workingDaysPercentage: calculatePercentage(workingDaysCount),
    );
  }

  /// Calculates the average attendance for each AttendanceStatus
  /// over a specified date range.
  RosterAverageAttendanceSummary calculateAverageAttendanceInDateRange(
      DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must be after or equal to start date.');
    }

    int totalDays = endDate.difference(startDate).inDays + 1;
    if (totalDays <= 0) {
      return RosterAverageAttendanceSummary(
          presentPercentage: 0,
          absentPercentage: 0,
          holidayPercentage: 0,
          latePercentage: 0,
          excusedPercentage: 0,
          notApplicablePercentage: 0,
          workingPercentage: 0,
          userAverageAttendanceSummaryList: []); // Return zeroed object if no days in range.
    }

    // Initialize counters for each status.
    double presentPercentageSum = 0;
    double absentPercentageSum = 0;
    double holidayPercentageSum = 0;
    double latePercentageSum = 0;
    double excusedPercentageSum = 0;
    double notApplicablePercentageSum = 0;
    double workingPercentageSum = 0;

    // Iterate through each date in the range.
    DateTime currentDate = startDate;
    while (!currentDate.isAfter(endDate)) {
      // Calculate attendance data for the current date.
      RosterAttendanceSummary attendanceData =
          calculateAttendanceDataForDate(currentDate);

      // Increment the percentage sums based on the attendance data.
      presentPercentageSum += attendanceData.presentPercentage;
      absentPercentageSum += attendanceData.absentPercentage;
      holidayPercentageSum += attendanceData.holidayPercentage;
      latePercentageSum += attendanceData.latePercentage;
      excusedPercentageSum += attendanceData.excusedPercentage;
      notApplicablePercentageSum += attendanceData.notApplicablePercentage;
      workingPercentageSum += attendanceData.workingDaysPercentage;

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Calculate the averages
    double presentAveragePercentage = presentPercentageSum / totalDays;
    double absentAveragePercentage = absentPercentageSum / totalDays;
    double holidayAveragePercentage = holidayPercentageSum / totalDays;
    double lateAveragePercentage = latePercentageSum / totalDays;
    double excusedAveragePercentage = excusedPercentageSum / totalDays;
    double notApplicableAveragePercentage =
        notApplicablePercentageSum / totalDays;
    double workingAveragePercentage = workingPercentageSum / totalDays;
    List<UserAverageAttendanceSummary> userAverageAttendanceSummaryList = [];

    for (UserModel user in userList) {
      final attendance = user.userAttendance;
      if (attendance != null) {
        userAverageAttendanceSummaryList.add(
          attendance.calculateAverageAttendanceSummaryInDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: user.userId,
            userName: user.username,
            rollNo: user.roles!.contains(UserRole.student)
                ? (user.studentDetails?.rollNumber)
                : null, // Ensures null safety
          ),
        );
      }
    }

    return RosterAverageAttendanceSummary(
      presentPercentage: presentAveragePercentage,
      absentPercentage: absentAveragePercentage,
      holidayPercentage: holidayAveragePercentage,
      latePercentage: lateAveragePercentage,
      excusedPercentage: excusedAveragePercentage,
      notApplicablePercentage: notApplicableAveragePercentage,
      workingPercentage: workingAveragePercentage,
      userAverageAttendanceSummaryList: userAverageAttendanceSummaryList,
    );
  }
}

class RosterAverageAttendanceSummary {
  final double presentPercentage;
  final double absentPercentage;
  final double holidayPercentage;
  final double latePercentage;
  final double excusedPercentage;
  final double notApplicablePercentage;
  final double workingPercentage;

  final List<UserAverageAttendanceSummary> userAverageAttendanceSummaryList;

  RosterAverageAttendanceSummary({
    required this.presentPercentage,
    required this.absentPercentage,
    required this.holidayPercentage,
    required this.latePercentage,
    required this.excusedPercentage,
    required this.notApplicablePercentage,
    required this.workingPercentage,
    required this.userAverageAttendanceSummaryList,
  });

  @override
  String toString() {
    return 'AverageAttendanceSummary{present: $presentPercentage, absent: $absentPercentage, holiday: $holidayPercentage, late: $latePercentage, excused: $excusedPercentage, notApplicable: $notApplicablePercentage, working: $workingPercentage}';
  }
}

class UserAverageAttendanceSummary {
  String userId;
  String userName;
  String? rollNo;
  final double presentPercentage;
  final double absentPercentage;
  final double holidayPercentage;
  final double latePercentage;
  final double excusedPercentage;
  final double notApplicablePercentage;
  final double workingPercentage;

  UserAverageAttendanceSummary({
    required this.userId,
    required this.userName,
    required this.rollNo,
    required this.presentPercentage,
    required this.absentPercentage,
    required this.holidayPercentage,
    required this.latePercentage,
    required this.excusedPercentage,
    required this.notApplicablePercentage,
    required this.workingPercentage,
  });
}

class RosterAttendanceSummary {
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

  RosterAttendanceSummary({
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
  });

  Map<String, dynamic> toMap() {
    return {
      'presentCount': presentCount,
      'absentCount': absentCount,
      'holidayCount': holidayCount,
      'lateCount': lateCount,
      'excusedCount': excusedCount,
      'notApplicableCount': notApplicableCount,
      'workingDaysCount': workingDaysCount,
      'presentPercentage': presentPercentage,
      'absentPercentage': absentPercentage,
      'holidayPercentage': holidayPercentage,
      'latePercentage': latePercentage,
      'excusedPercentage': excusedPercentage,
      'notApplicablePercentage': notApplicablePercentage,
      'workingDaysPercentage': workingDaysPercentage,
    };
  }

  factory RosterAttendanceSummary.fromMap(Map<String, dynamic> map) {
    return RosterAttendanceSummary(
      presentCount: map['presentCount'] as int? ?? 0,
      absentCount: map['absentCount'] as int? ?? 0,
      holidayCount: map['holidayCount'] as int? ?? 0,
      lateCount: map['lateCount'] as int? ?? 0,
      excusedCount: map['excusedCount'] as int? ?? 0,
      notApplicableCount: map['notApplicableCount'] as int? ?? 0,
      workingDaysCount: map['workingDaysCount'] as int? ?? 0,
      presentPercentage: (map['presentPercentage'] as num?)?.toDouble() ?? 0.0,
      absentPercentage: (map['absentPercentage'] as num?)?.toDouble() ?? 0.0,
      holidayPercentage: (map['holidayPercentage'] as num?)?.toDouble() ?? 0.0,
      latePercentage: (map['latePercentage'] as num?)?.toDouble() ?? 0.0,
      excusedPercentage: (map['excusedPercentage'] as num?)?.toDouble() ?? 0.0,
      notApplicablePercentage: (map['notApplicablePercentage'] as num?)?.toDouble() ?? 0.0,
      workingDaysPercentage: (map['workingDaysPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}