
// Model to manage controllers for tuition fees
import 'package:flutter/material.dart';

// Model for tuition fee structure
class TuitionFeeStructure {
  String name;
  String feeType;
  String frequency;
  bool isOptional;
  List<ClassWiseTuitionFee> classWiseAmounts;

  TuitionFeeStructure({
    required this.name,
    required this.feeType,
    required this.frequency,
    required this.isOptional,
    required this.classWiseAmounts,
  });

  // Factory method to create an instance from a map
  factory TuitionFeeStructure.fromMap(Map<String, dynamic> map) {
    return TuitionFeeStructure(
      name: map['name'] ?? '',
      feeType: map['feeType'] ?? '',
      frequency: map['frequency'] ?? '',
      isOptional: map['isOptional'] ?? false,
      classWiseAmounts: (map['classWiseAmounts'] as List<dynamic>? ?? [])
          .map((item) => ClassWiseTuitionFee.fromMap(item))
          .toList(),
    );
  }

  // Convert instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'feeType': feeType,
      'frequency': frequency,
      'isOptional': isOptional,
      'classWiseAmounts': classWiseAmounts.map((e) => e.toMap()).toList(),
    };
  }
}

class ClassWiseTuitionFeeInput {
  String className;
  TextEditingController monthlyController;
  TextEditingController yearlyController;

  ClassWiseTuitionFeeInput({
    this.className = '',
    required this.monthlyController,
    required this.yearlyController,
  });
}

// Model for class-wise tuition fee data
class ClassWiseTuitionFee {
  String className;
  double? monthlyFee;
  double? yearlyFee;

  ClassWiseTuitionFee({
    required this.className,
    this.monthlyFee,
    this.yearlyFee,
  });

  // Factory method to create an instance from a map
  factory ClassWiseTuitionFee.fromMap(Map<String, dynamic> map) {
    return ClassWiseTuitionFee(
      className: map['className'] ?? '',
      monthlyFee: (map['monthlyFee'] as num?)?.toDouble(),
      yearlyFee: (map['yearlyFee'] as num?)?.toDouble(),
    );
  }

  // Convert instance to a map
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'monthlyFee': monthlyFee,
      'yearlyFee': yearlyFee,
    };
  }
}


