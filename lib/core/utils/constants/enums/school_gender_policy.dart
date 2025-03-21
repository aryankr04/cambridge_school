enum SchoolGenderPolicy {
  coEducation, // Both boys and girls study together
  boysOnly,    // Only boys are allowed to enroll
  girlsOnly,   // Only girls are allowed to enroll
}

extension SchoolGenderPolicyExtension on SchoolGenderPolicy {
  /// Returns a user-friendly label for the gender policy.
  String get label => _labels[this] ?? "Unknown";

  /// Returns a description explaining the gender policy.
  String get description => _descriptions[this] ?? "No description available.";

  /// Mapping of `SchoolGenderPolicy` to readable labels.
  static const Map<SchoolGenderPolicy, String> _labels = {
    SchoolGenderPolicy.coEducation: "Co-Education",
    SchoolGenderPolicy.boysOnly: "Boys-Only",
    SchoolGenderPolicy.girlsOnly: "Girls-Only",
  };

  /// Mapping of `SchoolGenderPolicy` to detailed descriptions.
  static const Map<SchoolGenderPolicy, String> _descriptions = {
    SchoolGenderPolicy.coEducation: "Both boys and girls study together.",
    SchoolGenderPolicy.boysOnly: "Only boys are allowed to enroll.",
    SchoolGenderPolicy.girlsOnly: "Only girls are allowed to enroll.",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, SchoolGenderPolicy> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `SchoolGenderPolicy` enum.
  static SchoolGenderPolicy fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? SchoolGenderPolicy.coEducation;
  }

  /// Returns a list of all gender policy labels.
  static List<String> get labelsList => _labels.values.toList();
}
