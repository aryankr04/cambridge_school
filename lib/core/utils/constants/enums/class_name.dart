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

  /// Checks if the class falls within a specific category.
  bool get isPrePrimaryClass => _prePrimaryClasses.contains(this);
  bool get isPrimaryClass => _primaryClasses.contains(this);
  bool get isMiddleClass => _middleClasses.contains(this);
  bool get isHighSchool => _highSchoolClasses.contains(this);

  /// Converts a string value to the corresponding `ClassName` enum.
  static ClassName fromString(String value) {
    String lowerValue = value.toLowerCase();
    if (_labelToEnum.containsKey(lowerValue)) {
      return _labelToEnum[lowerValue]!; // Use the non-null assertion operator !
    } else {
      return ClassName.other;
    }
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

  static const List<ClassName> _prePrimaryClasses = [
    ClassName.preNursery,
    ClassName.nursery,
    ClassName.kg,
    ClassName.lkg,
    ClassName.ukg
  ];

  static const List<ClassName> _primaryClasses = [
    ClassName.first,
    ClassName.second,
    ClassName.third,
    ClassName.fourth,
    ClassName.fifth
  ];

  static const List<ClassName> _middleClasses = [
    ClassName.sixth,
    ClassName.seventh,
    ClassName.eighth
  ];

  static const List<ClassName> _highSchoolClasses = [
    ClassName.ninth,
    ClassName.tenth,
    ClassName.eleventh,
    ClassName.twelfth
  ];

  /// Sorts a list of class name strings according to class sequence.
  static List<String> sortClassList(List<String> classList) {
    classList.sort((a, b) {
      final ClassName classA = ClassNameExtension.fromString(a);
      final ClassName classB = ClassNameExtension.fromString(b);

      // Prioritize valid class names over "Other"
      if (classA == ClassName.other && classB != ClassName.other) {
        return 1; // Move 'a' to the end
      } else if (classA != ClassName.other && classB == ClassName.other) {
        return -1; // Move 'b' to the end
      }

      return ClassName.values.indexOf(classA).compareTo(ClassName.values.indexOf(classB));
    });
    return classList;
  }
}