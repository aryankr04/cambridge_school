import '0_class_wise_fee_model.dart';

class RegistrationFeeStructure {
  String
  category; // Category of the fee (e.g., re-admission, late re-admission)
  String frequency; // Frequency (e.g., one-time, annual)
  bool isOptional; // Whether the fee is optional
  List<ClassWiseFee> classWiseFee; // List of class-wise amounts

  RegistrationFeeStructure({
    required this.category,
    required this.frequency,
    required this.isOptional,
    required this.classWiseFee,
  });

  // Factory constructor to create a ReAdmissionFeeStructure from a map
  factory RegistrationFeeStructure.fromMap(Map<String, dynamic> map) {
    return RegistrationFeeStructure(
      category: map['category'] ?? '',
      frequency: map['frequency'] ?? '',
      isOptional: map['isOptional'] ?? false,
      classWiseFee: (map['classWiseFee'] as List<dynamic>? ?? [])
          .map((item) => ClassWiseFee.fromMap(item))
          .toList(),
    );
  }

  // Convert ReAdmissionFeeStructure to a map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'frequency': frequency,
      'isOptional': isOptional,
      'classWiseFee': classWiseFee.map((e) => e.toMap()).toList(),
    };
  }
}
