import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/selection_widget.dart';
import '../../../../core/widgets/text_field.dart';

class CreateSchoolStep7AccreditationAndAchievementsController
    extends GetxController {
  // Text controllers for input fields
  final accreditationDetailsController = TextEditingController();
  final awardsReceivedController = TextEditingController();
  final rankingRecognitionController = TextEditingController();

  // TextEditingControllers
  final TextEditingController accreditingBodyController =
      TextEditingController();
  final TextEditingController certificationNumberController =
      TextEditingController();
  final TextEditingController accreditationDateController =
      TextEditingController();
  final Rx<DateTime?> accreditationDate = Rx<DateTime?>(null);
  final Rx<DateTime?> validityPeriod = Rx<DateTime?>(null);

  final TextEditingController validityPeriodController =
      TextEditingController();
  final TextEditingController standardsMetController = TextEditingController();

// For Selected Accreditation Level
  final RxString selectedAccreditationLevel = RxString('');
  final RxString selectedSection = RxString('Accreditation');

  void showScrollableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Accreditation Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextField(
                  labelText: 'Accrediting Body Name',
                  keyboardType: TextInputType.text,
                  controller: accreditingBodyController,
                  validator: RequiredValidator(
                          errorText: 'Accrediting Body Name is required')
                      .call,
                  suffixIcon: const Icon(Icons.business),
                ),

                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Certification Number/ID',
                  keyboardType: TextInputType.text,
                  controller: certificationNumberController,
                  validator: RequiredValidator(
                          errorText: 'Certification Number is required')
                      .call,
                  suffixIcon: const Icon(Icons.confirmation_number),
                ),

                const SizedBox(height: MySizes.md),
                MyDatePickerField(
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  labelText: 'Date of Accreditation',
                  selectedDate: accreditationDate,
                ),

                const SizedBox(height: MySizes.md),
                MyDatePickerField(
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  labelText: 'Validity Period (End Date)',
                  selectedDate: validityPeriod,
                ),

                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Standards Met (e.g., ISO 9001)',
                  keyboardType: TextInputType.text,
                  controller: standardsMetController,
                  validator:
                      RequiredValidator(errorText: 'Standards Met is required')
                          .call,
                  suffixIcon: const Icon(Icons.rule),
                ),

                const SizedBox(height: MySizes.md),
                // SchoolSelectionWidget(
                //   itemPadding: const EdgeInsets.symmetric(
                //       vertical: 8, horizontal: 8),
                //   spacing: SchoolSizes.md - 4,
                //   items: const ["National", "International", "Regional"], // Example levels: ["National", "International", "Regional"]
                //   onSelectionChanged: (val) {
                //     selectedAccreditationLevel.value = val!;
                //   },
                //   selectionWidgetType: SelectionWidgetType.chip,
                //   title: 'Accreditation Level',
                // ),

                const SizedBox(height: MySizes.lg),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        hasShadow: false,
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        borderRadius: MySizes.borderRadiusMd,
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                      child: MyButton(
                        hasShadow: false,
                        text: 'Add',
                        onPressed: () {
                          // Handle saving of accreditation details
                        },
                        backgroundColor: MyColors.activeGreen,
                        borderRadius: MySizes.borderRadiusMd,
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
