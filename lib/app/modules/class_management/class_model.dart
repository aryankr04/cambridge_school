import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';

import '../routine/routine_model.dart';

class ClassModel {
  final String id;
  final String? academicYear;
  final ClassName className;
  final List<SectionModel> sections;
  final List<String> subjects;
  final List<ExamSyllabus> examSyllabus;

  ClassModel({
    required this.id,
    this.academicYear,
    required this.className,
    this.sections = const [],
    this.subjects = const [],
    required this.examSyllabus,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map, String? documentId) {
    return ClassModel(
      id: map['id'] as String,
      academicYear: map['academicYear'] as String?,
      className: ClassName.fromString(map['className'] as String),
      sections: (map['sections'] as List<dynamic>?)
              ?.map((dynamic sectionData) => SectionModel.fromMap(
                  sectionData as Map<String, dynamic>, null))
              .toList() ??
          const [],
      subjects: (map['subjects'] as List<dynamic>?)?.cast<String>() ?? const [],
      examSyllabus: (map['examSyllabus'] as List<dynamic>?)
              ?.map((dynamic e) =>
                  ExamSyllabus.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'academicYear': academicYear,
      'className': className.label,
      'sections': sections.map((section) => section.toMap()).toList(),
      'subjects': subjects,
      'examSyllabus': examSyllabus.map((e) => e.toMap()).toList(),
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
      academicYear: academicYear ?? this.academicYear,
      className: className ?? this.className,
      sections: sections ?? this.sections,
      subjects: subjects ?? this.subjects,
      examSyllabus: examSyllabus ?? this.examSyllabus,
    );
  }

  void sortSections() {
    sections.sort((a, b) => (a.sectionName).compareTo(b.sectionName));
  }

  // Add a Section
  void addSection(SectionModel section) {
    sections.add(section);
  }

  // Update a Section
  void updateSection(int index, String sectionName, SectionModel updatedSection) {
    if (index != -1) {
      sections[index] = updatedSection;
    } else {
      print('Section $sectionName not found for updating.');
    }
  }

  // Delete a Section
  void deleteSection(String sectionName) {
    sections.removeWhere((s) => s.sectionName == sectionName);
  }

  // Add a Subject
  void addSubject(String subject) {
    subjects.add(subject);
  }

  // Update a Subject
  void updateSubject(int index, String updatedSubject) {
    if (index >= 0 && index < subjects.length) {
      subjects[index] = updatedSubject;
    } else {
      print('Subject not found at index $index.');
    }
  }

  // Delete a Subject
  void deleteSubject(String subject) {
    subjects.remove(subject);
  }

  void addEventToRoutine(String sectionName, String day, Event event) {
    try {
      final section = sections.firstWhere(
        (s) => s.sectionName == sectionName,
      );

      final dailyRoutine = section.routine.firstWhere(
        (dr) => dr.day == day,
        orElse: () {
          final newDailyRoutine = DailyRoutine(day: day, events: []);
          section.routine.add(newDailyRoutine);
          return newDailyRoutine;
        },
      );

      dailyRoutine.events.add(event);
      MySnackBar.showSuccessSnackBar('Event added successfully.');
    } catch (e) {
      print(
          'Error adding event: $e'); // More informative error message.  Consider re-throwing or handling appropriately.
    }
  }

  void updateEventInRoutine(
      String sectionName, String day, int index, Event updatedEvent) {
    try {
      final section = sections.firstWhere(
        (s) => s.sectionName == sectionName,
      );

      final dailyRoutine = section.routine.firstWhere(
        (dr) => dr.day == day,
      );

      if (index >= 0 && index < dailyRoutine.events.length) {
        dailyRoutine.events[index] = updatedEvent;
      } else {
        print(
            'Event not found at index $index on day $day for section $sectionName.');
      }
    } catch (e) {
      print(
          'Error updating event: $e'); //More informative.  Consider re-throwing or handling appropriately.
    }
  }

  void deleteEventInRoutine(String sectionName, String day, int index) {
    try {
      final section = sections.firstWhere(
        (s) => s.sectionName == sectionName,
      );

      final dailyRoutine = section.routine.firstWhere(
        (dr) => dr.day == day,
      );

      if (index >= 0 && index < dailyRoutine.events.length) {
        dailyRoutine.events.removeAt(index);
      } else {
        print(
            'Event not found at index $index on day $day for section $sectionName.');
      }
    } catch (e) {
      print(
          'Error deleting event: $e'); //More informative.  Consider re-throwing or handling appropriately.
    }
  }
}

class SectionModel {
  final String sectionName;
  final String classTeacherId;
  final String classTeacherName;
  final String roomNumber;
  final List<Student> students;
  final List<DailyRoutine> routine;

  SectionModel({
    required this.sectionName,
    required this.classTeacherId,
    required this.classTeacherName,
    required this.roomNumber,
    required this.students,
    this.routine = const [],
  });

  factory SectionModel.fromMap(Map<String, dynamic> data, String? documentId) {
    return SectionModel(
      sectionName: data['sectionName'] as String,
      classTeacherId: data['classTeacherId'] as String,
      classTeacherName: data['classTeacherName'] as String,
      roomNumber: data['roomNumber'] as String,
      students: (data['students'] as List<dynamic>?)
              ?.map((dynamic studentData) =>
                  Student.fromMap(studentData as Map<String, dynamic>))
              .toList() ??
          const [],
      routine: (data['routine'] as List<dynamic>?)
              ?.map((dynamic routineData) =>
                  DailyRoutine.fromMap(routineData as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'classTeacherId': classTeacherId,
      'classTeacherName': classTeacherName,
      'roomNumber': roomNumber,
      'students': students.map((student) => student.toMap()).toList(),
      'routine': routine.map((dailyRoutine) => dailyRoutine.toMap()).toList(),
    };
  }

  SectionModel copyWith({
    String? sectionName,
    String? classTeacherId,
    String? classTeacherName,
    String? roomNumber,
    List<Student>? students,
    List<DailyRoutine>? routine,
  }) {
    return SectionModel(
      sectionName: sectionName ?? this.sectionName,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      classTeacherName: classTeacherName ?? this.classTeacherName,
      roomNumber: roomNumber ?? this.roomNumber,
      students: students ?? this.students,
      routine: routine ?? this.routine,
    );
  }
}

class Student {
  final String id;
  final String name;
  final String roll;

  Student({required this.id, required this.name, required this.roll});

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      roll: map['roll'] as String,
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
  final String examName;
  final List<ExamSubject> subjects;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExamSyllabus({
    required this.examName,
    required this.subjects,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'ExamSyllabus{examName: $examName, subjects: $subjects, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  factory ExamSyllabus.fromMap(Map<String, dynamic> map) {
    return ExamSyllabus(
      examName: map['examName'] as String,
      subjects: (map['subjects'] as List<dynamic>?)
              ?.map(
                  (dynamic s) => ExamSubject.fromMap(s as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examName': examName,
      'subjects': subjects.map((s) => s.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  ExamSyllabus copyWith({
    String? examName,
    List<ExamSubject>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamSyllabus(
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
      'topics': topics.map((t) => t.toMap()).toList(),
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
  int get hashCode =>
      topicName.hashCode ^ subtopics.hashCode ^ topicMarks.hashCode;

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
