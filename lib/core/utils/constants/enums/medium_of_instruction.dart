enum MediumOfInstruction {
  english,
  hindi,
  bilingual,
  sanskrit,
  urdu,
  assamese,
  bengali,
  bodo,
  dogri,
  gujarati,
  kannada,
  kashmiri,
  konkani,
  maithili,
  malayalam,
  manipuri,
  marathi,
  nepali,
  odia,
  punjabi,
  sindhi,
  tamil,
  telugu,
  santali,
  meitei,
  bhili,
  gondi,
  tulu,
  khasi,
  mizo,
  ho,
  lepcha,
  garhwali,
  ladakhi,
  marwari,
  chhattisgarhi,
  kumaoni,
  magahi,
  bundeli,
  rajasthani,
  brahui,
  french,
  spanish,
  german,
  arabic,
  mandarin,
  other,
}

extension MediumOfInstructionExtension on MediumOfInstruction {
  /// Returns a user-friendly label for the medium of instruction.
  String get label => _labels[this] ?? "Other";

  /// Returns a description explaining the medium of instruction.
  String get description => "Instruction is provided in $label.";

  /// Mapping of `MediumOfInstruction` to readable labels.
  static const Map<MediumOfInstruction, String> _labels = {
    MediumOfInstruction.english: "English",
    MediumOfInstruction.hindi: "Hindi",
    MediumOfInstruction.bilingual: "Bilingual (English & Hindi)",
    MediumOfInstruction.sanskrit: "Sanskrit",
    MediumOfInstruction.urdu: "Urdu",
    MediumOfInstruction.assamese: "Assamese",
    MediumOfInstruction.bengali: "Bengali",
    MediumOfInstruction.bodo: "Bodo",
    MediumOfInstruction.dogri: "Dogri",
    MediumOfInstruction.gujarati: "Gujarati",
    MediumOfInstruction.kannada: "Kannada",
    MediumOfInstruction.kashmiri: "Kashmiri",
    MediumOfInstruction.konkani: "Konkani",
    MediumOfInstruction.maithili: "Maithili",
    MediumOfInstruction.malayalam: "Malayalam",
    MediumOfInstruction.manipuri: "Manipuri",
    MediumOfInstruction.marathi: "Marathi",
    MediumOfInstruction.nepali: "Nepali",
    MediumOfInstruction.odia: "Odia",
    MediumOfInstruction.punjabi: "Punjabi",
    MediumOfInstruction.sindhi: "Sindhi",
    MediumOfInstruction.tamil: "Tamil",
    MediumOfInstruction.telugu: "Telugu",
    MediumOfInstruction.santali: "Santali",
    MediumOfInstruction.meitei: "Meitei (Manipuri)",
    MediumOfInstruction.bhili: "Bhili",
    MediumOfInstruction.gondi: "Gondi",
    MediumOfInstruction.tulu: "Tulu",
    MediumOfInstruction.khasi: "Khasi",
    MediumOfInstruction.mizo: "Mizo",
    MediumOfInstruction.ho: "Ho",
    MediumOfInstruction.lepcha: "Lepcha",
    MediumOfInstruction.garhwali: "Garhwali",
    MediumOfInstruction.ladakhi: "Ladakhi",
    MediumOfInstruction.marwari: "Marwari",
    MediumOfInstruction.chhattisgarhi: "Chhattisgarhi",
    MediumOfInstruction.kumaoni: "Kumaoni",
    MediumOfInstruction.magahi: "Magahi",
    MediumOfInstruction.bundeli: "Bundeli",
    MediumOfInstruction.rajasthani: "Rajasthani",
    MediumOfInstruction.brahui: "Brahui",
    MediumOfInstruction.french: "French",
    MediumOfInstruction.spanish: "Spanish",
    MediumOfInstruction.german: "German",
    MediumOfInstruction.arabic: "Arabic",
    MediumOfInstruction.mandarin: "Mandarin",
    MediumOfInstruction.other: "Other",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, MediumOfInstruction> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `MediumOfInstruction` enum.
  static MediumOfInstruction fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? MediumOfInstruction.other;
  }

  /// Returns a list of all medium of instruction labels.
  static List<String> get labelsList => _labels.values.toList();
}
