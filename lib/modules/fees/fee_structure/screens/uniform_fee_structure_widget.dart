import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/uniform_fee_structure_controller.dart';

class UniformFeeStructureWidget extends StatelessWidget {
  final UniformFeeStructureController controller =
      Get.put(UniformFeeStructureController());

  UniformFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Uniform Fee',
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
                MyDetailCard(
                  hasIcon: false,
                  title: 'Shirt',
                  subtitle: 'Size: M',
                  action: Row(
                    children: [
                      Text(
                        '₹280',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),

                      IconButton(
                          onPressed: () {
                            // controller.removeFeeInput(index);
                          },
                          icon: const Icon(Icons.delete_outline)),
                      IconButton(
                          onPressed: () {
                            // controller.removeFeeInput(index);
                          },
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                ),
                Obx(() => Column(
                      children: controller.otherFees.map((fee) {
                        final index = controller.otherFees.indexOf(fee);
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: MySizes.md),
                          child: Column(
                            children: [
                              MyTextField(
                                height: 42,
                                hintText: 'Item',
                                // labelText: 'Fee Name',
                                keyboardType: TextInputType.name,
                                controller:
                                    controller.otherFees[index].nameController,
                              ),
                              const SizedBox(height: MySizes.md),
                              Row(
                                children: [
                                  // const Expanded(
                                  //   child: MyDropdownField(
                                  //     height: 42,
                                  //     hintText: 'Size',
                                  //     options: [
                                  //       'XS',
                                  //       'S',
                                  //       'M',
                                  //       'L',
                                  //       'XL',
                                  //       'XXL',
                                  //       'XXXL'
                                  //     ],
                                  //     onSelected: (value){
                                  //       controller.selectedSize.value = value!;
                                  //     },
                                  //     selectedValue: ,
                                  //
                                  //   ),
                                  // ),
                                  const SizedBox(width: MySizes.md),
                                  Expanded(
                                    flex: 1,
                                    child: MyTextField(
                                      height: 42,
                                      hintText: 'Fee',
                                      // labelText: 'Fee',
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: controller
                                          .otherFees[index].feeController,
                                    ),
                                  ),
                                ],
                              ),
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
                      controller.showAddUniformDialog();
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
