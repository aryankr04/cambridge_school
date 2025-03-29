enum MediumOfInstruction {
  english(label: "English"),
  hindi(label: "Hindi"),
  bilingual(label: "Bilingual (English & Hindi)"),
  sanskrit(label: "Sanskrit"),
  urdu(label: "Urdu"),
  assamese(label: "Assamese"),
  bengali(label: "Bengali"),
  bodo(label: "Bodo"),
  dogri(label: "Dogri"),
  gujarati(label: "Gujarati"),
  kannada(label: "Kannada"),
  kashmiri(label: "Kashmiri"),
  konkani(label: "Konkani"),
  maithili(label: "Maithili"),
  malayalam(label: "Malayalam"),
  manipuri(label: "Manipuri"),
  marathi(label: "Marathi"),
  nepali(label: "Nepali"),
  odia(label: "Odia"),
  punjabi(label: "Punjabi"),
  sindhi(label: "Sindhi"),
  tamil(label: "Tamil"),
  telugu(label: "Telugu"),
  santali(label: "Santali"),
  meitei(label: "Meitei (Manipuri)"),
  bhili(label: "Bhili"),
  gondi(label: "Gondi"),
  tulu(label: "Tulu"),
  khasi(label: "Khasi"),
  mizo(label: "Mizo"),
  ho(label: "Ho"),
  lepcha(label: "Lepcha"),
  garhwali(label: "Garhwali"),
  ladakhi(label: "Ladakhi"),
  marwari(label: "Marwari"),
  chhattisgarhi(label: "Chhattisgarhi"),
  kumaoni(label: "Kumaoni"),
  magahi(label: "Magahi"),
  bundeli(label: "Bundeli"),
  rajasthani(label: "Rajasthani"),
  brahui(label: "Brahui"),
  french(label: "French"),
  spanish(label: "Spanish"),
  german(label: "German"),
  arabic(label: "Arabic"),
  mandarin(label: "Mandarin"),
  other(label: "Other");

  const MediumOfInstruction({required this.label});

  final String label;

  /// Description is derived from the label
  String get description => "Instruction is provided in $label.";

  /// Converts a string label to the corresponding `MediumOfInstruction` enum.
  static MediumOfInstruction fromString(String value) {
    return MediumOfInstruction.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => MediumOfInstruction.other,
    );
  }

  /// Returns a list of all medium of instruction labels.
  static List<String> get labelsList =>
      MediumOfInstruction.values.map((e) => e.label).toList();
}