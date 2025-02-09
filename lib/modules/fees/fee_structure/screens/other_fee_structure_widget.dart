import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/selection_widget.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/other_fee_structure_controller.dart';

class OtherFeeStructureWidget extends StatelessWidget {
  final OtherFeeStructureController controller =
      Get.put(OtherFeeStructureController());

  OtherFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Other Fee',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          icon: Icons.error_outline,
          color: MyColors.activeOrange,
          hasSameBorderColor: true,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: MySizes.sm,
                ),
                buildFeeTextField('Security Deposit'),
                const SizedBox(height: MySizes.md),
                buildFeeTextField('ID Card'),
                const SizedBox(height: MySizes.md),
                buildFeeTextField('Library'),
                const SizedBox(height: MySizes.lg),
                Obx(() => Column(
                      children: controller.otherFees.map((fee) {
                        final index = controller.otherFees.indexOf(fee);
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: MySizes.md),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: MyTextField(
                                  height: 42,
                                  hintText: 'Fee Name',
                                  // labelText: 'Fee Name',
                                  keyboardType: TextInputType.name,
                                  controller: controller
                                      .otherFees[index].nameController,
                                ),
                              ),
                              const SizedBox(width: MySizes.md),
                              Expanded(
                                flex: 1,
                                child: MyTextField(
                                  height: 42,
                                  hintText: 'Fee',
                                  // labelText: 'Fee',
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller:
                                      controller.otherFees[index].feeController,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.removeFeeInput(index);
                                  },
                                  icon: const Icon(Icons.delete_outline))
                            ],
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: MySizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Fee"),
                    onPressed: () {
                      controller.addFeeInput();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildFeeTextField(String? name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name ?? "Class 1",
            style: Theme.of(Get.context!)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 14),
            maxLines: 2,
          ),
        ),
        const SizedBox(
          width: MySizes.md,
        ),
        const Expanded(
            flex: 1,
            child: MyTextField(
              height: 42,
              hintText: 'Adm Fee',
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
}
