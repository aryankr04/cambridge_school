import 'package:flutter/material.dart';

enum AccountStatus { active, inactive, suspended, pending, banned, deleted }

extension AccountStatusExtension on AccountStatus {
  /// Returns a user-friendly label for the account status.
  String get label => _labels[this] ?? "Deleted";

  /// Returns a description explaining the account status.
  String get description => _descriptions[this] ?? "The account has been permanently deleted.";

  /// Returns a color associated with the account status.
  Color get color => _colors[this] ?? Colors.grey;

  /// Mapping of `AccountStatus` to readable labels.
  static const Map<AccountStatus, String> _labels = {
    AccountStatus.active: "Active",
    AccountStatus.inactive: "Inactive",
    AccountStatus.suspended: "Suspended",
    AccountStatus.pending: "Pending Approval",
    AccountStatus.banned: "Banned",
    AccountStatus.deleted: "Deleted",
  };

  /// Reverse mapping of labels to `AccountStatus` enum.
  static final Map<String, AccountStatus> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Mapping of `AccountStatus` to detailed descriptions.
  static const Map<AccountStatus, String> _descriptions = {
    AccountStatus.active: "The account is active and in good standing.",
    AccountStatus.inactive: "The account is inactive and may require reactivation.",
    AccountStatus.suspended: "The account is temporarily suspended due to policy violations.",
    AccountStatus.pending: "The account is under review and awaiting approval.",
    AccountStatus.banned: "The account has been permanently banned due to serious violations.",
    AccountStatus.deleted: "The account has been permanently deleted and cannot be restored.",
  };

  /// Mapping of `AccountStatus` to associated colors.
  static const Map<AccountStatus, Color> _colors = {
    AccountStatus.active: Colors.green,
    AccountStatus.inactive: Colors.blueGrey,
    AccountStatus.suspended: Colors.orange,
    AccountStatus.pending: Colors.blue,
    AccountStatus.banned: Colors.red,
    AccountStatus.deleted: Colors.grey,
  };

  /// Converts a string to the corresponding `AccountStatus` enum.
  static AccountStatus fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? AccountStatus.deleted;
  }

  /// Returns a list of all account status labels.
  static List<String> get labelsList => _labels.values.toList();
}
