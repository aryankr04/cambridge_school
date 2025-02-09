import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/selection_widget.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/late_fee_structure_controller.dart';

class LateFeeStructureWidget extends StatelessWidget {
  final LateFeeStructureController controller =
      Get.put(LateFeeStructureController());

  LateFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Late Fee',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          icon: Icons.app_registration,
          color: MyColors.activeOrange,
          hasSameBorderColor: true,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MySizes.sm),
                MySelectionWidget(
                  title: 'Based On',
                  items: const ['Percentage %', 'Amount'],
                  selectedItem: controller.basedOn.value,
                  onSelectionChanged: (selectedValue) {
                    controller.basedOn.value = selectedValue!;
                  },
                ),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyDropdownField(
                  // suffixText: 'Days',
                  height: 42,
                  hintText: 'Frequency',
                  labelText: 'Frequency',
                  options: List<String>.generate(
                      100, (index) => (index + 1).toString()),
                  onSelected: (selectedValue) {
                    controller.frequency.value = selectedValue!;
                  },
                ),
                const SizedBox(
                  height: MySizes.md,
                ),
                 MyTextField(
                  labelText: 'Late Fee',
                  keyboardType: TextInputType.number,
                  controller:    controller.lateFeeController                ,
                ),
                const SizedBox(height: MySizes.md),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
