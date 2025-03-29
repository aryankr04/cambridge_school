enum SchoolSpecialization {
  general(
    label: "General",
    description: "Standard academic curriculum.",
  ),
  specialEducation(
    label: "Special Education",
    description: "Schools for children with disabilities or special needs.",
  ),
  vocational(
    label: "Vocational",
    description: "Focuses on skill-based and technical education.",
  ),
  sports(
    label: "Sports",
    description: "Specialized in sports training and education.",
  ),
  military(
    label: "Military",
    description: "Schools run by defense organizations.",
  ),
  religious(
    label: "Religious",
    description: "Faith-based education (Christian, Islamic, Hindu, etc.).",
  ),
  arts(
    label: "Arts",
    description: "Focused on music, dance, drama, and fine arts.",
  ),
  science(
    label: "Science",
    description: "Specialized in STEM (Science, Technology, Engineering, Math).",
  ),
  agricultural(
    label: "Agricultural",
    description: "Focuses on farming and agricultural sciences.",
  ),
  business(
    label: "Business",
    description: "Focused on entrepreneurship and commerce.",
  ),
  online(
    label: "Online",
    description: "Virtual or online-only schooling.",
  ),
  homeSchool(
    label: "Home School",
    description: "Parents educate children at home.",
  ),
  openSchool(
    label: "Open School",
    description: "Flexible schooling for dropouts or non-traditional learners.",
  ),
  other(
    label: "Other",
    description: "Any other specialization not listed.",
  );

  const SchoolSpecialization({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static SchoolSpecialization fromString(String value) {
    return SchoolSpecialization.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => SchoolSpecialization.other,
    );
  }

  static List<String> get labelsList =>
      SchoolSpecialization.values.map((e) => e.label).toList();
}