enum ClassroomSeatingArrangement {
  rows(
    label: "Rows",
    description: "Rows of desks facing the teacher in a structured manner.",
  ),
  theater(
    label: "Theater Style",
    description: "Seats arranged in rows like a theater for large lectures.",
  ),
  uShape(
    label: "U-Shape",
    description: "Desks form a U-shape, allowing interaction and visibility.",
  ),
  circular(
    label: "Circular",
    description: "Students sit in a circle to encourage discussion and collaboration.",
  ),
  cluster(
    label: "Cluster",
    description: "Small groups of desks clustered together for teamwork.",
  ),
  doubleRow(
    label: "Double Row",
    description: "Two rows of desks facing each other for engagement.",
  ),
  amphitheater(
    label: "Amphitheater",
    description: "Tiered seating for clear visibility of the instructor.",
  ),
  flexible(
    label: "Flexible Seating",
    description: "Movable seating that adapts to different teaching styles.",
  ),
  herringbone(
    label: "Herringbone",
    description: "Diagonal rows for better visibility and interaction.",
  ),
  paired(
    label: "Paired Seating",
    description: "Students seated in pairs to encourage cooperation.",
  ),
  boardroom(
    label: "Boardroom Style",
    description: "Long table seating like a meeting room for discussions.",
  );

  const ClassroomSeatingArrangement({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static ClassroomSeatingArrangement fromString(String value) {
    return ClassroomSeatingArrangement.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ClassroomSeatingArrangement.rows, // Or another suitable default
    );
  }

  static List<String> get labelsList =>
      ClassroomSeatingArrangement.values.map((e) => e.label).toList();
}