enum ClassName {
  preNursery,
  nursery,
  kg,
  lkg,
  ukg,
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh,
  eighth,
  ninth,
  tenth,
  eleventh,
  twelfth,
}

extension ClassNameExtension on ClassName {
  /// Returns the display-friendly name of the class.
  String get label => _labels[this] ?? name;

  /// A mapping of `ClassName` values to their corresponding display names.
  static const Map<ClassName, String> _labels = {
    ClassName.preNursery: "Pre-Nursery",
    ClassName.nursery: "Nursery",
    ClassName.kg: "KG",
    ClassName.lkg: "LKG",
    ClassName.ukg: "UKG",
    ClassName.first: "Class 1",
    ClassName.second: "Class 2",
    ClassName.third: "Class 3",
    ClassName.fourth: "Class 4",
    ClassName.fifth: "Class 5",
    ClassName.sixth: "Class 6",
    ClassName.seventh: "Class 7",
    ClassName.eighth: "Class 8",
    ClassName.ninth: "Class 9",
    ClassName.tenth: "Class 10",
    ClassName.eleventh: "Class 11",
    ClassName.twelfth: "Class 12",
  };

  /// Converts the enum to a string value.
  String get value => name;

  /// Converts a string back to a `ClassName` enum.
  static ClassName fromValue(String value) =>
      ClassName.values.firstWhere((e) => e.name == value, orElse: () => ClassName.nursery);

  /// Returns a list of all display names.
  static List<String> get displayNamesList => _labels.values.toList();
}
