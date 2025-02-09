import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step4_controller.dart';

class StudentStep4Form extends StatelessWidget {
  const StudentStep4Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep4FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step4FormKey,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyDynamicColors.backgroundColorWhiteDarkGrey,
                    borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusMd),
                    border:
                        Border.all(width: 1, color: MyColors.borderColor)),
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Father Details',
                        style: MyTextStyles.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.md-4,
                    ),
                    const MyDottedLine(dashColor: MyColors.borderColor,),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    MyTextField(
                      labelText: 'Father\'s Name',
                      keyboardType: TextInputType.name,
                      controller: controller.fatherNameController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),
                    MyTextField(
                      labelText: 'Father\'s Mobile No.',
                      keyboardType: TextInputType.phone,
                      controller: controller.fatherMobileNoController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: ''),
                        LengthRangeValidator(
                          min: 10,
                          max: 10,
                          errorText: 'Enter valid mobile no.',
                        ),
                      ]).call,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),
                    MyTextField(
                      labelText: 'Father\'s Occupation',
                      keyboardType: TextInputType.name,
                      controller: controller.fatherOccupationController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MySizes.defaultSpace),
              Container(
                decoration: BoxDecoration(
                    color: MyDynamicColors.backgroundColorWhiteDarkGrey,
                    borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusMd),
                    border:
                        Border.all(width: 1, color: MyColors.borderColor)),
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mother Details',
                        style: MyTextStyles.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.md-4,
                    ),
                    const MyDottedLine(dashColor: MyColors.borderColor,),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    MyTextField(
                      labelText: 'Mother\'s Name',
                      keyboardType: TextInputType.name,
                      controller: controller.motherNameController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),
                    MyTextField(
                      labelText: 'Mother\'s Mobile No.',
                      keyboardType: TextInputType.phone,
                      controller: controller.motherMobileNoController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: ''),
                        LengthRangeValidator(
                          min: 10,
                          max: 10,
                          errorText: 'Enter valid mobile no.',
                        ),
                      ]).call,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),
                    MyTextField(
                      labelText: 'Mother\'s Occupation',
                      keyboardType: TextInputType.name,
                      controller: controller.motherOccupationController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MySizes.defaultSpace),
              Container(
                decoration: BoxDecoration(
                    color: MyDynamicColors.backgroundColorWhiteDarkGrey,
                    borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusMd),
                    border:
                        Border.all(width: 1, color: MyColors.borderColor)),
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Guardian Details (Optional)',
                        style: MyTextStyles.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.md-4,
                    ),
                    const MyDottedLine(dashColor: MyColors.borderColor,),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    MyTextField(
                      labelText: 'Guardian\'s Mobile No.',
                      keyboardType: TextInputType.phone,
                      controller: controller.guardianMobileNoController,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),
                    MyTextField(
                      labelText: 'Relationship to Guardian',
                      keyboardType: TextInputType.name,
                      controller: controller.relationshipToGuardianController,
                    ),
                    const SizedBox(height: MySizes.defaultSpace),

                    MyTextField(
                      labelText: 'Guardian\'s Name',
                      keyboardType: TextInputType.name,
                      controller: controller.guardianNameController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
