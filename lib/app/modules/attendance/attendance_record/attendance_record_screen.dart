import 'package:cambridge_school/core/utils/constants/enums/attendance_status.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/formatters/date_time_formatter.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/utils/constants/box_shadow.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/card_widget.dart';
import '../../../../core/widgets/label_chip.dart';
import '../../school_management/school_model.dart';
import '../../user_management/manage_user/models/roster_model.dart';
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
      backgroundColor: MyColors.lightGrey,
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
          return Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AttendanceSummaryCard(
                        controller: controller,
                      ),
                      _buildEmployeeAttendanceSummary(),
                      const MyDottedLine(
                        dashColor: MyColors.borderColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(MySizes.md),
                        child: _buildClassList(),
                      ),
                    ],
                  ),
                ),
              )
            ],
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

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(MySizes.md),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Employee Attendance',
                    style: MyTextStyle.titleLarge,
                  ),
                  const SizedBox(height: MySizes.sm),
                  if (isEmployeeAttendanceTaken)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Taken By: ${controller.employeeAttendanceSummary.value!.markedBy.map((e) => e.name).join(", ")}',
                          style: MyTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: MySizes.xs),
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
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MySizes.md, vertical: MySizes.xs),
      decoration: const BoxDecoration(
        boxShadow: MyBoxShadows.kLightShadow,
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            MyDateTimeFormatter.formatPrettyLongDate(
                controller.selectedDate.value),
            style: MyTextStyle.headlineSmall,
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          TextButton.icon(
            onPressed: () {
              _selectDate(context);
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      child: Padding(
        padding: EdgeInsets.only(
            left: 16.0,
            right: MySizes.md,
            top: MySizes.md,
            bottom: !isTaken ? MySizes.md : 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${summary.className} - ${summary.sectionName}',
                        style: MyTextStyle.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isTaken)
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
                      if (summary.markedBy.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'By: ${summary.markedBy.last.name}',
                                style: MyTextStyle.labelMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              ' ID: ${summary.markedBy.last.uid}',
                              style: MyTextStyle.labelMedium,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            const SizedBox(width: MySizes.md),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
                InkWell(
                  // Use InkWell for better touch feedback
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
                ),
              ],
            ),
            if (isTaken) ...[
              const SizedBox(height: MySizes.sm + 4),
              const Divider(
                color: MyColors.borderColor,
                height: 1,
                thickness: 0.5,
              ),
              ExpansionTile(
                minTileHeight: 24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                  side: BorderSide.none,
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide.none,
                ),
                tilePadding: const EdgeInsets.symmetric(vertical: MySizes.xs),
                initiallyExpanded: false,
                title: const Text(
                  'Details',
                  style: MyTextStyle.bodyLarge,
                ),
                children: [
                  Row(
                    children: [
                      _buildAttendanceChip(
                          AttendanceStatus.present,
                          summary.rosterAttendanceSummary.presentCount,
                          summary.rosterAttendanceSummary.presentPercentage),
                      const SizedBox(width: MySizes.md),
                      _buildAttendanceChip(
                          AttendanceStatus.absent,
                          summary.rosterAttendanceSummary.absentCount,
                          summary.rosterAttendanceSummary.absentPercentage),
                    ],
                  ),
                  const SizedBox(height: MySizes.sm),
                  Row(
                    children: [
                      _buildAttendanceChip(
                          AttendanceStatus.late,
                          summary.rosterAttendanceSummary.lateCount,
                          summary.rosterAttendanceSummary.latePercentage),
                      const SizedBox(width: MySizes.md),
                      _buildAttendanceChip(
                          AttendanceStatus.excused,
                          summary.rosterAttendanceSummary.excusedCount,
                          summary.rosterAttendanceSummary.excusedPercentage),
                    ],
                  ),
                  const SizedBox(height: MySizes.sm),
                  Row(
                    children: [
                      _buildAttendanceChip(
                          AttendanceStatus.holiday,
                          summary.rosterAttendanceSummary.holidayCount,
                          summary.rosterAttendanceSummary.holidayPercentage),
                      const SizedBox(width: MySizes.md),
                      _buildAttendanceChip(
                          AttendanceStatus.notApplicable,
                          summary.rosterAttendanceSummary.notApplicableCount,
                          summary
                              .rosterAttendanceSummary.notApplicablePercentage),
                    ],
                  ),
                  const SizedBox(height: MySizes.lg),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Marked By',
                      style: MyTextStyle.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: MySizes.sm),
                  Column(
                    children: summary.markedBy
                        .map((e) => _buildMarkedByTile(e.name, e.uid, e.time))
                        .toList(),
                  )
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMarkedByTile(String name, String id, DateTime time) {
    return Container(
      padding: const EdgeInsets.all(MySizes.sm),
      margin: const EdgeInsets.only(bottom: MySizes.md),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
        color: MyDynamicColors.lightGrey,
        border: Border.all(
          color: MyColors.borderColor,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.iconColor.withOpacity(0.1),
            radius: 13,
            child: const Icon(
              Icons.person,
              color: MyColors.iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: MySizes.sm + 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: MyTextStyle.labelLarge,
                  ),
                  Text(
                    " ($id)",
                    style: MyTextStyle.labelSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    MyDateTimeFormatter.formatPrettyDateTime(time),
                    style: MyTextStyle.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChip(
      AttendanceStatus status, int count, double percentage) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
          color: status.color.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              status.icon,
              color: status.color,
              size: 18,
            ),
            const SizedBox(width: MySizes.sm),
            Text(
              '${status.label}: $count (${percentage.toStringAsFixed(2)}%)',
              style: MyTextStyle.labelLarge.copyWith(color: status.color),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key, required this.controller});

  final AttendanceRecordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.classAttendanceSummary.value == null) {
        return const MyCard(
          margin: EdgeInsets.zero,
          hasShadow: true,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return MyCard(
        margin: const EdgeInsets.all(MySizes.md),
        hasShadow: true,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Attendance Summary',
                style: MyTextStyle.headlineSmall,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                MyDateTimeFormatter.formatPrettyLongDate(
                    controller.selectedDate.value),
                style: MyTextStyle.bodySmall,
              ),
            ),
            const SizedBox(height: MySizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.present,
                  summary: controller.classAttendanceSummary.value!,
                ),
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.absent,
                  summary: controller.classAttendanceSummary.value!,
                ),
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.late,
                  summary: controller.classAttendanceSummary.value!,
                ),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.excused,
                  summary: controller.classAttendanceSummary.value!,
                ),
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.holiday,
                  summary: controller.classAttendanceSummary.value!,
                ),
                RosterAttendanceSummaryCard(
                  status: AttendanceStatus.notApplicable,
                  summary: controller.classAttendanceSummary.value!,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class RosterAttendanceSummaryCard extends StatelessWidget {
  const RosterAttendanceSummaryCard({
    super.key,
    required this.status,
    required this.summary,
  });

  final AttendanceStatus status;
  final RosterAttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    int count = _getStatusCount(status);
    double percentage = _getStatusPercentage(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12,
      ),
      margin: const EdgeInsets.symmetric(horizontal: MySizes.xs),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 6.0,
            percent: percentage / 100,
            center: Text(
              percentage.toStringAsFixed(2),
              style:
                  MyTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            progressColor: status.color,
            backgroundColor: status.color.withOpacity(0.3),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: MySizes.xs),
          Text(
            '$count',
            style: MyTextStyle.bodyLarge,
          ),
          Text(
            status.label,
            style: MyTextStyle.bodyMedium.copyWith(height: 1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getStatusCount(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return summary.presentCount;
      case AttendanceStatus.absent:
        return summary.absentCount;
      case AttendanceStatus.holiday:
        return summary.holidayCount;
      case AttendanceStatus.late:
        return summary.lateCount;
      case AttendanceStatus.excused:
        return summary.excusedCount;
      case AttendanceStatus.notApplicable:
        return summary.notApplicableCount;
      case AttendanceStatus.working:
        return summary.workingDaysCount;
    }
  }

  double _getStatusPercentage(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return summary.presentPercentage;
      case AttendanceStatus.absent:
        return summary.absentPercentage;
      case AttendanceStatus.holiday:
        return summary.holidayPercentage;
      case AttendanceStatus.late:
        return summary.latePercentage;
      case AttendanceStatus.excused:
        return summary.excusedPercentage;
      case AttendanceStatus.notApplicable:
        return summary.notApplicablePercentage;
      case AttendanceStatus.working:
        return summary.workingDaysPercentage;
    }
  }
}
