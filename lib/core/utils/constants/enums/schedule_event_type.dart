import 'package:flutter/material.dart';

import '../dynamic_colors.dart';

enum ScheduleEventType {
  start('Start', '🛎️'),
  classSession('Class', '📝'),
  breakTime('Break', '🍔'),
  assembly('Assembly', '🥁'),
  departure('Departure', '🚌'),
  lunch('Lunch Break', '🍱'),
  exam('Exam', '📝'),
  labSession('Lab Session', '🧪'),
  tutorial('Tutorial Class', '🧑‍🏫'),
  revision('Revision Class', '📖'),
  groupDiscussion('Group Discussion', '🗣️'),
  presentation('Presentation', '🎤'),
  doubtClearing('Doubt Clearing Session', '❓'),
  test('Test', '✅'),
  seminar('Seminar', '📢'),
  practical('Practical Session', '⚙️'),
  assignment('Assignment Work', '✍️'),
  selfStudy('Self Study', '🧘'),
  clubActivity('Club Activity', '🎭'),
  specialClass('Special Class', '⭐'),
  projectWork('Project Work', '🏗️'),
  counseling('Counseling Session', '🫂'),
  remedialClass('Remedial Class', '🧑‍🏫'),
  electiveClass('Elective Class', '💡'),
  librarySession('Library Session', '📚'),
  sportsPeriod('Sports Period', '⚽'),
  artAndCraft('Art & Craft', '🎨'),
  musicClass('Music Class', '🎶'),
  computerLab('Computer Lab', '💻'),
  languageLab('Language Lab', '🗣️'),
  careerGuidance('Career Guidance', '🧭');

  final String label;
  final String emoji;
  const ScheduleEventType(this.label, this.emoji);

  /// Get a list of all labels
  static List<String> get labels =>
      ScheduleEventType.values.map((e) => e.label).toList();

  /// Convert string to ScheduleEventType
  static ScheduleEventType? fromString(String value) {
    try {
      return ScheduleEventType.values.firstWhere(
        (e) => e.label.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null; // Or throw an exception if you prefer
    }
  }
}

extension ScheduleEventTypeExtension on ScheduleEventType {
  String get displayName => label;
  String get emojiIcon => emoji;

  Color get color {
    switch (this) {
      case ScheduleEventType.classSession:
      case ScheduleEventType.tutorial:
      case ScheduleEventType.revision:
      case ScheduleEventType.specialClass:
      case ScheduleEventType.electiveClass:
        return MyDynamicColors.activeBlue;
      case ScheduleEventType.breakTime:
      case ScheduleEventType.lunch:
        return MyDynamicColors.activeOrange;
      case ScheduleEventType.departure:
        return MyDynamicColors.activeRed;
      case ScheduleEventType.start:
        return MyDynamicColors.activeGreen;
      case ScheduleEventType.assembly:
      case ScheduleEventType.groupDiscussion:
      case ScheduleEventType.presentation:
      case ScheduleEventType.seminar:
      case ScheduleEventType.clubActivity:
        return MyDynamicColors.activeOrange; // Or another appropriate color
      case ScheduleEventType.exam:
      case ScheduleEventType.test:
        return MyDynamicColors.activeRed;
      case ScheduleEventType.labSession:
      case ScheduleEventType.practical:
      case ScheduleEventType.computerLab:
      case ScheduleEventType.languageLab:
        return MyDynamicColors.colorPurple;
      case ScheduleEventType.doubtClearing:
      case ScheduleEventType.projectWork:
      case ScheduleEventType.counseling:
      case ScheduleEventType.remedialClass:
      case ScheduleEventType.librarySession:
      case ScheduleEventType.sportsPeriod:
      case ScheduleEventType.artAndCraft:
      case ScheduleEventType.musicClass:
      case ScheduleEventType.careerGuidance:
      case ScheduleEventType.assignment:
      case ScheduleEventType.selfStudy:
        return MyDynamicColors.colorTeal;

      default:
        return Colors.grey;
    }
  }
}
