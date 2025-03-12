// Represents a school class (e.g., "Grade 10", "Class A")
import 'package:flutter/material.dart';

class SchoolClass {
  final String? id;
  final String? schoolId;
  final String? academicYear;
  final String? className;
  final List<ClassSection>? sections;
  final List<String>? subjectNames; // List of subject names
  final List<ExamSyllabus> examSyllabi;

  SchoolClass({
    this.id,
    this.schoolId,
    this.academicYear,
    this.className,
    this.sections,
    this.subjectNames,
    required this.examSyllabi,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SchoolClass && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory SchoolClass.fromMap(Map<String, dynamic> map, String? documentId) {
    return SchoolClass(
      id: documentId,
      schoolId: map['schoolId'] as String?,
      academicYear: map['academicYear'] as String?,
      className: map['className'] as String?,
      sections: (map['sections'] as List<dynamic>?)
          ?.map((sectionData) =>
          ClassSection.fromMap(sectionData as Map<String, dynamic>))
          .toList(),
      subjectNames:
      (map['subjects'] as List<dynamic>?)?.cast<String>().toList(),
      examSyllabi: (map['examSyllabus'] as List<dynamic>)
          .map((e) => ExamSyllabus.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'academicYear': academicYear,
      'className': className,
      'sections': sections?.map((section) => section.toMap()).toList(),
      'subjects': subjectNames,
      'examSyllabus': examSyllabi.map((e) => e.toMap()).toList(),
    };
  }

  SchoolClass copyWith({
    String? id,
    String? schoolId,
    String? academicYear,
    String? className,
    List<ClassSection>? sections,
    List<String>? subjectNames,
    List<ExamSyllabus>? examSyllabi,
  }) {
    return SchoolClass(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      academicYear: academicYear ?? this.academicYear,
      className: className ?? this.className,
      sections: sections ?? this.sections,
      subjectNames: subjectNames ?? this.subjectNames,
      examSyllabi: examSyllabi ?? this.examSyllabi,
    );
  }
}

// Represents a section within a class (e.g., "A", "B")
class ClassSection {
  final String? sectionName;
  final String? teacherId; // Class teacher ID
  final String? teacherName; // Class teacher Name
  final String? description;
  final String? startDate;
  final String? endDate;
  final int? studentCapacity; // Maximum number of students
  final String? roomNumber;
  final List<Student>? students;
  final WeeklyClassSchedule? classSchedule;

  ClassSection({
    this.sectionName,
    this.teacherId,
    this.teacherName,
    this.description,
    this.startDate,
    this.endDate,
    this.studentCapacity,
    this.roomNumber,
    this.students,
    this.classSchedule,
  });

  factory ClassSection.fromMap(Map<String, dynamic> data) {
    return ClassSection(
      sectionName: data['sectionName'] as String?,
      teacherId: data['classTeacherId'] as String?,
      teacherName: data['classTeacherName'] as String?,
      description: data['description'] as String?,
      startDate: data['startDate'] as String?,
      endDate: data['endDate'] as String?,
      studentCapacity: data['capacity'] as int?,
      roomNumber: data['roomNumber'] as String?,
      students: (data['students'] as List<dynamic>?)
          ?.map((studentData) =>
          Student.fromMap(studentData as Map<String, dynamic>))
          .toList(),
      classSchedule: data['schedule'] != null
          ? WeeklyClassSchedule.fromMap(data['schedule'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'classTeacherId': teacherId,
      'classTeacherName': teacherName,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'capacity': studentCapacity,
      'roomNumber': roomNumber,
      'students': students?.map((student) => student.toMap()).toList(),
      if (classSchedule != null) 'schedule': classSchedule!.toMap(),
    };
  }

  ClassSection copyWith({
    String? sectionName,
    String? teacherId,
    String? teacherName,
    String? description,
    String? startDate,
    String? endDate,
    int? studentCapacity,
    String? roomNumber,
    List<Student>? students,
    WeeklyClassSchedule? classSchedule,
  }) {
    return ClassSection(
      sectionName: sectionName ?? this.sectionName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      studentCapacity: studentCapacity ?? this.studentCapacity,
      roomNumber: roomNumber ?? this.roomNumber,
      students: students ?? this.students,
      classSchedule: classSchedule ?? this.classSchedule,
    );
  }
}

// Represents a student
class Student {
  final String? id;
  final String? name;
  final String? rollNumber; // Roll number of Student

  Student({this.id, this.name, this.rollNumber});

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String?,
      name: map['name'] as String?,
      rollNumber: map['roll'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll': rollNumber,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? rollNumber,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
    );
  }
}

// Represents the syllabus for an exam
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

  Map<String, dynamic> toMap() {
    return {
      'examName': examName,
      'subjects': subjects.map((s) => s.toMap()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  factory ExamSyllabus.fromMap(Map<String, dynamic> map) {
    return ExamSyllabus(
      id: map['id'] as String?,
      examName: map['examName'] as String?,
      subjects: (map['subjects'] as List<dynamic>)
          .map((s) => ExamSubject.fromMap(s as Map<String, dynamic>))
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
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

// Represents a subject in an exam
class ExamSubject {
  final String subjectName;
  final List<SyllabusTopic> topics; // Syllabus Topics
  final DateTime examDate;
  final double totalMarks;
  final String examType;
  final List<AssessmentComponent> assessmentComponents;

  ExamSubject({
    required this.subjectName,
    required this.topics,
    required this.examDate,
    required this.totalMarks,
    required this.examType,
    required this.assessmentComponents,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
      'topics': topics.map((t) => t.toMap()).toList(),
      'examDate': examDate.toIso8601String(),
      'totalMarks': totalMarks,
      'examType': examType,
      'assessmentComponents':
      assessmentComponents.map((c) => c.toMap()).toList(),
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
      examType: map['examType'] as String,
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
    String? examType,
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
}

// Represents a generic assessment component (Theory, Practical, Assignment, etc.)
class AssessmentComponent {
  final String type; // e.g., "Theory", "Practical", "Assignment", "Quiz"
  final double? marks;

  AssessmentComponent({
    required this.type,
    this.marks,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'marks': marks,
    };
  }

  factory AssessmentComponent.fromMap(Map<String, dynamic> map) {
    return AssessmentComponent(
      type: map['type'] as String,
      marks: (map['marks'] as num?)?.toDouble(),
    );
  }

  AssessmentComponent copyWith({
    String? type,
    double? weight,
  }) {
    return AssessmentComponent(
      type: type ?? this.type,
      marks: marks,
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
}

// Represents a subject
class Subject {
  final String? id;
  final String? name;
  final String? teacherId;

  Subject({this.id, this.name, this.teacherId});

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
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

  Subject copyWith({
    String? id,
    String? name,
    String? teacherId,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}

// Represents a daily schedule
class DailySchedule {
  final String dayOfWeek;
  final List<ScheduledEvent> events;

  DailySchedule({
    required this.dayOfWeek,
    required this.events,
  });

  factory DailySchedule.fromMap(Map<String, dynamic> map) {
    return DailySchedule(
      dayOfWeek: map['dayOfWeek'] as String,
      events: (map['events'] as List<dynamic>?)
          ?.map((e) => ScheduledEvent.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeek': dayOfWeek,
      'events': events.map((e) => e.toMap()).toList(),
    };
  }

  DailySchedule copyWith({
    String? dayOfWeek,
    List<ScheduledEvent>? events,
  }) {
    return DailySchedule(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      events: events ?? this.events,
    );
  }
}

// Represents a scheduled event (e.g., a class period, break)
class ScheduledEvent {
  final String? subjectName;
  final String? eventType; // e.g., "Class", "Break", "Activity"
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? teacherName;
  final String? roomLocation;

  ScheduledEvent({
    this.subjectName,
    this.eventType,
    required this.startTime,
    required this.endTime,
    this.teacherName,
    this.roomLocation,
  });

  factory ScheduledEvent.fromMap(Map<String, dynamic> map) {
    TimeOfDay parseTimeOfDay(String? timeString) {
      if (timeString == null) {
        return TimeOfDay.now();
      }
      List<String> parts = timeString.split(':');
      if (parts.length != 2) {
        return TimeOfDay.now();
      }
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }

    return ScheduledEvent(
      subjectName: map['subjectName'] as String?,
      eventType: map['eventType'] as String?,
      startTime: parseTimeOfDay(map['startTime'] as String?),
      endTime: parseTimeOfDay(map['endTime'] as String?),
      teacherName: map['teacherName'] as String?,
      roomLocation: map['roomLocation'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    String timeOfDayToString(TimeOfDay timeOfDay) {
      return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    }

    return {
      'subjectName': subjectName,
      'eventType': eventType,
      'startTime': timeOfDayToString(startTime),
      'endTime': timeOfDayToString(endTime),
      'teacherName': teacherName,
      'roomLocation': roomLocation,
    };
  }

  ScheduledEvent copyWith({
    String? subjectName,
    String? eventType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? teacherName,
    String? roomLocation,
  }) {
    return ScheduledEvent(
      subjectName: subjectName ?? this.subjectName,
      eventType: eventType ?? this.eventType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacherName: teacherName ?? this.teacherName,
      roomLocation: roomLocation ?? this.roomLocation,
    );
  }
}

// Represents a weekly class schedule
class WeeklyClassSchedule {
  final List<DailySchedule> weeklySchedule;

  WeeklyClassSchedule({
    required this.weeklySchedule,
  });

  factory WeeklyClassSchedule.fromMap(Map<String, dynamic> map) {
    return WeeklyClassSchedule(
      weeklySchedule: (map['weeklySchedule'] as List<dynamic>)
          .map((e) => DailySchedule.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weeklySchedule': weeklySchedule.map((e) => e.toMap()).toList(),
    };
  }

  WeeklyClassSchedule copyWith({
    String? className,
    String? sectionName,
    List<DailySchedule>? weeklySchedule,
  }) {
    return WeeklyClassSchedule(
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
    );
  }
}