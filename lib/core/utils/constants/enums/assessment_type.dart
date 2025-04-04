enum AssessmentType {
  theory('Theory'),
  practical('Practical'),
  assignment('Assignment'),
  quiz('Quiz'),
  viva('Viva'),
  project('Project'),
  presentation('Presentation'),
  attendance('Attendance'),
  classTest('Class Test'),
  midTerm('Mid-Term'),
  finalExam('Final Exam'),
  internalAssessment('Internal Assessment'),
  externalAssessment('External Assessment');

  final String label;
  const AssessmentType(this.label);

  /// Get list of all labels
  static List<String> get labels => values.map((e) => e.label).toList();

  /// Get AssessmentType from enum name or label (case-insensitive, optional)
  static AssessmentType? fromString(String value, {bool ignoreCase = true}) {
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
