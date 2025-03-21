import 'package:cambridge_school/app/modules/routine/routine_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';

class ClassModel {
  final String? id;
  final String? schoolId;
  final String? academicYear;
  final ClassName className;
  late final List<SectionModel> sections;
  late final List<String> subjects;
  final List<ExamSyllabus> examSyllabus;

  ClassModel({
    this.id,
    this.schoolId,
    this.academicYear,
    required this.className,
    List<SectionModel>? sections,
    List<String>? subjects,
    required this.examSyllabus,
  })  : sections = sections ?? [],
        subjects = subjects ?? [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClassModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory ClassModel.fromMap(Map<String, dynamic> map, String? documentId) {
    return ClassModel(
      id: map['id']as String?,
      schoolId: map['schoolId'] as String?,
      academicYear: map['academicYear'] as String?,
      className: ClassNameExtension.fromValue(map['className'] as String),
      sections: (map['sections'] as List<dynamic>?)
          ?.map((dynamic sectionData) => SectionModel.fromMap(
          sectionData as Map<String, dynamic>, null))
          .toList(),
      subjects: (map['subjects'] as List<dynamic>?)?.cast<String>() ?? [],
      examSyllabus: (map['examSyllabus'] as List<dynamic>?)
          ?.map((dynamic e) =>
          ExamSyllabus.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'schoolId': schoolId,
      'academicYear': academicYear,
      'className': className.label, // Store the enum name, not the label
      'sections': sections.map((SectionModel section) => section.toMap()).toList(),
      'subjects': subjects,
      'examSyllabus': examSyllabus.map((ExamSyllabus e) => e.toMap()).toList(),
    };
  }

  ClassModel copyWith({
    String? id,
    String? schoolId,
    String? academicYear,
    ClassName? className,
    List<SectionModel>? sections,
    List<String>? subjects,
    List<ExamSyllabus>? examSyllabus,
  }) {
    return ClassModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      academicYear: academicYear ?? this.academicYear,
      className: className ?? this.className,
      sections: sections ?? this.sections,
      subjects: subjects ?? this.subjects,
      examSyllabus: examSyllabus ?? this.examSyllabus,
    );
  }
}

class SectionModel {
  final String? sectionName;
  final String? classTeacherId;
  final String? classTeacherName;
  final int? capacity;
  final String? roomNumber;
  final List<Student> students;
  final WeeklyRoutine? routine;

  SectionModel({
    this.sectionName,
    this.classTeacherId,
    this.classTeacherName,
    this.capacity,
    this.roomNumber,
    List<Student>? students,
    this.routine,
  }) : students = students ?? [];

  factory SectionModel.fromMap(Map<String, dynamic> data, String? documentId) {
    return SectionModel(
      sectionName: data['sectionName'] as String?,
      classTeacherId: data['classTeacherId'] as String?,
      classTeacherName: data['classTeacherName'] as String?,
      capacity: data['capacity'] as int?,
      roomNumber: data['roomNumber'] as String?,
      students: (data['students'] as List<dynamic>?)
          ?.map((dynamic studentData) =>
          Student.fromMap(studentData as Map<String, dynamic>))
          .toList() ??
          [],
      routine: data['routine'] != null
          ? WeeklyRoutine.fromMap(
          data['routine'] as Map<String, dynamic>, documentId ?? '')
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'sectionName': sectionName,
      'classTeacherId': classTeacherId,
      'classTeacherName': classTeacherName,
      'capacity': capacity,
      'roomNumber': roomNumber,
      'students': students.map((Student student) => student.toMap()).toList(),
    };
    if (routine != null) {
      map['routine'] = routine!.toMap();
    }
    return map;
  }

  SectionModel copyWith({
    String? sectionName,
    String? classTeacherId,
    String? classTeacherName,
    int? capacity,
    String? roomNumber,
    List<Student>? students,
    WeeklyRoutine? routine,
  }) {
    return SectionModel(
      sectionName: sectionName ?? this.sectionName,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      classTeacherName: classTeacherName ?? this.classTeacherName,
      capacity: capacity ?? this.capacity,
      roomNumber: roomNumber ?? this.roomNumber,
      students: students ?? this.students,
      routine: routine ?? this.routine,
    );
  }
}

class Student {
  final String? id;
  final String? name;
  final String? roll;

  Student({this.id, this.name, this.roll});

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String?,
      name: map['name'] as String?,
      roll: map['roll'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll': roll,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? roll,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      roll: roll ?? this.roll,
    );
  }
}

class ExamSyllabus {
  final String? id;
  final String? examName;
  final List<ExamSubject> subjects;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExamSyllabus({
    this.id,
    this.examName,
    required this.subjects,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExamSyllabus && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory ExamSyllabus.fromMap(Map<String, dynamic> map) {
    return ExamSyllabus(
      id: map['id'] as String?,
      examName: map['examName'] as String?,
      subjects: (map['subjects'] as List<dynamic>?)
          ?.map((dynamic s) =>
          ExamSubject.fromMap(s as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examName': examName,
      'subjects': subjects.map((ExamSubject s) => s.toMap()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  ExamSyllabus copyWith({
    String? id,
    String? examName,
    List<ExamSubject>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamSyllabus(
      id: id ?? this.id,
      examName: examName ?? this.examName,
      subjects: subjects ?? this.subjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ExamSubject {
  final String subjectName;
  final List<Topic> topics;
  final DateTime examDate;
  final double totalMarks;
  final String examType;

  ExamSubject({
    required this.subjectName,
    required this.topics,
    required this.examDate,
    required this.totalMarks,
    required this.examType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExamSubject &&
              runtimeType == other.runtimeType &&
              subjectName == other.subjectName &&
              topics == other.topics &&
              examDate == other.examDate &&
              totalMarks == other.totalMarks &&
              examType == other.examType;

  @override
  int get hashCode =>
      subjectName.hashCode ^
      topics.hashCode ^
      examDate.hashCode ^
      totalMarks.hashCode ^
      examType.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
      'topics': topics.map((Topic t) => t.toMap()).toList(),
      'examDate': examDate.toIso8601String(),
      'totalMarks': totalMarks,
      'examType': examType,
    };
  }

  factory ExamSubject.fromMap(Map<String, dynamic> map) {
    return ExamSubject(
      subjectName: map['subjectName'] as String,
      topics: (map['topics'] as List<dynamic>)
          .map((dynamic t) => Topic.fromMap(t as Map<String, dynamic>))
          .toList(),
      examDate: DateTime.parse(map['examDate'] as String),
      totalMarks: (map['totalMarks'] as num).toDouble(),
      examType: map['examType'] as String,
    );
  }

  ExamSubject copyWith({
    String? subjectName,
    List<Topic>? topics,
    DateTime? examDate,
    double? totalMarks,
    String? examType,
  }) {
    return ExamSubject(
      subjectName: subjectName ?? this.subjectName,
      topics: topics ?? this.topics,
      examDate: examDate ?? this.examDate,
      totalMarks: totalMarks ?? this.totalMarks,
      examType: examType ?? this.examType,
    );
  }
}

class Topic {
  final String topicName;
  final List<String> subtopics;
  final double topicMarks;

  Topic({
    required this.topicName,
    required this.subtopics,
    required this.topicMarks,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Topic &&
              runtimeType == other.runtimeType &&
              topicName == other.topicName &&
              subtopics == other.subtopics &&
              topicMarks == other.topicMarks;

  @override
  int get hashCode => topicName.hashCode ^ subtopics.hashCode ^ topicMarks.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'topicName': topicName,
      'subtopics': subtopics,
      'topicMarks': topicMarks,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      topicName: map['topicName'] as String,
      subtopics: (map['subtopics'] as List<dynamic>).cast<String>(),
      topicMarks: (map['topicMarks'] as num).toDouble(),
    );
  }

  Topic copyWith({
    String? topicName,
    List<String>? subtopics,
    double? topicMarks,
  }) {
    return Topic(
      topicName: topicName ?? this.topicName,
      subtopics: subtopics ?? this.subtopics,
      topicMarks: topicMarks ?? this.topicMarks,
    );
  }
}

class SubjectModel {
  final String? id;
  final String? name;
  final String? teacherId;

  SubjectModel({this.id, this.name, this.teacherId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SubjectModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              teacherId == other.teacherId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ teacherId.hashCode;

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      teacherId: map['teacherId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'teacherId': teacherId,
    };
  }

  SubjectModel copyWith({
    String? id,
    String? name,
    String? teacherId,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}