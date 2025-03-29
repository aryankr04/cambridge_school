enum SchoolOwnership {
  public(
    label: "Public",
    description: "Government-funded school.",
  ),
  private(
    label: "Private",
    description: "Privately-owned and funded school.",
  ),
  semiPrivate(
    label: "Semi-Private",
    description: "Partially funded by the government and private sector.",
  ),
  international(
    label: "International",
    description: "Follows an international curriculum like IB or IGCSE.",
  ),
  ngo(
    label: "NGO",
    description: "Non-Governmental Organization-funded school.",
  ),
  trust(
    label: "Trust",
    description: "Managed by a religious or community trust.",
  ),
  corporate(
    label: "Corporate",
    description: "Run by a corporate organization.",
  ),
  other(
    label: "Other",
    description: "Any other type not listed.",
  );

  const SchoolOwnership({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static SchoolOwnership fromString(String value) {
    return SchoolOwnership.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => SchoolOwnership.other,
    );
  }

  static List<String> get labelsList =>
      SchoolOwnership.values.map((e) => e.label).toList();
}