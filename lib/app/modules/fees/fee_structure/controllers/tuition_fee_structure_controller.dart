import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/tuition_fee_structure_model.dart';

class TuitionFeeController extends GetxController {
  RxList<ClassWiseTuitionFeeInput> classFees = <ClassWiseTuitionFeeInput>[].obs;
  RxString selectedMode = 'Monthly'.obs; // Default mode

  // Add a new class fee entry
  void addClassFee() {
    classFees.add(
      ClassWiseTuitionFeeInput(
        monthlyController: TextEditingController(),
        yearlyController: TextEditingController(),
      ),
    );
  }

  // Remove a class fee entry by index
  void removeClassFee(int index) {
    if (index >= 0 && index < classFees.length) {
      classFees.removeAt(index);
    }
  }

  // Get fee data as a list of maps
  List<Map<String, dynamic>> getFeeData() {
    return classFees.map((fee) {
      return {
        'className': fee.className,
        'monthlyFee': double.tryParse(fee.monthlyController.text) ?? 0.0,
        'yearlyFee': double.tryParse(fee.yearlyController.text) ?? 0.0,
      };
    }).toList();
  }

  // Update the selected mode
  void updateSelectedMode(String mode) {
    selectedMode.value = mode;
  }
  // Convert the current classFees to a TuitionFeeStructure object
  TuitionFeeStructure generateTuitionFeeStructure() {
    List<ClassWiseTuitionFee> classWiseAmounts = classFees.map((fee) {
      return ClassWiseTuitionFee(
        className: fee.className,
        monthlyFee: double.tryParse(fee.monthlyController.text) ?? 0.0,
        yearlyFee: double.tryParse(fee.yearlyController.text) ?? 0.0,
      );
    }).toList();

    return TuitionFeeStructure(
      name: 'Tuition Fee', // Example name (this can be dynamic)
      feeType: 'Recurring', // Example fee type
      frequency: selectedMode.value, // Monthly or Yearly
      isOptional: false, // Example optional flag
      classWiseAmounts: classWiseAmounts,
    );
  }

}

