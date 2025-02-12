import 'package:cambridge_school/app/modules/user_management/models/user_model.dart';

class ClassRoster {
  String id;
  String classId;
  String sectionName;
  String academicYear;
  String schoolId;
  String className;
  List<UserModel> studentList;

  ClassRoster({
    required this.id,
    required this.classId,
    required this.sectionName,
    required this.academicYear,
    required this.schoolId,
    required this.className,
    required this.studentList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'sectionName': sectionName,
      'academicYear': academicYear,
      'schoolId': schoolId,
      'className': className,
      'studentList': studentList.map((user) => user.toMap()).toList(),
    };
  }

  factory ClassRoster.fromMap(Map<String, dynamic> data) {
    return ClassRoster(
      id: data['id'] as String? ?? '',
      classId: data['classId'] as String? ?? '',
      sectionName: data['sectionName'] as String? ?? '',
      academicYear: data['academicYear'] as String? ?? '',
      schoolId: data['schoolId'] as String? ?? '',
      className: data['className'] as String? ?? '',
      studentList: (data['studentList'] as List<dynamic>?)
          ?.map((dynamic userJson) =>
      UserModel.fromMap(userJson as Map<String, dynamic>)!)
          .toList() ??
          [],
    );
  }
}

class UserRoster {
  String id;
  String rosterType;
  String schoolId;
  List<UserModel> userList;

  UserRoster({
    required this.id,
    required this.rosterType,
    required this.schoolId,
    required this.userList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rosterType': rosterType,
      'schoolId': schoolId,
      'userList': userList.map((user) => user.toMap()).toList(),
    };
  }

  factory UserRoster.fromMap(Map<String, dynamic> data) {
    return UserRoster(
      id: data['id'] as String? ?? '',
      rosterType: data['rosterType'] as String? ?? '',
      schoolId: data['schoolId'] as String? ?? '',
      userList: (data['userList'] as List<dynamic>?)
          ?.map((dynamic userJson) =>
      UserModel.fromMap(userJson as Map<String, dynamic>)!)
          .toList() ??
          [],
    );
  }
}