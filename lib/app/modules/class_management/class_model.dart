
class SchoolClassModel {
  final String? id;
  final String? schoolId;
  final String? academicYear;
  final String? className;
  final List<SchoolSectionModel>? sections;
  final List<String>? subjects;
  final List<ExamSyllabus> examSyllabus;

  SchoolClassModel({
    this.id,
    this.schoolId,
    this.academicYear,
    this.className,
    this.sections,
    this.subjects,
    required this.examSyllabus,
  });

  factory SchoolClassModel.fromMap(Map<String, dynamic> map, String? documentId) {
    return SchoolClassModel(
      id: documentId, // Use documentId as id
      schoolId: map['schoolId'],
      academicYear: map['academicYear'],
      className: map['className'],
      sections: (map['sections'] as List<dynamic>?)
          ?.map((sectionData) =>
          SchoolSectionModel.fromMap(sectionData as Map<String, dynamic>, null))
          .toList(),
      subjects: map['subjects'] != null
          ? List<String>.from(map['subjects'])
          : null,
      examSyllabus: (map['examSyllabus'] as List<dynamic>)
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
      'subjects': subjects?.map((subject) => subject).toList(),
      'examSyllabus': examSyllabus.map((e) => e.toMap()).toList(),
    };
  }

  SchoolClassModel copyWith({
    String? id,
    String? schoolId,
    String? academicYear,
    String? className,
    List<SchoolSectionModel>? sections,
    List<String>? subjects,
    List<ExamSyllabus>? examSyllabus,
  }) {
    return SchoolClassModel(
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

class SchoolSectionModel {
  final String? sectionName;
  final String? classTeacherId;
  final String? classTeacherName;
  final String? description;
  final String? startDate;
  final String? endDate;
  final int? capacity;
  final String? roomNumber;
  final List<Student>? students;
  final Timetable? timetable;

  SchoolSectionModel({
    this.sectionName,
    this.classTeacherId,
    this.classTeacherName,
    this.description,
    this.startDate,
    this.endDate,
    this.capacity,
    this.roomNumber,
    this.students,
    this.timetable,
  });

  factory SchoolSectionModel.fromMap(
      Map<String, dynamic> data, String? documentId) {
    return SchoolSectionModel(
      sectionName: data['sectionName'],
      classTeacherId: data['classTeacherId'],
      classTeacherName: data['classTeacherName'],
      description: data['description'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      capacity: data['capacity'],
      roomNumber: data['roomNumber'],
      students: (data['students'] as List<dynamic>?)
          ?.map((studentData) =>
          Student.fromMap(studentData as Map<String, dynamic>))
          .toList(),
      timetable: data['timetable'] != null
          ? Timetable.fromMap(data['timetable'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'classTeacherId': classTeacherId,
      'classTeacherName': classTeacherName,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'capacity': capacity,
      'roomNumber': roomNumber,
      'students': students?.map((student) => student.toMap()).toList(),
      if (timetable != null) 'timetable': timetable!.toMap(),
    };
  }

  SchoolSectionModel copyWith({
    String? sectionName,
    String? classTeacherId,
    String? classTeacherName,
    String? description,
    String? startDate,
    String? endDate,
    int? capacity,
    String? roomNumber,
    List<Student>? students,
    Timetable? timetable,
  }) {
    return SchoolSectionModel(
      sectionName: sectionName ?? this.sectionName,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      classTeacherName: classTeacherName ?? this.classTeacherName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      capacity: capacity ?? this.capacity,
      roomNumber: roomNumber ?? this.roomNumber,
      students: students ?? this.students,
      timetable: timetable ?? this.timetable,
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
      id: map['id'],
      name: map['name'],
      roll: map['roll'],
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

class Timetable {
  final Map<String, List<DayEvent>> days;

  Timetable({
    required this.days,
  });

  factory Timetable.fromMap(Map<String, dynamic> data) {
    Map<String, List<DayEvent>> days = {};
    if (data['days'] != null) {
      (data['days'] as Map<String, dynamic>).forEach((day, events) {
        days[day] =
            (events as List).map((event) => DayEvent.fromMap(event)).toList();
      });
    }

    return Timetable(
      days: days,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'days': days.map((day, events) =>
          MapEntry(day, events.map((event) => event.toMap()).toList())),
    };
  }

  Timetable copyWith({
    Map<String, List<DayEvent>>? days,
  }) {
    return Timetable(days: days ?? this.days);
  }
}

class DayEvent {
  final String period;
  final String? subject;
  final String? teacherId;
  final String startTime;
  final String endTime;

  DayEvent({
    required this.period,
    this.subject,
    this.teacherId,
    required this.startTime,
    required this.endTime,
  });

  factory DayEvent.fromMap(Map<String, dynamic> data) {
    return DayEvent(
      period: data['period'] ?? '',
      subject: data['subject'],
      teacherId: data['teacherId'],
      startTime: data['start_time'] ?? '',
      endTime: data['end_time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      if (subject != null) 'subject': subject,
      if (teacherId != null) 'teacherId': teacherId,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  DayEvent copyWith({
    String? period,
    String? subject,
    String? teacherId,
    String? startTime,
    String? endTime,
  }) {
    return DayEvent(
      period: period ?? this.period,
      subject: subject ?? this.subject,
      teacherId: teacherId ?? this.teacherId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
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
      id: map['id'],
      examName: map['examName'],
      subjects:
      (map['subjects'] as List).map((s) => ExamSubject.fromMap(s)).toList(),
      createdAt:
      map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt:
      map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
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
        updatedAt: updatedAt ?? this.updatedAt);
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
      subjectName: map['subjectName'],
      topics: (map['topics'] as List).map((t) => Topic.fromMap(t)).toList(),
      examDate: DateTime.parse(map['examDate']),
      totalMarks: map['totalMarks'].toDouble(),
      examType: map['examType'],
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
  final List<SubTopic> subtopics;
  final double topicMarks;
  final String difficultyLevel;
  final bool isOptional;

  Topic({
    required this.topicName,
    required this.subtopics,
    required this.topicMarks,
    required this.difficultyLevel,
    required this.isOptional,
  });

  Map<String, dynamic> toMap() {
    return {
      'topicName': topicName,
      'subtopics': subtopics.map((e) => e.toMap()).toList(),
      'topicMarks': topicMarks,
      'difficultyLevel': difficultyLevel,
      'isOptional': isOptional,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      topicName: map['topicName'],
      subtopics:
      (map['subtopics'] as List).map((e) => SubTopic.fromMap(e)).toList(),
      topicMarks: map['topicMarks'].toDouble(),
      difficultyLevel: map['difficultyLevel'],
      isOptional: map['isOptional'],
    );
  }

  Topic copyWith({
    String? topicName,
    List<SubTopic>? subtopics,
    double? topicMarks,
    String? difficultyLevel,
    bool? isOptional,
  }) {
    return Topic(
      topicName: topicName ?? this.topicName,
      subtopics: subtopics ?? this.subtopics,
      topicMarks: topicMarks ?? this.topicMarks,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      isOptional: isOptional ?? this.isOptional,
    );
  }
}

class SubTopic {
  final String subtopicName;
  SubTopic({required this.subtopicName});
  Map<String, dynamic> toMap() {
    return {'subtopicName': subtopicName};
  }

  factory SubTopic.fromMap(Map<String, dynamic> map) {
    return SubTopic(subtopicName: map['subtopicName']);
  }

  SubTopic copyWith({
    String? subtopicName,
  }) {
    return SubTopic(subtopicName: subtopicName ?? this.subtopicName);
  }
}

class SubjectModel {
  final String? id;
  final String? name;
  final String? teacherId;
  SubjectModel({this.id, this.name, this.teacherId});
  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
        id: map['id'], name: map['name'], teacherId: map['teacherId']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'teacherId': teacherId};
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