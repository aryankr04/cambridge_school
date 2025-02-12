import 'package:flutter/material.dart';

import '../../models/fee_structure.dart';
import '0_class_wise_fee_model.dart';

class FeeInput {
  String name; // Name of the class (e.g., "Grade 1")
  TextEditingController feeController; // Controller to input the fee amount

  FeeInput({
 this.name='',
    required this.feeController,
  });

  // Convert FeeInput to ClassWiseFee
  ClassWiseFee toClassWiseFee() {
    return ClassWiseFee(
      className: name,
      fee: double.tryParse(feeController.text) ?? 0.0,
    );
  }

  // Dispose the controller
  void dispose() {
    feeController.dispose();
  }
}
