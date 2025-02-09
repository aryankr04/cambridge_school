import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/0_fee_input_with_2_controller_model.dart';
import '../models/0_fee_item_model.dart';
import '../models/other_fee_structure_model.dart';

class OtherFeeStructureController extends GetxController {
  RxList<FeeInput2> otherFees = <FeeInput2>[].obs;

  // Method to add a fee input
  void addFeeInput() {
    otherFees.add(
      FeeInput2(
        nameController: TextEditingController(),
        feeController: TextEditingController(),
      ),
    );
  }

  // Method to remove a fee input by index
  void removeFeeInput(int index) {
    otherFees.removeAt(index);
  }

  // Method to add a uniform fee
  void showAddUniformFee() {
    otherFees.add(
      FeeInput2(
        nameController: TextEditingController(text: 'Uniform Fee'),
        feeController: TextEditingController(),
      ),
    );
  }

  // Method to convert to OtherFeeStructure for storage
  OtherFeeStructure getStructure() {
    List<FeeItem> fees = otherFees.map((input) {
      return FeeItem(
        itemName: input.nameController.text,
        price: double.tryParse(input.feeController.text) ?? 0.0,
      );
    }).toList();

    return OtherFeeStructure(fees: fees);
  }
}
