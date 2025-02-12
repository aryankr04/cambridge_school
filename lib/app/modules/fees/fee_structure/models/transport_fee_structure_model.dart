
class TransportFeeStructure {
  final double baseFee; // Base fee for all users
  final List<DistanceSlab>
  distanceSlabs; // List of slabs for distance-specific fees
  final String frequency; // Frequency (e.g., monthly, quarterly, yearly)
  final bool isOptional; // Whether the fee is optional
  final String category; // Category of the fee (e.g., transport, lab, sports)

  TransportFeeStructure({
    required this.baseFee,
    required this.distanceSlabs,
    required this.frequency,
    this.isOptional = false,
    required this.category,
  });

  /// Method to calculate total fee based on distance.
  double calculateFee(double distance) {
    for (var slab in distanceSlabs) {
      if (distance <= slab.distance) {
        return baseFee + slab.fee;
      }
    }
    // If no slab matches, return just the base fee.
    return baseFee;
  }

  /// Converts TransportFee to a map.
  Map<String, dynamic> toMap() {
    return {
      'baseFee': baseFee,
      'distanceSlabs': distanceSlabs.map((slab) => slab.toMap()).toList(),
      'frequency': frequency,
      'isOptional': isOptional,
      'category': category,
    };
  }

  /// Creates a TransportFee from a map.
  factory TransportFeeStructure.fromMap(Map<String, dynamic> map) {
    return TransportFeeStructure(
      baseFee: map['baseFee'],
      distanceSlabs: (map['distanceSlabs'] as List<dynamic>)
          .map((slab) => DistanceSlab.fromMap(slab))
          .toList(),
      frequency: map['frequency'],
      isOptional: map['isOptional'] ?? false,
      category: map['category'],
    );
  }
}

class DistanceSlab {
  final double distance; // Maximum distance for this slab
  final double fee; // Additional fee for this distance slab

  DistanceSlab({required this.distance, required this.fee});

  /// Converts DistanceSlab to a map.
  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'fee': fee,
    };
  }

  /// Creates a DistanceSlab from a map.
  factory DistanceSlab.fromMap(Map<String, dynamic> map) {
    return DistanceSlab(
      distance: map['distance'],
      fee: map['fee'],
    );
  }
}