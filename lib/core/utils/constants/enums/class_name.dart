enum ClassName {
  preNursery(label: "Pre-Nursery"),
  nursery(label: "Nursery"),
  kg(label: "KG"),
  lkg(label: "LKG"),
  ukg(label: "UKG"),
  first(label: "Class 1"),
  second(label: "Class 2"),
  third(label: "Class 3"),
  fourth(label: "Class 4"),
  fifth(label: "Class 5"),
  sixth(label: "Class 6"),
  seventh(label: "Class 7"),
  eighth(label: "Class 8"),
  ninth(label: "Class 9"),
  tenth(label: "Class 10"),

  // Class 11 with Streams
  eleventhScience(label: "Class 11 Science"),
  eleventhCommerce(label: "Class 11 Commerce"),
  eleventhArts(label: "Class 11 Arts"),

  // Class 12 with Streams
  twelfthScience(label: "Class 12 Science"),
  twelfthCommerce(label: "Class 12 Commerce"),
  twelfthArts(label: "Class 12 Arts"),

  other(label: "Other");

  const ClassName({required this.label});

  final String label;

  /// Converts a string value to the corresponding `ClassName` enum.
  static ClassName fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final className in ClassName.values) {
      if (className.label.toLowerCase() == lowerValue ||
          className.name.toLowerCase() == lowerValue) {
        return className;
      }
    }
    return ClassName.other;
  }

  /// Returns a list of all display names.
  static List<String> get displayNamesList =>
      ClassName.values.map((e) => e.label).toList();

  /// Returns the next class in sequence, or `null` if this is the last class.
  ClassName? get nextClass {
    final index = ClassName.values.indexOf(this);
    return index < ClassName.values.length - 1
        ? ClassName.values[index + 1]
        : null;
  }

  /// Returns the previous class in sequence, or `null` if this is the first class.
  ClassName? get previousClass {
    final index = ClassName.values.indexOf(this);
    return index > 0 ? ClassName.values[index - 1] : null;
  }

  /// Sorts a list of class name strings according to class sequence.
  static List<String> sortClassList(List<String> classList) {
    // Create a map of class string to its enum index.
    final Map<String, int> classIndexMap = {};
    for (final className in ClassName.values) {
      classIndexMap[className.label.toLowerCase()] =
          ClassName.values.indexOf(className);
      classIndexMap[className.name.toLowerCase()] =
          ClassName.values.indexOf(className);
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

  // New helper methods
  bool get isHigherSecondary =>
      this == ClassName.eleventhScience ||
      this == ClassName.eleventhCommerce ||
      this == ClassName.eleventhArts ||
      this == ClassName.twelfthScience ||
      this == ClassName.twelfthCommerce ||
      this == ClassName.twelfthArts;

  String? get stream {
    if (this == ClassName.eleventhScience || this == ClassName.twelfthScience) {
      return "Science";
    } else if (this == ClassName.eleventhCommerce ||
        this == ClassName.twelfthCommerce) {
      return "Commerce";
    } else if (this == ClassName.eleventhArts ||
        this == ClassName.twelfthArts) {
      return "Arts";
    } else {
      return null; // No stream for other classes
    }
  }

  //Helper function to get class level. This assumes naming convention.
  String get classLevel {
    String name = this.name;
    if (name.startsWith("eleventh")) {
      return "Class 11";
    } else if (name.startsWith("twelfth")) {
      return "Class 12";
    } else {
      return label;
    }
  }
}
