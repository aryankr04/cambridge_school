import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_management/manage_user/models/roster_model.dart';

class DailyAttendanceRecord {
  String id; // Add the ID field
  DateTime date;
  List<ClassAttendanceSummary>? classAttendanceSummaries;
  EmployeeAttendanceSummary? employeeAttendanceSummary;

  DailyAttendanceRecord({
    required this.id, // ID is optional when creating a new record
    required this.date,
    this.classAttendanceSummaries,
    this.employeeAttendanceSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'classAttendanceSummaries': classAttendanceSummaries?.map((e) => e.toMap()).toList(),
      'employeeAttendanceSummary': employeeAttendanceSummary?.toMap(),
    };
  }

  factory DailyAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return DailyAttendanceRecord(
      id: map['id'] as String, // Extract ID from the map
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
  List<AttendanceTaker> markedBy;
  RosterAttendanceSummary rosterAttendanceSummary;
  ClassAttendanceSummary({
    required this.className,
    required this.sectionName,
    required this.markedBy,
    required this.rosterAttendanceSummary,

  });

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'sectionName': sectionName,
      'markedBy': markedBy.map((e) => e.toMap()).toList(),
      'rosterAttendanceSummary': rosterAttendanceSummary.toMap(),
    };
  }

  factory ClassAttendanceSummary.fromMap(Map<String, dynamic> map) {
    return ClassAttendanceSummary(
      className: map['className'] as String,
      sectionName: map['sectionName'] as String,
      markedBy: (map['markedBy'] as List<dynamic>)
          .map((e) => AttendanceTaker.fromMap(e as Map<String, dynamic>))
          .toList(),
      rosterAttendanceSummary: RosterAttendanceSummary.fromMap(map['rosterAttendanceSummary'] as Map<String, dynamic>),
    );
  }
}

class EmployeeAttendanceSummary {
  List<AttendanceTaker> markedBy;
  RosterAttendanceSummary rosterAttendanceSummary;

  EmployeeAttendanceSummary({
    required this.markedBy,
    required this.rosterAttendanceSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'markedBy': markedBy.map((e) => e.toMap()).toList(),
      'rosterAttendanceSummary': rosterAttendanceSummary.toMap(),
    };
  }

  factory EmployeeAttendanceSummary.fromMap(Map<String, dynamic> map) {
    return EmployeeAttendanceSummary(
      markedBy: (map['markedBy'] as List<dynamic>)
          .map((e) => AttendanceTaker.fromMap(e as Map<String, dynamic>))
          .toList(),
      rosterAttendanceSummary: RosterAttendanceSummary.fromMap(map['rosterAttendanceSummary'] as Map<String, dynamic>),
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