enum SchoolBoard {
  cbse(
    label: "CBSE",
    description: "Central Board of Secondary Education (India)",
  ),
  icse(
    label: "ICSE",
    description: "Indian Certificate of Secondary Education",
  ),
  stateBoard(
    label: "State Board",
    description: "Various state education boards in India",
  ),
  ib(
    label: "IB",
    description: "International Baccalaureate",
  ),
  igcse(
    label: "IGCSE",
    description: "International General Certificate of Secondary Education",
  ),
  cisce(
    label: "CISCE",
    description: "Council for the Indian School Certificate Examinations",
  ),
  nios(
    label: "NIOS",
    description: "National Institute of Open Schooling",
  ),
  cambridge(
    label: "Cambridge",
    description: "Cambridge Assessment International Education",
  ),
  american(
    label: "American Curriculum",
    description: "American Curriculum followed in the USA and some international schools",
  ),
  australian(
    label: "Australian Curriculum",
    description: "Australian Curriculum followed in Australia and international schools",
  ),
  canadian(
    label: "Canadian Curriculum",
    description: "Canadian Curriculum followed in Canada and international schools",
  ),
  french(
    label: "French Baccalaureate",
    description: "French Baccalaureate followed in France and French international schools",
  ),
  german(
    label: "German Abitur",
    description: "German Abitur, a qualification for university entrance in Germany",
  ),
  japanese(
    label: "Japanese Education System",
    description: "Japanese Education System followed in Japan",
  ),
  chinese(
    label: "Chinese National Curriculum",
    description: "Chinese National Curriculum followed in China",
  ),
  other(
    label: "Other",
    description: "For any other school boards not listed",
  );

  const SchoolBoard({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static SchoolBoard fromString(String value) {
    return SchoolBoard.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => SchoolBoard.other,
    );
  }

  static List<String> get labelsList =>
      SchoolBoard.values.map((e) => e.label).toList();
}