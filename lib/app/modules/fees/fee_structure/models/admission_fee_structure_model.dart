import '../../models/fee_structure.dart';
import '0_class_wise_fee_model.dart';

class AdmissionFeeStructure {
  String name; // Name of the fee
  String category; // Category of the fee (e.g., admission, library, sports)
  String frequency; // Frequency (e.g., one-time, annual)
  bool isOptional; // Whether the fee is optional
  List<ClassWiseFee> classWiseFee; // List of class-wise amounts

  AdmissionFeeStructure({
    required this.name,
    required this.category,
    required this.frequency,
    required this.isOptional,
    required this.classWiseFee,
  });

  // Factory constructor to create an AdmissionFeeStructure from a map
  factory AdmissionFeeStructure.fromMap(Map<String, dynamic> map) {
    return AdmissionFeeStructure(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      frequency: map['frequency'] ?? '',
      isOptional: map['isOptional'] ?? false,
      classWiseFee: (map['classWiseFee'] as List<dynamic>? ?? [])
          .map((item) => ClassWiseFee.fromMap(item))
          .toList(),
    );
  }

  // Convert AdmissionFeeStructure to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'frequency': frequency,
      'isOptional': isOptional,
      'classWiseFee': classWiseFee.map((e) => e.toMap()).toList(),
    };
  }

  // Method to add a new class fee
  void addClassWiseAmount(ClassWiseFee classFee) {
    classWiseFee.add(classFee);
  }
}
