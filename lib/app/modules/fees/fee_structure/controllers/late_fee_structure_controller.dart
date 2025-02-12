import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/0_fee_input_model.dart';

class LateFeeStructureController extends GetxController {
  RxList<FeeInput> classFees = <FeeInput>[].obs;
  RxString basedOn=''.obs;
  RxString frequency=''.obs;
  TextEditingController lateFeeController=TextEditingController();

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
