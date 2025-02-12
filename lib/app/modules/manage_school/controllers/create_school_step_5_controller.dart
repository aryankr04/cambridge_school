import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/selection_widget.dart';

class CreateSchoolStep5AcademicDetailsController extends GetxController {
  // Controllers for text fields
  final TextEditingController periodsPerDayController = TextEditingController();

  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyEndTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakEndTime = Rx<TimeOfDay?>(null);


  // Controllers for TextFormFields
  TextEditingController holidayNameController = TextEditingController();
  TextEditingController holidayDescriptionController = TextEditingController();
  TextEditingController holidayDurationController = TextEditingController();
  final Rx<DateTime?> holidayDate = Rx<DateTime?>(null);

  // Rx variables for selection
  RxString selectedHolidayType = ''.obs;

  // State for co-curricular activities
  var selectedAcademicYearStart = ''.obs;
  var selectedAcademicYearEnd =''.obs;



  void showAddHolidayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Add Holiday',style: Theme.of(context).textTheme.headlineSmall,),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextField(
                  labelText: 'Holiday Name',
                  keyboardType: TextInputType.text,
                  controller: holidayNameController,
                  validator: RequiredValidator(
                      errorText: 'Holiday Name is required')
                      .call,
                  suffixIcon: const Icon(Icons.local_offer),
                ),

                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Holiday Description',
                  keyboardType: TextInputType.text,
                  controller: holidayDescriptionController,
                  validator: RequiredValidator(
                      errorText: 'Holiday Description is required')
                      .call,
                  suffixIcon: const Icon(Icons.description),
                ),

                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Duration (Days)',
                  keyboardType: TextInputType.number,
                  controller:holidayDurationController,
                  validator: RequiredValidator(
                      errorText: 'Holiday Duration is required')
                      .call,
                  suffixIcon: const Icon(Icons.timelapse),
                ),

                const SizedBox(height: MySizes.md),
                MyDatePickerField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now(),
                  labelText: 'Holiday Date',
selectedDate:holidayDate ,                ),

                const SizedBox(height: MySizes.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MySelectionWidget(
                    itemPadding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 8),
                    spacing: MySizes.md - 4,
                    items: MyLists
                        .holidayTypeOptions, // Example holiday types: ["National", "Regional", "Religious", "Cultural"]
                    onSelectionChanged: (val) {
                      selectedHolidayType.value = val!;
                    },
                    selectionWidgetType: SelectionWidgetType.chip,
                    title: 'Holiday Type',
                  ),
                ),
                const SizedBox(height: MySizes.lg),
                Row(
                  children: [
                    Expanded(
                        child: MyButton(
                          hasShadow: false,
                          text: 'Cancel',
                          onPressed: () {},
                          borderRadius: MySizes.borderRadiusMd,
                          isOutlined: true,
                        )),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                        child: MyButton(
                          hasShadow: false,
                          text: 'Add',
                          onPressed: () {},
                          backgroundColor: MyColors.activeGreen,
                          borderRadius: MySizes.borderRadiusMd,
                        )),
                  ],
                ),
              ],
            ),
          ),

        );
      },
    );
  }

  // Dispose controllers when the controller is deleted
  // @override
  // void onClose() {
  //   academicYearController.dispose();
  //   gradingSystemController.dispose();
  //   examinationPatternController.dispose();
  //   periodsPerDayController.dispose();
  //   schoolTimingsController.dispose();
  //   holidaysCalendarController.dispose();
  //   super.onClose();
  // }
}
