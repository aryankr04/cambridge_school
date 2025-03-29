enum ExaminationPattern {
  annual(
    label: "Annual",
    description: "A single final exam at the end of the academic year.",
  ),
  semester(
    label: "Semester",
    description: "Two major exams per year, one per semester.",
  ),
  trimester(
    label: "Trimester",
    description: "Three exams per year, one every four months.",
  ),
  quarterly(
    label: "Quarterly",
    description: "Four exams per year, one per quarter.",
  ),
  monthly(
    label: "Monthly",
    description: "Exams conducted every month.",
  ),
  continuousAssessment(
    label: "Continuous Assessment",
    description: "Frequent tests, assignments, and projects throughout the year.",
  ),
  other(
    label: "Other",
    description: "Any other exam pattern not listed.",
  );

  const ExaminationPattern({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static ExaminationPattern fromString(String value) {
    return ExaminationPattern.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ExaminationPattern.other,
    );
  }

  static List<String> get labelsList =>
      ExaminationPattern.values.map((e) => e.label).toList();
}