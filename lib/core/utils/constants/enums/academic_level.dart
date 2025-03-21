enum AcademicLevel {
  prePrimary,
  primary,
  middle,
  secondary,
  seniorSecondary,
  undergraduate,
  postgraduate,
  doctoral,
  vocational,
  other
}

extension AcademicLevelExtension on AcademicLevel {
  /// Returns a user-friendly label for the academic level.
  String get label => _labels[this] ?? "Other";

  /// Returns a description explaining the academic level.
  String get description => _descriptions[this] ?? "Any other academic level not listed.";

  /// Mapping of `AcademicLevel` to readable labels.
  static const Map<AcademicLevel, String> _labels = {
    AcademicLevel.prePrimary: "Pre-Primary",
    AcademicLevel.primary: "Primary",
    AcademicLevel.middle: "Middle",
    AcademicLevel.secondary: "Secondary",
    AcademicLevel.seniorSecondary: "Senior Secondary",
    AcademicLevel.undergraduate: "Undergraduate",
    AcademicLevel.postgraduate: "Postgraduate",
    AcademicLevel.doctoral: "Doctoral",
    AcademicLevel.vocational: "Vocational Education",
    AcademicLevel.other: "Other",
  };

  /// Reverse mapping of labels to `AcademicLevel` enum.
  static final Map<String, AcademicLevel> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Mapping of `AcademicLevel` to detailed descriptions.
  static const Map<AcademicLevel, String> _descriptions = {
    AcademicLevel.prePrimary: "Early childhood education (e.g., nursery, kindergarten).",
    AcademicLevel.primary: "Basic education from grades 1 to 5.",
    AcademicLevel.middle: "Intermediate education from grades 6 to 8.",
    AcademicLevel.secondary: "Secondary education, typically grades 9 and 10.",
    AcademicLevel.seniorSecondary: "Higher secondary education, typically grades 11 and 12.",
    AcademicLevel.undergraduate: "Bachelor’s degree or equivalent higher education.",
    AcademicLevel.postgraduate: "Master’s degree or specialized postgraduate studies.",
    AcademicLevel.doctoral: "Doctorate (Ph.D.) or research-based education.",
    AcademicLevel.vocational: "Technical or skill-based education programs.",
    AcademicLevel.other: "Any other academic level not listed.",
  };

  /// Converts a string to the corresponding `AcademicLevel` enum.
  static AcademicLevel fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? AcademicLevel.other;
  }

  /// Returns a list of all academic level labels.
  static List<String> get labelsList => _labels.values.toList();
}
