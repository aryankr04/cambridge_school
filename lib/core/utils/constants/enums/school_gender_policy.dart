enum SchoolGenderPolicy {
  coEducation(
    label: "Co-Education",
    description: "Both boys and girls study together.",
  ),
  boysOnly(
    label: "Boys-Only",
    description: "Only boys are allowed to enroll.",
  ),
  girlsOnly(
    label: "Girls-Only",
    description: "Only girls are allowed to enroll.",
  );

  const SchoolGenderPolicy({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static SchoolGenderPolicy fromString(String value) {
    return SchoolGenderPolicy.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => SchoolGenderPolicy.coEducation,
    );
  }

  static List<String> get labelsList =>
      SchoolGenderPolicy.values.map((e) => e.label).toList();
}