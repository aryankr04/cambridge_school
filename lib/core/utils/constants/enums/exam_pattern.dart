enum ExaminationPattern {
  annual,
  semester,
  trimester,
  quarterly,
  monthly,
  continuousAssessment,
  other
}

extension ExaminationPatternExtension on ExaminationPattern {
  static const Map<ExaminationPattern, String> _labels = {
    ExaminationPattern.annual: "Annual",
    ExaminationPattern.semester: "Semester",
    ExaminationPattern.trimester: "Trimester",
    ExaminationPattern.quarterly: "Quarterly",
    ExaminationPattern.monthly: "Monthly",
    ExaminationPattern.continuousAssessment: "Continuous Assessment",
    ExaminationPattern.other: "Other",
  };

  static const Map<ExaminationPattern, String> _descriptions = {
    ExaminationPattern.annual: "A single final exam at the end of the academic year.",
    ExaminationPattern.semester: "Two major exams per year, one per semester.",
    ExaminationPattern.trimester: "Three exams per year, one every four months.",
    ExaminationPattern.quarterly: "Four exams per year, one per quarter.",
    ExaminationPattern.monthly: "Exams conducted every month.",
    ExaminationPattern.continuousAssessment: "Frequent tests, assignments, and projects throughout the year.",
    ExaminationPattern.other: "Any other exam pattern not listed.",
  };

  String get label => _labels[this] ?? "Unknown";

  String get description => _descriptions[this] ?? "No description available.";

  /// Cached map for fast string-to-enum conversion
  static final Map<String, ExaminationPattern> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key
  };

  /// Converts a string label to the corresponding `ExaminationPattern` enum.
  static ExaminationPattern fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? ExaminationPattern.other;
  }

  /// Returns a list of all examination pattern labels.
  static List<String> get labelsList => _labels.values.toList();
}
