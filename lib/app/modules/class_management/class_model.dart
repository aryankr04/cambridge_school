import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:collection/collection.dart'; // For deep equality checks

import '../../../core/utils/constants/enums/assessment_type.dart';
import '../../../core/utils/constants/enums/exam_type.dart';
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
    this.examSyllabus = const [],
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

  // Add a Section (prevents duplicates)
  void addSection(SectionModel section) {
    if (!sections.any((s) => s == section)) {
      sections.add(section);
    } else {
      MySnackBar.showErrorSnackBar('Section "${section.sectionName}" already exists.');
    }
  }

  // Update a Section (finds by sectionName, replaces if found)
  void updateSection(String sectionName, SectionModel updatedSection) {
    final index = sections.indexWhere((s) => s.sectionName == sectionName);
    if (index != -1) {
      sections[index] = updatedSection;
    } else {
      MySnackBar.showErrorSnackBar('Section "$sectionName" not found for updating.');
    }
  }

  // Delete a Section (finds by sectionName)
  void deleteSection(String sectionName) {
    final initialLength = sections.length;
    sections.removeWhere((s) => s.sectionName == sectionName);
    if (sections.length == initialLength) {
      MySnackBar.showErrorSnackBar('Section "$sectionName" not found for deletion.');
    }
  }

  // Add a Subject (prevents duplicates, case-insensitive)
  void addSubject(String subject) {
    if (!subjects.any((s) => s.toLowerCase() == subject.toLowerCase())) {
      subjects.add(subject);
    } else {
      MySnackBar.showErrorSnackBar('Subject "$subject" already exists.');
    }
  }

  // Update a Subject (finds by original subject, replaces)
  void updateSubject(String originalSubject, String updatedSubject) {
    final index = subjects.indexWhere((s) => s == originalSubject);
    if (index != -1) {
      subjects[index] = updatedSubject;
    } else {
      MySnackBar.showErrorSnackBar('Subject "$originalSubject" not found for updating.');
    }
  }

  // Delete a Subject
  void deleteSubject(String subject) {
    final initialLength = subjects.length;
    subjects.remove(subject);
    if (subjects.length == initialLength) {
      MySnackBar.showErrorSnackBar('Subject "$subject" not found for deletion.');
    }
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
      // More informative error message.  Consider re-throwing or handling appropriately.
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
      }
    } catch (e) {
      //More informative.  Consider re-throwing or handling appropriately.
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
      }
    } catch (e) {
      //More informative.  Consider re-throwing or handling appropriately.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SectionModel &&
              runtimeType == other.runtimeType &&
              sectionName == other.sectionName &&
              classTeacherId == other.classTeacherId &&
              classTeacherName == other.classTeacherName &&
              roomNumber == other.roomNumber &&
              const DeepCollectionEquality().equals(students, other.students) &&
              const DeepCollectionEquality().equals(routine, other.routine);

  @override
  int get hashCode =>
      sectionName.hashCode ^
      classTeacherId.hashCode ^
      classTeacherName.hashCode ^
      roomNumber.hashCode ^
      students.hashCode ^
      routine.hashCode;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Student &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              roll == other.roll;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ roll.hashCode;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExamSyllabus &&
              runtimeType == other.runtimeType &&
              examName == other.examName &&
              const DeepCollectionEquality().equals(subjects, other.subjects) &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      examName.hashCode ^ subjects.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;

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

  // ExamSubject Operations
  void addExamSubject(ExamSubject subject) {
    if (!subjects.any((s) => s == subject)) {
      subjects.add(subject);
    } else {
      MySnackBar.showErrorSnackBar('Subject "${subject.subjectName}" already exists in this exam.');
    }
  }

  void updateExamSubject(String subjectName, ExamSubject updatedSubject) {
    final index = subjects.indexWhere((s) => s.subjectName == subjectName);
    if (index != -1) {
      subjects[index] = updatedSubject;
    } else {
      MySnackBar.showErrorSnackBar('Subject "$subjectName" not found for updating in this exam.');
    }
  }

  void deleteExamSubject(String subjectName) {
    final initialLength = subjects.length;
    subjects.removeWhere((s) => s.subjectName == subjectName);
    if (subjects.length == initialLength) {
      MySnackBar.showErrorSnackBar('Subject "$subjectName" not found for deletion in this exam.');
    }
  }
}

// Represents a subject in an exam

class ExamSubject {
  final String subjectName;
  final List<SyllabusTopic> topics;
  final DateTime examDate;
  final double totalMarks;
  final ExamType examType;
  final List<AssessmentComponent> assessmentComponents;

  ExamSubject({
    required this.subjectName,
    required this.topics,
    required this.examDate,
    required this.totalMarks,
    required this.examType,
    required this.assessmentComponents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExamSubject &&
              runtimeType == other.runtimeType &&
              subjectName == other.subjectName &&
              const DeepCollectionEquality().equals(topics, other.topics) &&
              examDate == other.examDate &&
              totalMarks == other.totalMarks &&
              examType == other.examType &&
              const DeepCollectionEquality().equals(assessmentComponents, other.assessmentComponents);

  @override
  int get hashCode =>
      subjectName.hashCode ^
      topics.hashCode ^
      examDate.hashCode ^
      totalMarks.hashCode ^
      examType.hashCode ^
      assessmentComponents.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
      'topics': topics.map((t) => t.toMap()).toList(),
      'examDate': examDate.toIso8601String(),
      'totalMarks': totalMarks,
      'examType': examType.name, // store enum name
      'assessmentComponents': assessmentComponents.map((c) => c.toMap()).toList(),
    };
  }

  factory ExamSubject.fromMap(Map<String, dynamic> map) {
    return ExamSubject(
      subjectName: map['subjectName'] as String,
      topics: (map['topics'] as List<dynamic>)
          .map((t) => SyllabusTopic.fromMap(t as Map<String, dynamic>))
          .toList(),
      examDate: DateTime.parse(map['examDate'] as String),
      totalMarks: (map['totalMarks'] as num).toDouble(),
      examType: ExamType.fromString(map['examType']) ?? ExamType.theory,
      assessmentComponents: (map['assessmentComponents'] as List<dynamic>)
          .map((c) => AssessmentComponent.fromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }

  ExamSubject copyWith({
    String? subjectName,
    List<SyllabusTopic>? topics,
    DateTime? examDate,
    double? totalMarks,
    ExamType? examType,
    List<AssessmentComponent>? assessmentComponents,
  }) {
    return ExamSubject(
      subjectName: subjectName ?? this.subjectName,
      topics: topics ?? this.topics,
      examDate: examDate ?? this.examDate,
      totalMarks: totalMarks ?? this.totalMarks,
      examType: examType ?? this.examType,
      assessmentComponents: assessmentComponents ?? this.assessmentComponents,
    );
  }

  // SyllabusTopic Operations
  void addSyllabusTopic(SyllabusTopic topic) {
    if (!topics.any((t) => t == topic)) {
      topics.add(topic);
    } else {
      MySnackBar.showErrorSnackBar('Topic "${topic.topicName}" already exists in this subject.');
    }
  }

  void updateSyllabusTopic(String topicName, SyllabusTopic updatedTopic) {
    final index = topics.indexWhere((t) => t.topicName == topicName);
    if (index != -1) {
      topics[index] = updatedTopic;
    } else {
      MySnackBar.showErrorSnackBar('Topic "$topicName" not found for updating in this subject.');
    }
  }

  void deleteSyllabusTopic(String topicName) {
    final initialLength = topics.length;
    topics.removeWhere((t) => t.topicName == topicName);
    if (topics.length == initialLength) {
      MySnackBar.showErrorSnackBar('Topic "$topicName" not found for deletion in this subject.');
    }
  }

  // AssessmentComponent Operations
  void addAssessmentComponent(AssessmentComponent component) {
    if (!assessmentComponents.any((c) => c == component)) {
      assessmentComponents.add(component);
    } else {
      MySnackBar.showErrorSnackBar('Assessment component "${component.type}" already exists in this subject.');
    }
  }

  void updateAssessmentComponent(String type, AssessmentComponent updatedComponent) {
    final index = assessmentComponents.indexWhere((c) => c.type == type);
    if (index != -1) {
      assessmentComponents[index] = updatedComponent;
    } else {
      MySnackBar.showErrorSnackBar('Assessment component "$type" not found for updating in this subject.');
    }
  }

  void deleteAssessmentComponent(String type) {
    final initialLength = assessmentComponents.length;
    assessmentComponents.removeWhere((c) => c.type == type);
    if (assessmentComponents.length == initialLength) {
      MySnackBar.showErrorSnackBar('Assessment component "$type" not found for deletion in this subject.');
    }
  }
}

// Represents a generic assessment component (Theory, Practical, Assignment, etc.)
class AssessmentComponent {
  final AssessmentType type;
  final double? marks;

  AssessmentComponent({
    required this.type,
    this.marks,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AssessmentComponent &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              marks == other.marks;

  @override
  int get hashCode => type.hashCode ^ marks.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'type': type.name, // store enum name (like 'theory')
      'marks': marks,
    };
  }

  factory AssessmentComponent.fromMap(Map<String, dynamic> map) {
    return AssessmentComponent(
      type: AssessmentType.values.firstWhere(
            (e) => e.name == map['type'],
        orElse: () => AssessmentType.theory,
      ),
      marks: (map['marks'] as num?)?.toDouble(),
    );
  }

  AssessmentComponent copyWith({
    AssessmentType? type,
    double? marks,
  }) {
    return AssessmentComponent(
      type: type ?? this.type,
      marks: marks ?? this.marks,
    );
  }
}

// Represents a topic within a subject's syllabus
class SyllabusTopic {
  final String topicName;
  final List<String> subtopics;
  final double topicMarksWeight; // How much this topic contributes to total marks

  SyllabusTopic({
    required this.topicName,
    required this.subtopics,
    required this.topicMarksWeight,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SyllabusTopic &&
              runtimeType == other.runtimeType &&
              topicName == other.topicName &&
              const DeepCollectionEquality().equals(subtopics, other.subtopics) &&
              topicMarksWeight == other.topicMarksWeight;

  @override
  int get hashCode =>
      topicName.hashCode ^ subtopics.hashCode ^ topicMarksWeight.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'topicName': topicName,
      'subtopics': subtopics,
      'topicMarks': topicMarksWeight,
    };
  }

  factory SyllabusTopic.fromMap(Map<String, dynamic> map) {
    return SyllabusTopic(
      topicName: map['topicName'] as String,
      subtopics: List<String>.from(map['subtopics'] as List),
      topicMarksWeight: (map['topicMarks'] as num).toDouble(),
    );
  }

  SyllabusTopic copyWith({
    String? topicName,
    List<String>? subtopics,
    double? topicMarksWeight,
  }) {
    return SyllabusTopic(
      topicName: topicName ?? this.topicName,
      subtopics: subtopics ?? this.subtopics,
      topicMarksWeight: topicMarksWeight ?? this.topicMarksWeight,
    );
  }

  // Subtopic Operations
  void addSubtopic(String subtopic) {
    if (!subtopics.any((s) => s == subtopic)) {
      subtopics.add(subtopic);
    } else {
      MySnackBar.showErrorSnackBar('Subtopic "$subtopic" already exists in this topic.');
    }
  }

  void updateSubtopic(String originalSubtopic, String updatedSubtopic) {
    final index = subtopics.indexWhere((s) => s == originalSubtopic);
    if (index != -1) {
      subtopics[index] = updatedSubtopic;
    } else {
      MySnackBar.showErrorSnackBar('Subtopic "$originalSubtopic" not found for updating in this topic.');
    }
  }

  void deleteSubtopic(String subtopic) {
    final initialLength = subtopics.length;
    subtopics.remove(subtopic);
    if (subtopics.length == initialLength) {
      MySnackBar.showErrorSnackBar('Subtopic "$subtopic" not found for deletion in this topic.');
    }
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