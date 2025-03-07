import 'package:cloud_firestore/cloud_firestore.dart';


class Notice {
  String title;
  String description;
  String createdById;
  DateTime createdTime;
  String category;
  String? attachmentUrl;
  bool isImportant;
  List<String> targetAudience;
  List<String>? targetClass;

  Notice({
    required this.title,
    required this.description,
    required this.createdById,
    required this.createdTime,
    required this.category,
    this.attachmentUrl,
    this.isImportant = false,
    required this.targetAudience,
    this.targetClass,
  });

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdById: map['createdById'] ?? '',
      createdTime: (map['createdTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: map['category'] ?? 'General',
      attachmentUrl: map['attachmentUrl'],
      isImportant: map['isImportant'] ?? false,
      targetAudience: List<String>.from(map['targetAudience'] ?? []),
      targetClass: List<String>.from(map['targetClass'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdById': createdById,
      'createdTime': createdTime,
      'category': category,
      'attachmentUrl': attachmentUrl,
      'isImportant': isImportant,
      'targetAudience': targetAudience,
      'targetClass': targetClass ?? [],
    };
  }
}

class NoticeRoster {
  String schoolId;
  String academicYear;
  List<Notice> notices;

  NoticeRoster({
    required this.schoolId,
    required this.academicYear,
    required this.notices,
  });
}