import 'package:cloud_firestore/cloud_firestore.dart';

class ClassAttendanceRecord {
  String schoolId;
  String className;
  String sectionName;
  final List<AttendanceEvent> attendanceEvents;

  ClassAttendanceRecord({
    required this.schoolId,
    required this.className,
    required this.sectionName,
    required this.attendanceEvents,
  });
}

class UserAttendanceRecord {
  String schoolId;
  final String userType;
  final List<AttendanceEvent> attendanceEvents;

  UserAttendanceRecord({
    required this.schoolId,
    required this.attendanceEvents,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'attendanceEvents': attendanceEvents.map((e) => e.toMap()).toList(),
      'userType': userType,
    };
  }

  factory UserAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return UserAttendanceRecord(
      schoolId: map['schoolId'] as String,
      attendanceEvents: (map['attendanceEvents'] as List<dynamic>)
          .map((e) => AttendanceEvent.fromMap(e as Map<String, dynamic>))
          .toList(),
      userType: map['userType'] as String,
    );
  }
}
class AttendanceEvent {
  final DateTime date;
  final AttendanceTaker markedBy;
  final int presents;
  final int absents;

  AttendanceEvent({
    required this.date,
    required this.markedBy,
    required this.presents,
    required this.absents,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'markedBy': markedBy.toMap(),
      'presents': presents,
      'absents': absents,
    };
  }

  factory AttendanceEvent.fromMap(Map<String, dynamic> map) {
    return AttendanceEvent(
      date: (map['date'] as Timestamp).toDate(),
      markedBy: AttendanceTaker.fromMap(map['markedBy'] as Map<String, dynamic>),
      presents: map['presents'] as int? ?? 0,
      absents: map['absents'] as int? ?? 0,
    );
  }
}

class AttendanceTaker {
  final String uid;
  final String name;
  final DateTime time;

  AttendanceTaker({
    required this.uid,
    required this.name,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'time': Timestamp.fromDate(time),
    };
  }

  factory AttendanceTaker.fromMap(Map<String, dynamic> map) {
    return AttendanceTaker(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      time: (map['time'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'AttendanceTaker{uid: $uid, name: $name, time: $time}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AttendanceTaker &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              name == other.name &&
              time == other.time;

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ time.hashCode;
}



class DailyAttendanceRecord {
  String schoolId;
  DateTime date;
  List<ClassAttendanceSummary>? classAttendanceSummaries;
  EmployeeAttendanceSummary? employeeAttendanceSummary;

  DailyAttendanceRecord({
    required this.schoolId,
    required this.date,
    this.classAttendanceSummaries,
    this.employeeAttendanceSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'date': Timestamp.fromDate(date),
      'classAttendanceSummaries': classAttendanceSummaries?.map((e) => e.toMap()).toList(),
      'employeeAttendanceSummary': employeeAttendanceSummary?.toMap(),
    };
  }

  factory DailyAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return DailyAttendanceRecord(
      schoolId: map['schoolId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      classAttendanceSummaries: (map['classAttendanceSummaries'] as List<dynamic>?)
          ?.map((e) => ClassAttendanceSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      employeeAttendanceSummary: map['employeeAttendanceSummary'] == null
          ? null
          : EmployeeAttendanceSummary.fromMap(map['employeeAttendanceSummary'] as Map<String, dynamic>),
    );
  }
}

class ClassAttendanceSummary {
  String className;
  String sectionName;
  AttendanceTaker markedBy;
  int presents;
  int absents;

  ClassAttendanceSummary({
    required this.className,
    required this.sectionName,
    required this.markedBy,
    required this.presents,
    required this.absents,
  });

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'sectionName': sectionName,
      'markedBy': markedBy.toMap(),
      'presents': presents,
      'absents': absents,
    };
  }

  factory ClassAttendanceSummary.fromMap(Map<String, dynamic> map) {
    return ClassAttendanceSummary(
      className: map['className'] as String,
      sectionName: map['sectionName'] as String,
      markedBy:
      AttendanceTaker.fromMap(map['markedBy'] as Map<String, dynamic>),
      presents: map['presents'] as int,
      absents: map['absents'] as int,
    );
  }
}

class EmployeeAttendanceSummary {
  AttendanceTaker markedBy;
  int presents;
  int absents;

  EmployeeAttendanceSummary({
    required this.markedBy,
    required this.presents,
    required this.absents,
  });

  Map<String, dynamic> toMap() {
    return {
      'markedBy': markedBy.toMap(),
      'presents': presents,
      'absents': absents,
    };
  }

  factory EmployeeAttendanceSummary.fromMap(Map<String, dynamic> map) {
    return EmployeeAttendanceSummary(
      markedBy:
      AttendanceTaker.fromMap(map['markedBy'] as Map<String, dynamic>),
      presents: map['presents'] as int,
      absents: map['absents'] as int,
    );
  }
}

