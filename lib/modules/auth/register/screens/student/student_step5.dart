import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step5_controller.dart';

class StudentStep5Form extends StatelessWidget {
  const StudentStep5Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep5FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step5FormKey,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: MyDropdownField(
                        options: MyLists.heightFeetOptions,
                        labelText: 'Height (Feet)',
                        isValidate: true,
                        onSelected: (value) {
                          controller.selectedHeightFt.value = value!;
                        },
                        selectedValue: controller.selectedHeightFt
                    )
                  ),
                  const SizedBox(width: MySizes.defaultSpace),
                  Expanded(
                    child: MyDropdownField(
                        options: MyLists.heightInchOptions,
                        labelText: 'Height (Inches)',
                        isValidate: true,
                        onSelected: (value) {
                          controller.selectedHeightInch.value = value!;
                        },
                        selectedValue: controller.selectedHeightInch
                    )
                  ),
                ],
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                labelText: 'Weight (in Kgs)',
                keyboardType: TextInputType.number,
                controller: controller.weightController,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.bloodGroupOptions,
                  labelText: 'Blood Group',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedBloodGroup.value = value!;
                  },
                  selectedValue: controller.selectedBloodGroup
              ),              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.visionConditionOptions,
                  labelText: 'Vision Condition',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedVisionCondition.value = value!;
                  },
                  selectedValue: controller.selectedVisionCondition
              ),              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.medicalConditionOptions,
                  labelText: 'Any Medical Condition',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedMedicalCondition.value = value!;
                  },
                  selectedValue: controller.selectedMedicalCondition
              ),
              SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.medicalConditionOptions,
                  labelText: 'Any Physical Disability',
                  isValidate: true,
                  onSelected: (value) {
                    controller.isPhysicalDisability.value = value!;
                  },
                  selectedValue: controller.isPhysicalDisability
              )
            ],
          ),
        ),
      ),
    );
  }
}