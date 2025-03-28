import 'package:flutter/material.dart';

import '../colors.dart';

enum AttendanceStatus {
  present(
    label: 'Present',
    description: 'Student is present.',
    code: 'P',
    color: MyColors.activeGreen,
    icon: Icons.check_circle,
  ),
  absent(
    label: 'Absent',
    description: 'Student is absent without permission.',
    code: 'A',
    color: MyColors.activeRed,
    icon: Icons.cancel,
  ),
  holiday(
    label: 'Holiday',
    description: 'It\'s a scheduled holiday.',
    code: 'H',
    color: MyColors.activeOrange,
    icon: Icons.event,
  ),
  late(
    label: 'Late',
    description: 'Student arrived late to class.',
    code: 'L',
    color: MyColors.colorPurple,
    icon: Icons.access_time,
  ),
  excused(
    label: 'Excused',
    description: 'Student has a valid excuse for absence.',
    code: 'E',
    color: MyColors.colorViolet,
    icon: Icons.assignment_turned_in,
  ),
  notApplicable(
    label: 'N/A',
    description: 'Attendance is not applicable for this student.',
    code: 'N',
    color: Colors.grey,
    icon: Icons.help_outline,
  ),
  working(
    label: 'Working',
    description:
    'Student is expected to be present but has not been marked as present, late, or absent.',
    code: 'W',
    color: MyColors.activeBlue,
    icon: Icons.work,
  );

  const AttendanceStatus({
    required this.label,
    required this.description,
    required this.code,
    required this.color,
    required this.icon,
  });

  final String label;
  final String description;
  final String code;
  final Color color;
  final IconData icon;

  static AttendanceStatus fromCode(String code) {
    return AttendanceStatus.values.firstWhere(
          (element) => element.code == code,
      orElse: () =>
      AttendanceStatus.notApplicable, // Default to N/A if code not found
    );
  }
  static AttendanceStatus fromLabel(String label) {
    return AttendanceStatus.values.firstWhere(
          (element) => element.label == label,
      orElse: () =>
      AttendanceStatus.notApplicable, // Default to N/A if code not found
    );
  }

  static List<String> getLabels() {
    return AttendanceStatus.values.map((status) => status.label).toList();
  }
}