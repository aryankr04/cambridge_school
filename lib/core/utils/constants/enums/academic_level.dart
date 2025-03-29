enum AcademicLevel {
  prePrimary(
    label: "Pre-Primary",
    description: "Early childhood education (e.g., nursery, kindergarten).",
  ),
  primary(
    label: "Primary",
    description: "Basic education from grades 1 to 5.",
  ),
  middle(
    label: "Middle",
    description: "Intermediate education from grades 6 to 8.",
  ),
  secondary(
    label: "Secondary",
    description: "Secondary education, typically grades 9 and 10.",
  ),
  seniorSecondary(
    label: "Senior Secondary",
    description: "Higher secondary education, typically grades 11 and 12.",
  ),
  undergraduate(
    label: "Undergraduate",
    description: "Bachelor’s degree or equivalent higher education.",
  ),
  postgraduate(
    label: "Postgraduate",
    description: "Master’s degree or specialized postgraduate studies.",
  ),
  doctoral(
    label: "Doctoral",
    description: "Doctorate (Ph.D.) or research-based education.",
  ),
  vocational(
    label: "Vocational Education",
    description: "Technical or skill-based education programs.",
  ),
  other(
    label: "Other",
    description: "Any other academic level not listed.",
  );

  const AcademicLevel({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;


  static AcademicLevel fromLabel(String label) {
    return AcademicLevel.values.firstWhere(
          (element) => element.label == label,
      orElse: () => AcademicLevel.other, // Default to other if label not found
    );
  }

  static List<String> getLabels() {
    return AcademicLevel.values.map((status) => status.label).toList();
  }

  static AcademicLevel fromString(String value) {
    return AcademicLevel.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => AcademicLevel.other, // Default to other if not found
    );
  }
}