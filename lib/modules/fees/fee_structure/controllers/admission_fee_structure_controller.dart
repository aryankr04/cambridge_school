import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/fee_structure.dart';
import '../models/0_class_wise_fee_model.dart';
import '../models/0_fee_input_model.dart';
import '../models/admission_fee_structure_model.dart';

class AdmissionFeeStructureController extends GetxController {
  RxList<FeeInput> classFees = <FeeInput>[].obs;

  // Method to add a new class fee
  void addClassFee(String className) {
    classFees.add(
      FeeInput(
        name: className,
        feeController: TextEditingController(),
      ),
    );
  }

  // Method to remove a class fee at a specified index
  void removeClassFee(int index) {
    classFees.removeAt(index);
  }

  // Method to generate the AdmissionFeeStructure object
  AdmissionFeeStructure generateAdmissionFeeStructure({
    required String name,
    required String category,
    required String frequency,
    required bool isOptional,
  }) {
    List<ClassWiseFee> classWiseFeeList = classFees.map((input) {
      return input.toClassWiseFee();
    }).toList();

    return AdmissionFeeStructure(
      name: name,
      category: category,
      frequency: frequency,
      isOptional: isOptional,
      classWiseFee: classWiseFeeList,
    );
  }

  // Dispose the controllers
  @override
  void onClose() {
    for (var feeInput in classFees) {
      feeInput.dispose(); // Dispose each FeeInput's controller
    }
    super.onClose();
  }
}
