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

  AttendanceData calculateAttendanceDataForDate(DateTime date) {
    int present = 0,
        absent = 0,
        holiday = 0,
        late = 0,
        excused = 0,
        notApplicable = 0;

    for (UserModel user in userList) {
      final attendance = user.userAttendance;
      if (attendance != null) {
        final status = attendance.getAttendanceStatus(date);
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
          default:
            break;
        }
      }
    }

    final totalUsers = userList.length;
    final workingDays = present + absent + late + excused;
    double percentage(int count) =>
        totalUsers > 0 ? (count / totalUsers) * 100 : 0;

    return AttendanceData(
      present: present,
      absent: absent,
      holiday: holiday,
      late: late,
      excused: excused,
      notApplicable: notApplicable,
      workingDays: workingDays,
      presentPercentage: percentage(present),
      absentPercentage: percentage(absent),
      holidayPercentage: percentage(holiday),
      latePercentage: percentage(late),
      excusedPercentage: percentage(excused),
      notApplicablePercentage: percentage(notApplicable),
      workingPercentage: percentage(workingDays),
    );
  }

  void markAllAttendanceForDate(DateTime date, AttendanceStatus status) {
    for (UserModel user in userList) {
      user.userAttendance!.updateAttendance(date, status);

      // Debugging logs
      print(
          'Updated attendance for ${user.userId}: ${user.userAttendance!.getAttendanceStatus(date)}');
    }
  }
}
