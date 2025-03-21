enum SchoolBoard {
  cbse,       // Central Board of Secondary Education (India)
  icse,       // Indian Certificate of Secondary Education
  stateBoard, // Various state education boards in India
  ib,         // International Baccalaureate
  igcse,      // International General Certificate of Secondary Education
  cisce,      // Council for the Indian School Certificate Examinations
  nios,       // National Institute of Open Schooling
  cambridge,  // Cambridge Assessment International Education
  american,   // American Curriculum
  australian, // Australian Curriculum
  canadian,   // Canadian Curriculum
  french,     // French Baccalaureate
  german,     // German Abitur
  japanese,   // Japanese Education System
  chinese,    // Chinese National Curriculum
  other       // For any other school boards not listed
}

extension SchoolBoardExtension on SchoolBoard {
  /// Returns a user-friendly label for the school board.
  String get label => _labels[this] ?? "Other";

  /// Returns a description explaining the school board.
  String get description => _descriptions[this] ?? "For any other school boards not listed.";

  /// Mapping of `SchoolBoard` to readable labels.
  static const Map<SchoolBoard, String> _labels = {
    SchoolBoard.cbse: "CBSE",
    SchoolBoard.icse: "ICSE",
    SchoolBoard.stateBoard: "State Board",
    SchoolBoard.ib: "IB",
    SchoolBoard.igcse: "IGCSE",
    SchoolBoard.cisce: "CISCE",
    SchoolBoard.nios: "NIOS",
    SchoolBoard.cambridge: "Cambridge",
    SchoolBoard.american: "American Curriculum",
    SchoolBoard.australian: "Australian Curriculum",
    SchoolBoard.canadian: "Canadian Curriculum",
    SchoolBoard.french: "French Baccalaureate",
    SchoolBoard.german: "German Abitur",
    SchoolBoard.japanese: "Japanese Education System",
    SchoolBoard.chinese: "Chinese National Curriculum",
    SchoolBoard.other: "Other",
  };

  /// Mapping of `SchoolBoard` to detailed descriptions.
  static const Map<SchoolBoard, String> _descriptions = {
    SchoolBoard.cbse: "Central Board of Secondary Education (India)",
    SchoolBoard.icse: "Indian Certificate of Secondary Education",
    SchoolBoard.stateBoard: "Various state education boards in India",
    SchoolBoard.ib: "International Baccalaureate",
    SchoolBoard.igcse: "International General Certificate of Secondary Education",
    SchoolBoard.cisce: "Council for the Indian School Certificate Examinations",
    SchoolBoard.nios: "National Institute of Open Schooling",
    SchoolBoard.cambridge: "Cambridge Assessment International Education",
    SchoolBoard.american: "American Curriculum followed in the USA and some international schools",
    SchoolBoard.australian: "Australian Curriculum followed in Australia and international schools",
    SchoolBoard.canadian: "Canadian Curriculum followed in Canada and international schools",
    SchoolBoard.french: "French Baccalaureate followed in France and French international schools",
    SchoolBoard.german: "German Abitur, a qualification for university entrance in Germany",
    SchoolBoard.japanese: "Japanese Education System followed in Japan",
    SchoolBoard.chinese: "Chinese National Curriculum followed in China",
    SchoolBoard.other: "For any other school boards not listed",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, SchoolBoard> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `SchoolBoard` enum.
  static SchoolBoard fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? SchoolBoard.other;
  }

  /// Returns a list of all school board labels.
  static List<String> get labelsList => _labels.values.toList();
}
