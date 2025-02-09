import 'user_model.dart';

class ClassRoster {
  String classId;
  String sectionName;
  String academicYear;
  String schoolId;
  String className;
  List<UserModelMain> studentList;

  ClassRoster({
    required this.classId,
    required this.sectionName,
    required this.academicYear,
    required this.schoolId,
    required this.className,
    required this.studentList,
  });

  Map<String, dynamic> toMap() {
    return {
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
      classId: data['classId'] as String? ?? '',
      sectionName: data['sectionName'] as String? ?? '',
      academicYear: data['academicYear'] as String? ?? '',
      schoolId: data['schoolId'] as String? ?? '',
      className: data['className'] as String? ?? '',
      studentList: (data['studentList'] as List<dynamic>?)
          ?.map((dynamic userJson) =>
      UserModelMain.fromMap(userJson as Map<String, dynamic>)!)
          .toList() ??
          [],
    );
  }
}