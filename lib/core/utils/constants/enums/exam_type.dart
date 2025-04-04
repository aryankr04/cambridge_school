enum ExamType {
  theory('Theory'),
  practical('Practical'),
  viva('Viva / Oral'),
  written('Written'),
  online('Online'),
  offline('Offline'),
  lab('Lab Based'),
  project('Project Based'),
  presentation('Presentation Based');

  final String label;
  const ExamType(this.label);

  /// List of all labels
  static List<String> get labels => values.map((e) => e.label).toList();

  /// Get ExamType from label or name (case-insensitive)
  static ExamType? fromString(String value, {bool ignoreCase = true}) {
    return values.firstWhere(
          (e) =>
      (ignoreCase
          ? e.name.toLowerCase() == value.toLowerCase()
          : e.name == value) ||
          (ignoreCase
              ? e.label.toLowerCase() == value.toLowerCase()
              : e.label == value),
    );
  }
}
