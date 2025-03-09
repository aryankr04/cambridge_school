import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/detail_card_widget.dart';
import 'package:cambridge_school/core/widgets/selection_widget.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/widgets/divider.dart';
import '../controllers/tuition_fee_structure_controller.dart';

class TuitionFeeWidget extends StatelessWidget {
  final TuitionFeeController controller = Get.put(TuitionFeeController());

  TuitionFeeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Tuition Fee',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          icon: Icons.school,
          color: MyColors.activeOrange,
          hasSameBorderColor: true,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MySizes.md),
                Text(
                  "Mode of Payment",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: MySizes.md),
                Obx(
                  () => MySelectionWidget(
                    items: const ['Monthly', 'Yearly', 'Both'],
                    onSelectionChanged: (selectedMode) {
                      controller.updateSelectedMode(selectedMode!);
                    },
                    selectedItem: controller.selectedMode.value,
                    tag: 'mode',

                  ),
                ),
                const SizedBox(height: MySizes.lg),
                Text(
                  "Tuition Fee for Classes",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: MySizes.md),
                Obx(
                  () => Column(
                    children: controller.classFees.map((classFee) {
                      final index = controller.classFees.indexOf(classFee);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Class ${index + 1}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: MyDottedLine(
                                    dashLength: 4,
                                    dashGapLength: 4,
                                    lineThickness: 1,
                                    dashColor: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    controller.removeClassFee(index),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: MyColors.activeRed,
                                ),
                                label: const Text(
                                  "Remove",
                                  style:
                                      TextStyle(color: MyColors.activeRed),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () {
                              // Show text fields based on selected mode
                              final mode = controller.selectedMode.value;
                              return Row(
                                children: [
                                  if (mode == 'Monthly' || mode == 'Both')
                                    Expanded(
                                      child: MyTextField(
                                        controller: classFee.monthlyController,
                                        hintText: 'Monthly Fee',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  if (mode == 'Both') const SizedBox(width: 16),
                                  if (mode == 'Yearly' || mode == 'Both')
                                    Expanded(
                                      child: MyTextField(
                                        controller: classFee.yearlyController,
                                        hintText: 'Yearly Fee',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: MySizes.md),

                        ],
                      );
                    }).toList(),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Class"),
                    onPressed: controller.addClassFee,
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final feeData = controller.getFeeData();
                    print(feeData); // Replace with your submission logic
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
