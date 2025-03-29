enum Gender {
  male("Male", "♂️"),
  female("Female", "♀️"),
  other("Other", "⚧️");

  final String label;
  final String emoji;

  const Gender(this.label, this.emoji);

  static List<String> get labels => Gender.values.map((e) => e.label).toList();

  static Gender? fromLabel(String label) {
    return Gender.values.firstWhere(
          (e) => e.label.toLowerCase() == label.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}
