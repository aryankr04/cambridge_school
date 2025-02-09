import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/divider.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/admission_fee_structure_controller.dart';
import '../controllers/re_admission_fee_structure_controller.dart';
import '../controllers/registration_fee_structure_controller.dart';

class RegistrationFeeStructureWidget extends StatelessWidget {
  final RegistrationFeeStructureController controller =
  Get.put(RegistrationFeeStructureController());

  RegistrationFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Registration Fee',
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
                Obx(
                      () => Column(
                    children: controller.classFees.map((classFee) {
                      final index = controller.classFees.indexOf(classFee);
                      return Row(
                        children: [
                          Text(
                            'Class ${index + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 15),
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
                          const Expanded(
                            child: MyTextField(
                              height: 42,
                              hintText: 'Adm Fee',
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            onPressed: () {
                              controller.removeClassFee(index);
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: MySizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Class"),
                    onPressed: () {
                      controller.addClassFee(
                          'Class ${controller.classFees.length + 1}');
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
}
