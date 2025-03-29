enum MaritalStatus {
  single("Single", "💙"),
  married("Married", "💍"),
  divorced("Divorced", "💔"),
  widowed("Widowed", "🖤"),
  separated("Separated", "🔗"),
  engaged("Engaged", "💑"),
  inRelationship("In a Relationship", "❤️"),
  complicated("It's Complicated", "🤯"),
  cohabiting("Cohabiting", "🏠"),
  annulled("Annulled", "🚫");

  final String label;
  final String emoji;

  const MaritalStatus(this.label, this.emoji);

  // Get all labels
  static List<String> get labels => MaritalStatus.values.map((e) => e.label).toList();

  // Get MaritalStatus by label (case-insensitive)
  static MaritalStatus? fromLabel(String label) {
    return MaritalStatus.values.firstWhere(
          (e) => e.label.toLowerCase() == label.toLowerCase(),
      orElse: () => MaritalStatus.single, // Returns null if not found
    );
  }
}
