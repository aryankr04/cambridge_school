import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/divider.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/transport_fee_structure_controller.dart';

class TransportFeeStructureWidget extends StatelessWidget {
  final TransportFeeController controller = Get.put(TransportFeeController());

  TransportFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Transport Fee',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          icon: Icons.directions_bus,
          color: MyColors.activeOrange,
          hasSameBorderColor: true,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MySizes.sm),
                MyTextField(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  textAlign: TextAlign.center,
                  hintText: 'Amount',
                  labelText: "Base/Fixed Fee",
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.baseFee.text = value,
                ),
                const SizedBox(height: MySizes.lg + 8),
                Row(
                  children: [
                    Text(
                      "Distance Slabs",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyDottedLine(
                          dashLength: 4,
                          dashGapLength: 4,
                          lineThickness: 1,
                          dashColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.lg),
                Obx(() => Column(
                      children:
                          controller.distanceSlabs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final slab = entry.value;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: MyDropdownField(
                                    height: 42,
                                    // labelText: 'Distance Up to (in km)',
                                    hintText: 'Distance',
                                    options: List.generate(
                                        100, (index) => (index + 1).toString()),
                                    onSelected: (value) =>
                                        controller.updateDistance(index, value!),
                                    selectedValue: controller.distanceSlabs[index].name.obs,
                                  ),
                                ),
                                const SizedBox(width: MySizes.md),
                                Expanded(
                                  child: MyTextField(
                                    height: 42,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    textAlign: TextAlign.center,
                                    hintText: 'Fee',
                                    // labelText: "Fee",
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                        controller.updateFee(index, value),
                                    initialValue: slab.feeController.text,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      controller.removeDistanceSlab(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: MySizes.lg),
                          ],
                        );
                      }).toList(),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Distance Slab"),
                    onPressed: controller.addDistanceSlab,
                  ),
                ),
                const SizedBox(height: MySizes.md),
                ElevatedButton(
                  onPressed: controller.generateTransportFeeStructure,
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
