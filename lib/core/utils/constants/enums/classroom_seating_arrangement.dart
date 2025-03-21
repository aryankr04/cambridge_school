enum ClassroomSeatingArrangement {
  rows,
  theater,
  uShape,
  circular,
  cluster,
  doubleRow,
  amphitheater,
  flexible,
  herringbone,
  paired,
  boardroom,
}

extension ClassroomSeatingArrangementExtension on ClassroomSeatingArrangement {
  static const Map<ClassroomSeatingArrangement, String> _labels = {
    ClassroomSeatingArrangement.rows: "Rows",
    ClassroomSeatingArrangement.theater: "Theater Style",
    ClassroomSeatingArrangement.uShape: "U-Shape",
    ClassroomSeatingArrangement.circular: "Circular",
    ClassroomSeatingArrangement.cluster: "Cluster",
    ClassroomSeatingArrangement.doubleRow: "Double Row",
    ClassroomSeatingArrangement.amphitheater: "Amphitheater",
    ClassroomSeatingArrangement.flexible: "Flexible Seating",
    ClassroomSeatingArrangement.herringbone: "Herringbone",
    ClassroomSeatingArrangement.paired: "Paired Seating",
    ClassroomSeatingArrangement.boardroom: "Boardroom Style",
  };

  static const Map<ClassroomSeatingArrangement, String> _descriptions = {
    ClassroomSeatingArrangement.rows: "Rows of desks facing the teacher in a structured manner.",
    ClassroomSeatingArrangement.theater: "Seats arranged in rows like a theater for large lectures.",
    ClassroomSeatingArrangement.uShape: "Desks form a U-shape, allowing interaction and visibility.",
    ClassroomSeatingArrangement.circular: "Students sit in a circle to encourage discussion and collaboration.",
    ClassroomSeatingArrangement.cluster: "Small groups of desks clustered together for teamwork.",
    ClassroomSeatingArrangement.doubleRow: "Two rows of desks facing each other for engagement.",
    ClassroomSeatingArrangement.amphitheater: "Tiered seating for clear visibility of the instructor.",
    ClassroomSeatingArrangement.flexible: "Movable seating that adapts to different teaching styles.",
    ClassroomSeatingArrangement.herringbone: "Diagonal rows for better visibility and interaction.",
    ClassroomSeatingArrangement.paired: "Students seated in pairs to encourage cooperation.",
    ClassroomSeatingArrangement.boardroom: "Long table seating like a meeting room for discussions.",
  };

  /// Returns the label for the current seating arrangement.
  String get label => _labels[this] ?? "Unknown";

  /// Returns the description for the current seating arrangement.
  String get description => _descriptions[this] ?? "No description available.";

  /// Cached map for fast string-to-enum conversion.
  static final Map<String, ClassroomSeatingArrangement> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key
  };

  /// Converts a string label to the corresponding `ClassroomSeatingArrangement` enum.
  static ClassroomSeatingArrangement fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? ClassroomSeatingArrangement.rows;
  }

  /// Returns a list of all classroom seating arrangement labels.
  static List<String> get labelsList => _labels.values.toList();
}
