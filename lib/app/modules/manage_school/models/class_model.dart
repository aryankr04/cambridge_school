class SchoolSection {
  String schoolId;
  String sectionId;
  String className;
  String sectionName;
  String classTeacherName;
  String classTeacherUid;
  int noOfStudents;

  SchoolSection({
    required this.schoolId,
    required this.sectionId,
    required this.className,
    required this.sectionName,
    required this.classTeacherName,
    required this.classTeacherUid,
    required this.noOfStudents,
  });

  // Factory method to create SchoolClass from a map
  factory SchoolSection.fromMap(Map<String, dynamic> map) {
    return SchoolSection(
      schoolId: map['schoolId'] ?? '',
      sectionId: map['sectionId'] ?? '',
      className: map['className'] ?? '',
      sectionName: map['sectionName'] ?? '',
      classTeacherName: map['classTeacherName'] ?? '',
      classTeacherUid: map['classTeacherUid'] ?? '',
      noOfStudents: map['noOfStudents'] ?? 0,
    );
  }

  // Method to convert SchoolClass to a map
  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'sectionId': sectionId,
      'className': className,
      'sectionName': sectionName,
      'classTeacherName': classTeacherName,
      'classTeacherUid': classTeacherUid,
      'noOfStudents': noOfStudents,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolId': schoolId,
      'sectionId': sectionId,
      'className': className,
      'sectionName': sectionName,
      'classTeacherName': classTeacherName,
      'classTeacherUid': classTeacherUid,
      'noOfStudents': noOfStudents,
    };
  }
}
