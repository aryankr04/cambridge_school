enum VehicleType {
  bus(
    label: "Bus",
    description: "Large vehicle designed to carry multiple passengers, typically used for school transport.",
  ),
  minibus(
    label: "Mini Bus",
    description: "Smaller than a bus, commonly used for school or office transportation.",
  ),
  van(
    label: "Van",
    description: "Medium-sized vehicle used for student or staff transport.",
  ),
  car(
    label: "Car",
    description: "Personal or official car used for school-related travel.",
  ),
  autoRickshaw(
    label: "Auto Rickshaw",
    description: "Three-wheeler used for short-distance student transport.",
  ),
  bicycle(
    label: "Bicycle",
    description: "Eco-friendly transport option for students or staff.",
  ),
  motorcycle(
    label: "Motorcycle",
    description: "Two-wheeler used by staff or students for commuting.",
  ),
  eRickshaw(
    label: "Electric Rickshaw",
    description: "Electric rickshaw used for student transport in urban areas.",
  ),
  truck(
    label: "Truck",
    description: "Used for transporting school goods or equipment.",
  ),
  suv(
    label: "SUV",
    description: "Sport utility vehicle used for official school transport.",
  ),
  tempo(
    label: "Tempo",
    description: "Three-wheeler used for group transport.",
  ),
  jeep(
    label: "Jeep",
    description: "Four-wheeler used for school-related travel in rural or tough terrains.",
  ),
  other(
    label: "Other",
    description: "Any other type of vehicle not listed.",
  );

  const VehicleType({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static VehicleType fromString(String value) {
    return VehicleType.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => VehicleType.other,
    );
  }

  static List<String> get labelsList =>
      VehicleType.values.map((e) => e.label).toList();
}