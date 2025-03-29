enum GradingSystem {
  percentage(
    label: "Percentage",
    description: "Scores are represented as a percentage (e.g., 85%).",
  ),
  cgpa(
    label: "CGPA (Cumulative Grade Point Average)",
    description: "Cumulative Grade Point Average system, commonly used in schools.",
  ),
  gpa(
    label: "GPA (Grade Point Average)",
    description: "Grade Point Average system, commonly used in universities.",
  ),
  grade(
    label: "Grade-Based",
    description: "Grades are assigned in letters (A, B, C, etc.) or descriptors (Excellent, Good, etc.).",
  ),
  passFail(
    label: "Pass/Fail",
    description: "Simple system where students either Pass or Fail.",
  ),
  marks(
    label: "Marks-Based",
    description: "Students are graded based on total marks obtained.",
  ),
  other(
    label: "Other",
    description: "Any other grading system not listed.",
  );

  const GradingSystem({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static GradingSystem fromString(String value) {
    return GradingSystem.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => GradingSystem.other,
    );
  }

  static List<String> get labelsList =>
      GradingSystem.values.map((e) => e.label).toList();
}