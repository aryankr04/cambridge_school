enum SchoolSpecialization {
  general,          // Standard academic curriculum
  specialEducation, // Schools for children with disabilities or special needs
  vocational,       // Skill-based and technical education
  sports,          // Specialized in sports training and education
  military,        // Schools run by defense organizations
  religious,       // Faith-based education (Christian, Islamic, Hindu, etc.)
  arts,           // Focused on music, dance, drama, and fine arts
  science,        // Specialized in STEM (Science, Technology, Engineering, Math)
  agricultural,   // Focuses on farming and agricultural sciences
  business,      // Focused on entrepreneurship and commerce
  online,       // Virtual or online-only schooling
  homeSchool,   // Parents educate children at home
  openSchool,   // Flexible schooling for dropouts or non-traditional learners
  other         // Any other specialization not listed
}

extension SchoolSpecializationExtension on SchoolSpecialization {
  /// Returns a user-friendly label for the specialization.
  String get label => _labels[this] ?? "Unknown";

  /// Returns a description explaining the specialization.
  String get description => _descriptions[this] ?? "No description available.";

  /// Mapping of `SchoolSpecialization` to readable labels.
  static const Map<SchoolSpecialization, String> _labels = {
    SchoolSpecialization.general: "General",
    SchoolSpecialization.specialEducation: "Special Education",
    SchoolSpecialization.vocational: "Vocational",
    SchoolSpecialization.sports: "Sports",
    SchoolSpecialization.military: "Military",
    SchoolSpecialization.religious: "Religious",
    SchoolSpecialization.arts: "Arts",
    SchoolSpecialization.science: "Science",
    SchoolSpecialization.agricultural: "Agricultural",
    SchoolSpecialization.business: "Business",
    SchoolSpecialization.online: "Online",
    SchoolSpecialization.homeSchool: "Home School",
    SchoolSpecialization.openSchool: "Open School",
    SchoolSpecialization.other: "Other",
  };

  /// Mapping of `SchoolSpecialization` to detailed descriptions.
  static const Map<SchoolSpecialization, String> _descriptions = {
    SchoolSpecialization.general: "Standard academic curriculum.",
    SchoolSpecialization.specialEducation: "Schools for children with disabilities or special needs.",
    SchoolSpecialization.vocational: "Focuses on skill-based and technical education.",
    SchoolSpecialization.sports: "Specialized in sports training and education.",
    SchoolSpecialization.military: "Schools run by defense organizations.",
    SchoolSpecialization.religious: "Faith-based education (Christian, Islamic, Hindu, etc.).",
    SchoolSpecialization.arts: "Focused on music, dance, drama, and fine arts.",
    SchoolSpecialization.science: "Specialized in STEM (Science, Technology, Engineering, Math).",
    SchoolSpecialization.agricultural: "Focuses on farming and agricultural sciences.",
    SchoolSpecialization.business: "Focused on entrepreneurship and commerce.",
    SchoolSpecialization.online: "Virtual or online-only schooling.",
    SchoolSpecialization.homeSchool: "Parents educate children at home.",
    SchoolSpecialization.openSchool: "Flexible schooling for dropouts or non-traditional learners.",
    SchoolSpecialization.other: "Any other specialization not listed.",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, SchoolSpecialization> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `SchoolSpecialization` enum.
  static SchoolSpecialization fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? SchoolSpecialization.other;
  }

  /// Returns a list of all school specialization labels.
  static List<String> get labelsList => _labels.values.toList();
}
