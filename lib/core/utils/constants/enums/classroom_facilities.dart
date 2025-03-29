
enum ClassroomFacility {
  projector(
    label: "Projector",
    description: "Equipped with a projector for presentations and lectures.",
  ),
  smartBoard(
    label: "Smart Board",
    description: "Interactive smart board for digital learning.",
  ),
  ac(
    label: "Air Conditioning",
    description: "Air conditioning for a comfortable learning environment.",
  ),
  wifi(
    label: "WiFi Connectivity",
    description: "High-speed internet access available in the classroom.",
  ),
  cctv(
    label: "CCTV Surveillance",
    description: "Classroom monitored with CCTV for security.",
  ),
  whiteBoard(
    label: "Whiteboard",
    description: "Traditional whiteboard for writing and explanations.",
  ),
  libraryAccess(
    label: "Library Access",
    description: "Easy access to library resources from the classroom.",
  ),
  laboratory(
    label: "Laboratory",
    description: "Fully equipped lab for practical experiments.",
  ),
  audioSystem(
    label: "Audio System",
    description: "Built-in audio system for clear communication.",
  ),
  ergonomicSeating(
    label: "Ergonomic Seating",
    description: "Comfortable seating to support good posture.",
  ),
  ventilation(
    label: "Proper Ventilation",
    description: "Proper air circulation for a healthy atmosphere.",
  ),
  naturalLighting(
    label: "Natural Lighting",
    description: "Well-lit classroom with natural sunlight.",
  ),
  powerBackup(
    label: "Power Backup",
    description: "Uninterrupted power supply during outages.",
  ),
  fireSafety(
    label: "Fire Safety Measures",
    description: "Fire extinguishers and safety measures installed.",
  ),
  firstAidKit(
    label: "First Aid Kit",
    description: "Basic medical assistance available in case of emergencies.",
  );

  const ClassroomFacility({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static ClassroomFacility fromString(String value) {
    return ClassroomFacility.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ClassroomFacility.whiteBoard,
    );
  }

  static List<String> get labelsList => ClassroomFacility.values.map((e) => e.label).toList();
}