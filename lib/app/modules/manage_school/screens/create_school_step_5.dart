import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/helpers/date_and_time.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:cambridge_school/core/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_5_controller.dart';

class CreateSchoolStep5AcademicDetails extends StatelessWidget {
  final CreateSchoolStep5AcademicDetailsController controller;

  CreateSchoolStep5AcademicDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Expanded(
                  //   child: MyDropdownField(
                  //     options: MyLists.monthOptions,
                  //     labelText: 'Academic Year (Start)',
                  //     isValidate: true,
                  //     onSelected: (value) {
                  //       controller.selectedAcademicYearStart.value = value!;
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(width: MySizes.lg),
                  // Expanded(
                  //   child: MyDropdownField(
                  //     options: MyLists.monthOptions,
                  //     labelText: 'Academic Year (End)',
                  //     isValidate: true,
                  //     onSelected: (value) {
                  //       controller.selectedAcademicYearEnd.value = value!;
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: MySizes.lg),
              MyTextField(
                labelText: 'Number of Periods per Day',
                keyboardType: TextInputType.number,
                controller: controller.periodsPerDayController,
                validator:
                    RequiredValidator(errorText: 'This field is required').call,
                suffixIcon: const Icon(Icons.timelapse),
              ),
              const SizedBox(
                height: MySizes.lg,
              ),
        MyCard(
          border: Border.all(width: 0.5, color: Colors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "School Timings",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'Start Time',
                      selectedTime: controller.startTime,
                      onTimeChanged: (time) {
                        controller.startTime.value = time;
                        print("Start Time: $time");
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'End Time',
                      selectedTime: controller.endTime,
                      onTimeChanged: (time) {
                        controller.endTime.value = time;
                        print("End Time: $time");
                      },
                    ),
                  ),
                ],
              ),
              // End Time
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'Assembly Start Time',
                      selectedTime: controller.assemblyStartTime,
                      onTimeChanged: (time) {
                        controller.assemblyStartTime.value = time;
                        print("Assembly Start Time: $time");
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'Assembly End Time',
                      selectedTime: controller.assemblyEndTime,
                      onTimeChanged: (time) {
                        controller.assemblyEndTime.value = time;
                        print("Assembly End Time: $time");
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'Break Start Time',
                      selectedTime: controller.breakStartTime,
                      onTimeChanged: (time) {
                        controller.breakStartTime.value = time;
                        print("Break Start Time: $time");
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: MyTimePickerField(
                      labelText: 'Break End Time',
                      selectedTime: controller.breakEndTime,
                      onTimeChanged: (time) {
                        controller.breakEndTime.value = time;
                        print("Break End Time: $time");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
              const SizedBox(height: MySizes.lg),
              MyCard(
                border: Border.all(width: 0.5, color: MyColors.borderColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Holidays",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: (){controller.showAddHolidayDialog(context);},
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColors.activeBlue,
                              borderRadius: BorderRadius.circular(
                                  MySizes.borderRadiusMd+16),

                            ),
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                            child: Text(
                              "Add Holiday",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: MyColors.white),),
                          ),
                        )

                      ],
                    ),
                    const SizedBox(height: MySizes.md),
                    Wrap(
                      spacing: 16.0, // Horizontal spacing between cards
                      runSpacing:
                          12.0, // Vertical spacing between rows of cards
                      children: holidays.map((holiday) {
                        return holidayCard(
                            holiday.name,
                            holiday.date.toString(),
                            holiday.duration,
                            'National');
                      }).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget holidayCard(String name, String date, String duration, String type) {
    return IntrinsicHeight(
      child: MyCard(
        border: Border.all(
          width: 0.5,
          color: MyColors.borderColor.withOpacity(1),
        ),
        hasShadow: false,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Left indicator bar
            Container(
              width: MySizes.sm - 4,
              decoration: const BoxDecoration(
                color: MyColors.activeBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon and holiday details
                    Flexible(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon inside a card
                          MyCard(
                            border: Border.all(
                              width: 0.5,
                              color: MyColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(
                                MySizes.borderRadiusMd),
                            height: Get.width * 0.1,
                            width: Get.width * 0.1,
                            hasShadow: false,
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              Icons.beach_access,
                              size: 24,
                              color: MyColors.activeBlue,
                            ),
                          ),
                          const SizedBox(width: MySizes.md),
                          // Holiday name, date, and duration
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: Theme.of(Get.context!)
                                      .textTheme
                                      .bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Limit to a single line
                                ),
                                const SizedBox(height: MySizes.xs - 4),
                                Text(
                                  '${MyDateAndTimeFunction.formatToReadableDate(date)} ($duration)',
                                  style: Theme.of(Get.context!)
                                      .textTheme
                                      .labelMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Limit to a single line
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Holiday type chip
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MyLabelChip(
                          text: type,
                          color: MyColors.activeBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Sample list of holidays
  final List<Holiday> holidays = [
    Holiday(
      name: "Christmasmmmmmmmmmmmmmnnnnnnnn",
      description: "Celebration of the birth of Jesus Christ.",
      date: DateTime(2024, 12, 25),
      duration: "1 Day",
    ),
    Holiday(
      name: "New Year's Day",
      description: "The first day of the year in the Gregorian calendar.",
      date: DateTime(2025, 1, 1),
      duration: "1 Day",
    ),
    // Add more holidays here...
  ];
}

class Holiday {
  final String name;
  final String description;
  final DateTime date;
  final String duration;

  Holiday({
    required this.name,
    required this.description,
    required this.date,
    required this.duration,
  });
}
