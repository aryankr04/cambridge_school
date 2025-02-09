import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';
import '../models/0_fee_input_with_2_controller_model.dart';


class UniformFeeStructureController extends GetxController {
  RxList<FeeInput2> otherFees = <FeeInput2>[].obs;

  void addFeeInput() {
    otherFees.add(
      FeeInput2(
        nameController: TextEditingController(),
        feeController: TextEditingController(),
      ),
    );
  }

  void removeFeeInput(int index) {
    otherFees.removeAt(index);
  }

  void showAddUniformDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Uniform',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Container(
            width: Get.width,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  hintText: 'Item',
                  labelText: 'Item Name',

                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: MySizes.md),
                Row(
                  children: [
                    Expanded(
                      child: MyDropdownField(
                        hintText: 'Size',
                        labelText: 'Size',
                        options: ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
                      ),
                    ),
                    SizedBox(width: MySizes.md),
                    Expanded(
                      flex: 1,
                      child: MyTextField(
                        hintText: 'Fee',
                        labelText: 'Fee',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
