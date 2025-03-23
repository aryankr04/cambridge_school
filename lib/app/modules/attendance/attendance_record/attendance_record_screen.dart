import 'package:cambridge_school/app/modules/class_management/class_management_controller.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/box_shadow.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/label_chip.dart';
import '../../school_management/school_model.dart';
import 'attendance_record_controller.dart';
import 'attendance_record_models.dart';
import '../mark_attendance/mark_attendance_screen.dart';

class AttendanceRecordScreen extends GetView<AttendanceRecordController> {
  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Record'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.value != null) {
          return Center(
            child: Text(
              'Error: ${controller.errorMessage.value!}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
            child: Column(
              children: [
                _buildHeader(context), // Pass context to _buildHeader

                _buildEmployeeAttendanceSummary(),
                const MyDottedLine(
                  dashColor: MyColors.borderColor,
                ),
                const SizedBox(
                  height: MySizes.md,
                ),
                Expanded(
                  child: _buildClassList(),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildEmployeeAttendanceSummary() {
    final bool isEmployeeAttendanceTaken = controller.isEmployeeAttendanceTaken;
    final Color cardColor = isEmployeeAttendanceTaken
        ? MyDynamicColors.activeOrange
        : MyDynamicColors.activeGreen;
    final String buttonText = isEmployeeAttendanceTaken ? 'Update' : 'Take';

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: MyBoxShadows.kLightShadow,
          color: MyDynamicColors.backgroundColorWhiteLightGrey),
      margin: const EdgeInsets.only(bottom: MySizes.md),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Attendance',
                    style: MyTextStyle.titleLarge
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: MySizes.sm),
                  if (isEmployeeAttendanceTaken)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Taken By: ${controller.employeeAttendanceSummary.value?.markedBy.name} (${controller.employeeAttendanceSummary.value?.markedBy.uid})',
                          style: MyTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: MySizes.xs),
                        Row(
                          children: [
                            MyLabelChip(
                              text:
                              'Presents: ${controller.employeeAttendanceSummary.value?.presents}',
                              color: MyColors.activeGreen,
                            ),
                            const SizedBox(width: MySizes.md),
                            MyLabelChip(
                              text:
                              'Absents: ${controller.employeeAttendanceSummary.value?.absents}',
                              color: MyColors.activeRed,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    const Row(
                      children: [
                        MyLabelChip(
                          text: 'Attendance Not Taken',
                          color: MyColors.activeOrange,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: MySizes.md,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => MarkAttendanceScreen(
                  initialDate: controller.selectedDate.value,
                  initialAttendanceType: 'Employee',
                ));
              },
              child: Container(
                width: Get.width * 0.2,
                padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: MyTextStyle.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.getFormattedSelectedDate(),
            style: MyTextStyle.headlineSmall
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          TextButton.icon(
            onPressed: () {
              _selectDate(context); // Use the passed context
            },
            label: const Text('Change Date'),
            icon: const Icon(
              Icons.date_range,
              color: MyColors.activeBlue,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClassList() {
    return ListView.builder(
      itemCount: controller.sections.length,
      itemBuilder: (context, index) {
        final SectionData section = controller.sections[index];
        final bool isTaken = controller.isAttendanceTakenForSection(
            section.className.label, section.sectionName);
        final ClassAttendanceSummary summary =
        controller.getClassAttendanceSummary(
            section.className.label, section.sectionName);

        return ClassAttendanceSummaryCard(
          summary: summary,
          section: section,
          isTaken: isTaken,
          onTakeAttendance: (SectionData sectionData) {
            Get.to(() => MarkAttendanceScreen(
              sectionData: sectionData,
              initialDate: controller.selectedDate.value,
              initialAttendanceType: 'Class',
            ));
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.updateSelectedDate(picked);
    }
  }
}

class ClassAttendanceSummaryCard extends StatelessWidget {
  final ClassAttendanceSummary summary;
  final Function(SectionData) onTakeAttendance;
  final bool isTaken;
  final SectionData section;

  const ClassAttendanceSummaryCard({
    super.key,
    required this.summary,
    required this.onTakeAttendance,
    required this.isTaken,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
    isTaken ? MyDynamicColors.activeOrange : MyDynamicColors.activeGreen;
    final String buttonText = isTaken ? 'Update' : 'Take';

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: MyBoxShadows.kLightShadow,
          color: MyDynamicColors.backgroundColorWhiteLightGrey),
      margin: const EdgeInsets.only(bottom: MySizes.md),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class ${summary.className} - ${summary.sectionName}',
                    style: MyTextStyle.titleLarge
                        .copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isTaken)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By: ${summary.markedBy.name} (${summary.markedBy.uid})',
                          style: MyTextStyle.labelMedium
                              .copyWith(color: MyColors.captionTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            MyLabelChip(
                              text: 'Presents: ${summary.presents}',
                              color: MyColors.activeGreen,
                            ),
                            const SizedBox(
                              width: MySizes.md,
                            ),
                            MyLabelChip(
                              text: 'Absents: ${summary.absents}',
                              color: MyColors.activeRed,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    const Column(
                      children: [
                        SizedBox(height: MySizes.xs),
                        Row(
                          children: [
                            MyLabelChip(
                              text: 'Attendance Not Taken',
                              color: MyColors.activeOrange,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onTakeAttendance(section),
              child: Container(
                width: Get.width * 0.2,
                padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: MyTextStyle.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}