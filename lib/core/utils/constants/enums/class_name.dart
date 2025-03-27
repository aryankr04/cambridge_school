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
  other, // Added 'Other'
}

extension ClassNameExtension on ClassName {
  /// Returns the display-friendly name of the class.
  String get label => _labels[this] ?? name;

  /// Converts the enum to a string value.
  String get value => name;

  /// Returns the next class in sequence, or `null` if this is the last class.
  ClassName? get nextClass => _getAdjacentClass(1);

  /// Returns the previous class in sequence, or `null` if this is the first class.
  ClassName? get previousClass => _getAdjacentClass(-1);


  /// Converts a string value to the corresponding `ClassName` enum.
  static ClassName fromString(String value) {
    String lowerValue = value.toLowerCase();
    return _labelToEnum[lowerValue] ?? ClassName.other;
  }

  /// Returns a list of all display names.
  static List<String> get displayNamesList => _labels.values.toList();

  /// Helper method to get adjacent class.
  ClassName? _getAdjacentClass(int offset) {
    int index = ClassName.values.indexOf(this) + offset;
    return (index >= 0 && index < ClassName.values.length)
        ? ClassName.values[index]
        : null;
  }

  /// Mappings
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
    ClassName.other: "Other",
  };

  static final Map<String, ClassName> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
    for (var className in ClassName.values)
      className.name.toLowerCase(): className,
  };

  /// Sorts a list of class name strings according to class sequence.
  static List<String> sortClassList(List<String> classList) {
    // Create a map of class string to its enum index.
    final Map<String, int> classIndexMap = {};
    for (final className in ClassName.values) {
      classIndexMap[className.label.toLowerCase()] = ClassName.values.indexOf(className);
      classIndexMap[className.name.toLowerCase()] = ClassName.values.indexOf(className);
    }

    classList.sort((a, b) {
      final String lowerA = a.toLowerCase();
      final String lowerB = b.toLowerCase();

      final bool aIsOther = lowerA == 'other';
      final bool bIsOther = lowerB == 'other';

      // Prioritize valid class names over "Other"
      if (aIsOther && !bIsOther) {
        return 1; // Move 'a' to the end
      } else if (!aIsOther && bIsOther) {
        return -1; // Move 'b' to the end
      }

      final int? indexA = classIndexMap[lowerA];
      final int? indexB = classIndexMap[lowerB];


      // Handle cases where the string doesn't match any class
      if (indexA == null && indexB == null) {
        return a.compareTo(b); // Sort alphabetically if both are unknown
      } else if (indexA == null) {
        return 1; // Move unknown 'a' to the end
      } else if (indexB == null) {
        return -1; // Move unknown 'b' to the end
      }

      return indexA.compareTo(indexB);
    });
    return classList;
  }
}