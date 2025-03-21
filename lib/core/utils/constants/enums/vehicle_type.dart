enum VehicleType {
  bus,
  minibus,
  van,
  car,
  autoRickshaw,
  bicycle,
  motorcycle,
  eRickshaw,
  truck,
  suv,
  tempo,
  jeep,
  other,
}

extension VehicleTypeExtension on VehicleType {
  /// Returns a user-friendly label for the vehicle type.
  String get label => _labels[this] ?? "Unknown";

  /// Returns a detailed description of the vehicle type.
  String get description => _descriptions[this] ?? "No description available.";

  /// Mapping of `VehicleType` to readable labels.
  static const Map<VehicleType, String> _labels = {
    VehicleType.bus: "Bus",
    VehicleType.minibus: "Mini Bus",
    VehicleType.van: "Van",
    VehicleType.car: "Car",
    VehicleType.autoRickshaw: "Auto Rickshaw",
    VehicleType.bicycle: "Bicycle",
    VehicleType.motorcycle: "Motorcycle",
    VehicleType.eRickshaw: "Electric Rickshaw",
    VehicleType.truck: "Truck",
    VehicleType.suv: "SUV",
    VehicleType.tempo: "Tempo",
    VehicleType.jeep: "Jeep",
    VehicleType.other: "Other",
  };

  /// Mapping of `VehicleType` to detailed descriptions.
  static const Map<VehicleType, String> _descriptions = {
    VehicleType.bus: "Large vehicle designed to carry multiple passengers, typically used for school transport.",
    VehicleType.minibus: "Smaller than a bus, commonly used for school or office transportation.",
    VehicleType.van: "Medium-sized vehicle used for student or staff transport.",
    VehicleType.car: "Personal or official car used for school-related travel.",
    VehicleType.autoRickshaw: "Three-wheeler used for short-distance student transport.",
    VehicleType.bicycle: "Eco-friendly transport option for students or staff.",
    VehicleType.motorcycle: "Two-wheeler used by staff or students for commuting.",
    VehicleType.eRickshaw: "Electric rickshaw used for student transport in urban areas.",
    VehicleType.truck: "Used for transporting school goods or equipment.",
    VehicleType.suv: "Sport utility vehicle used for official school transport.",
    VehicleType.tempo: "Three-wheeler used for group transport.",
    VehicleType.jeep: "Four-wheeler used for school-related travel in rural or tough terrains.",
    VehicleType.other: "Any other type of vehicle not listed.",
  };

  /// Reverse mapping for fast `fromString` lookup.
  static final Map<String, VehicleType> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Converts a string label to the corresponding `VehicleType` enum.
  static VehicleType fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? VehicleType.other;
  }

  /// Returns a list of all vehicle type labels.
  static List<String> get labelsList => _labels.values.toList();
}
