import 'package:flutter/material.dart';

import '../colors.dart';

enum ScheduleEventType {
  start(label: 'Start', emoji: '🛎️', color: MyColors.activeGreen),
  classSession(label: 'Class', emoji: '📝', color: MyColors.activeBlue),
  breakTime(label: 'Break', emoji: '🍔', color: MyColors.activeOrange),
  assembly(label: 'Assembly', emoji: '🥁', color: MyColors.activeOrange),
  departure(label: 'Departure', emoji: '🚌', color: MyColors.activeRed),
  lunch(label: 'Lunch Break', emoji: '🍱', color: MyColors.activeOrange),
  exam(label: 'Exam', emoji: '📝', color: MyColors.activeRed),
  labSession(
      label: 'Lab Session', emoji: '🧪', color: MyColors.colorPurple),
  tutorial(
      label: 'Tutorial Class',
      emoji: '🧑‍🏫',
      color: MyColors.activeBlue),
  revision(
      label: 'Revision Class', emoji: '📖', color: MyColors.activeBlue),
  groupDiscussion(
      label: 'Group Discussion',
      emoji: '🗣️',
      color: MyColors.activeOrange),
  presentation(
      label: 'Presentation', emoji: '🎤', color: MyColors.activeOrange),
  doubtClearing(
      label: 'Doubt Clearing Session',
      emoji: '❓',
      color: MyColors.colorTeal),
  test(label: 'Test', emoji: '✅', color: MyColors.activeRed),
  seminar(label: 'Seminar', emoji: '📢', color: MyColors.activeOrange),
  practical(
      label: 'Practical Session',
      emoji: '⚙️',
      color: MyColors.colorPurple),
  assignment(
      label: 'Assignment Work', emoji: '✍️', color: MyColors.colorTeal),
  selfStudy(label: 'Self Study', emoji: '🧘', color: MyColors.colorTeal),
  clubActivity(
      label: 'Club Activity', emoji: '🎭', color: MyColors.activeOrange),
  specialClass(
      label: 'Special Class', emoji: '⭐', color: MyColors.activeBlue),
  projectWork(
      label: 'Project Work', emoji: '🏗️', color: MyColors.colorTeal),
  counseling(
      label: 'Counseling Session',
      emoji: '🫂',
      color: MyColors.colorTeal),
  remedialClass(
      label: 'Remedial Class',
      emoji: '🧑‍🏫',
      color: MyColors.colorTeal),
  electiveClass(
      label: 'Elective Class', emoji: '💡', color: MyColors.activeBlue),
  librarySession(
      label: 'Library Session', emoji: '📚', color: MyColors.colorTeal),
  sportsPeriod(
      label: 'Sports Period', emoji: '⚽', color: MyColors.colorTeal),
  artAndCraft(
      label: 'Art & Craft', emoji: '🎨', color: MyColors.colorTeal),
  musicClass(
      label: 'Music Class', emoji: '🎶', color: MyColors.colorTeal),
  computerLab(
      label: 'Computer Lab', emoji: '💻', color: MyColors.colorPurple),
  languageLab(
      label: 'Language Lab', emoji: '🗣️', color: MyColors.colorPurple),
  careerGuidance(
      label: 'Career Guidance', emoji: '🧭', color: MyColors.colorTeal);

  final String label;
  final String emoji;
  final Color color;

  const ScheduleEventType({
    required this.label,
    required this.emoji,
    required this.color,
  });

  /// Get a list of all labels
  static List<String> get labels =>
      ScheduleEventType.values.map((e) => e.label).toList();

  /// Convert string to ScheduleEventType
  static ScheduleEventType? fromString(String value) {
    return ScheduleEventType.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ScheduleEventType.classSession,
    );
  }

  String get displayName => label;
  String get emojiIcon => emoji;
}
