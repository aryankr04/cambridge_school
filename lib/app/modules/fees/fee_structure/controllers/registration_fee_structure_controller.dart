import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/0_fee_input_model.dart';

class RegistrationFeeStructureController extends GetxController {
  RxList<FeeInput> classFees = <FeeInput>[].obs;

  void addClassFee(String className) {
    classFees.add(
      FeeInput(
        name: className,
        feeController: TextEditingController(),
      ),
    );
  }

  void removeClassFee(int index) {
    classFees.removeAt(index);
  }


}
