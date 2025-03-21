enum SchoolOwnership {
  public,        // Government-funded school
  private,       // Privately-owned and funded school
  semiPrivate,   // Partially funded by the government and private sector
  international, // Follows an international curriculum like IB or IGCSE
  ngo,           // Non-Governmental Organization-funded school
  trust,         // Managed by a religious or community trust
  corporate,     // Run by a corporate organization
  other          // Any other type not listed
}

extension SchoolOwnershipExtension on SchoolOwnership {
  /// Returns a user-friendly label for the school ownership type.
  String get label => _labels[this] ?? "Unknown";

  /// Returns a description explaining the school ownership type.
  String get description => _descriptions[this] ?? "No description available.";

  /// Mapping of `SchoolOwnership` to readable labels.
  static const Map<SchoolOwnership, String> _labels = {
    SchoolOwnership.public: "Public",
    SchoolOwnership.private: "Private",
    SchoolOwnership.semiPrivate: "Semi-Private",
    SchoolOwnership.international: "International",
    SchoolOwnership.ngo: "NGO",
    SchoolOwnership.trust: "Trust",
    SchoolOwnership.corporate: "Corporate",
    SchoolOwnership.other: "Other",
  };

  /// Mapping of `SchoolOwnership` to detailed descriptions.
  static const Map<SchoolOwnership, String> _descriptions = {
    SchoolOwnership.public: "Government-funded school.",
    SchoolOwnership.private: "Privately-owned and funded school.",
    SchoolOwnership.semiPrivate: "Partially funded by the government and private sector.",
    SchoolOwnership.international: "Follows an international curriculum like IB or IGCSE.",
    SchoolOwnership.ngo: "Non-Governmental Organization-funded school.",
    SchoolOwnership.trust: "Managed by a religious or community trust.",
    SchoolOwnership.corporate: "Run by a corporate organization.",
    SchoolOwnership.other: "Any other type not listed.",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, SchoolOwnership> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `SchoolOwnership` enum.
  static SchoolOwnership fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? SchoolOwnership.other;
  }

  /// Returns a list of all school ownership labels.
  static List<String> get labelsList => _labels.values.toList();
}
