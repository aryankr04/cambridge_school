enum GradingSystem {
  percentage,
  cgpa,
  gpa,
  grade,
  passFail,
  marks,
  other
}

extension GradingSystemExtension on GradingSystem {
  /// Returns a user-friendly label for the grading system.
  String get label => _labels[this] ?? "Other";

  /// Returns a description explaining the grading system.
  String get description => _descriptions[this] ?? "Any other grading system not listed.";

  /// Mapping of `GradingSystem` to readable labels.
  static const Map<GradingSystem, String> _labels = {
    GradingSystem.percentage: "Percentage",
    GradingSystem.cgpa: "CGPA (Cumulative Grade Point Average)",
    GradingSystem.gpa: "GPA (Grade Point Average)",
    GradingSystem.grade: "Grade-Based",
    GradingSystem.passFail: "Pass/Fail",
    GradingSystem.marks: "Marks-Based",
    GradingSystem.other: "Other",
  };

  /// Reverse mapping of labels to `GradingSystem` enum.
  static final Map<String, GradingSystem> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Mapping of `GradingSystem` to detailed descriptions.
  static const Map<GradingSystem, String> _descriptions = {
    GradingSystem.percentage: "Scores are represented as a percentage (e.g., 85%).",
    GradingSystem.cgpa: "Cumulative Grade Point Average system, commonly used in schools.",
    GradingSystem.gpa: "Grade Point Average system, commonly used in universities.",
    GradingSystem.grade: "Grades are assigned in letters (A, B, C, etc.) or descriptors (Excellent, Good, etc.).",
    GradingSystem.passFail: "Simple system where students either Pass or Fail.",
    GradingSystem.marks: "Students are graded based on total marks obtained.",
    GradingSystem.other: "Any other grading system not listed.",
  };

  /// Converts a string to the corresponding `GradingSystem` enum.
  static GradingSystem fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? GradingSystem.other;
  }

  /// Returns a list of all grading system labels.
  static List<String> get labelsList => _labels.values.toList();
}
