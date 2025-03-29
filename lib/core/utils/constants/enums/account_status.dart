import 'package:flutter/material.dart';

import '../colors.dart';

enum AccountStatus {
  active(
    label: "Active",
    description: "The account is active and in good standing.",
    color: MyColors.activeGreen,
    icon: Icons.check,
  ),
  inactive(
    label: "Inactive",
    description: "The account is inactive and may require reactivation.",
    color: Colors
        .blueGrey, // Kept default color as no specific MyColors color exists
    icon: Icons.pause,
  ),
  suspended(
    label: "Suspended",
    description:
        "The account is temporarily suspended due to policy violations.",
    color: MyColors.activeOrange,
    icon: Icons.warning,
  ),
  pending(
    label: "Pending Approval",
    description: "The account is under review and awaiting approval.",
    color: MyColors
        .activeBlue, //  using active blue as no specific pending color exist
    icon: Icons.pending_actions,
  ),
  banned(
    label: "Banned",
    description:
        "The account has been permanently banned due to serious violations.",
    color: MyColors.activeRed,
    icon: Icons.block,
  ),
  deleted(
    label: "Deleted",
    description:
        "The account has been permanently deleted and cannot be restored.",
    color:
        Colors.grey, // Kept default color as no specific MyColors color exists
    icon: Icons.delete,
  );

  const AccountStatus({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
  });

  final String label;
  final String description;
  final Color color;
  final IconData icon;

  static AccountStatus fromLabel(String label) {
    return AccountStatus.values.firstWhere(
      (element) => element.label == label,
      orElse: () =>
          AccountStatus.deleted, // Default to deleted if label not found
    );
  }

  static List<String> getLabels() {
    return AccountStatus.values.map((status) => status.label).toList();
  }

  static AccountStatus fromString(String value) {
    return AccountStatus.values.firstWhere(
      (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => AccountStatus.deleted, // Default to deleted if not found
    );
  }
}
