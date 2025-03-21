import 'package:collection/collection.dart';

enum ClassroomFacility {
  projector,
  smartBoard,
  ac,
  wifi,
  cctv,
  whiteBoard,
  libraryAccess,
  laboratory,
  audioSystem,
  ergonomicSeating,
  ventilation,
  naturalLighting,
  powerBackup,
  fireSafety,
  firstAidKit,
}

extension ClassroomFacilityExtension on ClassroomFacility {
  static const Map<ClassroomFacility, String> _labels = {
    ClassroomFacility.projector: "Projector",
    ClassroomFacility.smartBoard: "Smart Board",
    ClassroomFacility.ac: "Air Conditioning",
    ClassroomFacility.wifi: "WiFi Connectivity",
    ClassroomFacility.cctv: "CCTV Surveillance",
    ClassroomFacility.whiteBoard: "Whiteboard",
    ClassroomFacility.libraryAccess: "Library Access",
    ClassroomFacility.laboratory: "Laboratory",
    ClassroomFacility.audioSystem: "Audio System",
    ClassroomFacility.ergonomicSeating: "Ergonomic Seating",
    ClassroomFacility.ventilation: "Proper Ventilation",
    ClassroomFacility.naturalLighting: "Natural Lighting",
    ClassroomFacility.powerBackup: "Power Backup",
    ClassroomFacility.fireSafety: "Fire Safety Measures",
    ClassroomFacility.firstAidKit: "First Aid Kit",
  };

  static const Map<ClassroomFacility, String> _descriptions = {
    ClassroomFacility.projector: "Equipped with a projector for presentations and lectures.",
    ClassroomFacility.smartBoard: "Interactive smart board for digital learning.",
    ClassroomFacility.ac: "Air conditioning for a comfortable learning environment.",
    ClassroomFacility.wifi: "High-speed internet access available in the classroom.",
    ClassroomFacility.cctv: "Classroom monitored with CCTV for security.",
    ClassroomFacility.whiteBoard: "Traditional whiteboard for writing and explanations.",
    ClassroomFacility.libraryAccess: "Easy access to library resources from the classroom.",
    ClassroomFacility.laboratory: "Fully equipped lab for practical experiments.",
    ClassroomFacility.audioSystem: "Built-in audio system for clear communication.",
    ClassroomFacility.ergonomicSeating: "Comfortable seating to support good posture.",
    ClassroomFacility.ventilation: "Proper air circulation for a healthy atmosphere.",
    ClassroomFacility.naturalLighting: "Well-lit classroom with natural sunlight.",
    ClassroomFacility.powerBackup: "Uninterrupted power supply during outages.",
    ClassroomFacility.fireSafety: "Fire extinguishers and safety measures installed.",
    ClassroomFacility.firstAidKit: "Basic medical assistance available in case of emergencies.",
  };

  /// Returns the label for the facility.
  String get label => _labels[this] ?? "Unknown Facility";

  /// Returns the description for the facility.
  String get description => _descriptions[this] ?? "No description available.";

  /// Cached map for fast string-to-enum conversion.
  static final Map<String, ClassroomFacility> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key
  };

  /// Converts a string label to the corresponding `ClassroomFacility` enum.
  static ClassroomFacility? fromString(String value) {
    return _labelToEnum[value.toLowerCase()];
  }

  /// Returns a list of all facility labels.
  static List<String> get labelsList => _labels.values.toList();
}
