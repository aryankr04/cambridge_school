import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/utils/formatters/date_time_formatter.dart';
import 'package:cambridge_school/core/widgets/app_bar.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:cambridge_school/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/card_widget.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../school_management/school_model.dart';
import 'mark_attendance_controller.dart';
import 'mark_attendance_user_tile.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final SectionData? sectionData;
  final DateTime? initialDate;
  final String? initialAttendanceType;

  const MarkAttendanceScreen({
    super.key,
    this.sectionData,
    this.initialDate,
    this.initialAttendanceType,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final MarkAttendanceController controller =
      Get.put(MarkAttendanceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAttendanceDetails();
    });
  }

  void _initializeAttendanceDetails() {
    if (widget.sectionData != null) {
      controller.selectedClass.value = widget.sectionData!.className.label;
      controller.selectedSection.value = widget.sectionData!.sectionName;
    }
    if (widget.initialDate != null) {
      controller.selectedDate.value = widget.initialDate!;
    }
    if (widget.initialAttendanceType != null) {
      controller.attendanceType.value = widget.initialAttendanceType!;
    }

    if (widget.sectionData != null ||
        widget.initialDate != null ||
        widget.initialAttendanceType != null ||
        controller.shouldFetchRosterOnInit.value) {
      controller.loadRosterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Mark Attendance'),
      backgroundColor: MyColors.lightGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AttendanceDetailsCard(
                sectionData: widget.sectionData, controller: controller),
            const SizedBox(height: MySizes.md),
            AttendanceSummaryCard(controller: controller),
            const SizedBox(height: MySizes.lg),
            MarkAllAttendanceWidget(controller: controller),
            const SizedBox(height: MySizes.lg),
            AttendanceList(controller: controller),
            const SizedBox(height: MySizes.lg),
            Obx(
              () => MyButton(
                text: 'Submit',
                onPressed: controller.saveAttendanceData,
                isLoading: controller.isUpdatingAttendance.value,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AttendanceDetailsCard extends StatelessWidget {
  const AttendanceDetailsCard({
    super.key,
    this.sectionData,
    required this.controller,
  });

  final SectionData? sectionData;
  final MarkAttendanceController controller;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionData != null
                      ? "${controller.selectedClass}-${controller.selectedSection}"
                      : 'Attendance Details',
                  style: MyTextStyle.headlineSmall,
                ),
                const SizedBox(width: MySizes.sm),
                Text(
                  MyDateTimeFormatter.formatPrettyLongDate(
                      controller.selectedDate.value),
                  style: MyTextStyle.bodyMedium
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => _showAttendanceDetailsDialog(context),
            child: const Text('Change'),
          )
        ],
      ),
    );
  }

  void _showAttendanceDetailsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attendance Details',
          style: MyTextStyle.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MyDatePickerField(
                        selectedDate: controller.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        labelText: 'Date',
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                      child: MyDropdownField(
                        options: const ['Class', 'Employee'],
                        labelText: "Attendance Type",
                        onSelected: (value) {
                          controller.attendanceType.value = value!;
                          controller.isClassAttendance.value = value == 'Class';
                        },
                        selectedValue: controller.attendanceType.value.obs,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isClassAttendance.value,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: MyDropdownField(
                                options: ClassName.displayNamesList,
                                labelText: "Class",
                                onSelected: (value) {
                                  controller.selectedClass.value = value!;
                                },
                                selectedValue:
                                    controller.selectedClass.value.obs,
                              ),
                            ),
                            const SizedBox(width: MySizes.md),
                            Expanded(
                              child: MyDropdownField(
                                options: List.generate(26,
                                    (index) => String.fromCharCode(65 + index)),
                                labelText: "Section",
                                onSelected: (value) {
                                  controller.selectedSection.value = value!;
                                },
                                selectedValue:
                                    controller.selectedSection.value.obs,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: Get.back,
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.loadRosterData();
                    Get.back();
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceList extends StatelessWidget {
  const AttendanceList({
    super.key,
    required this.controller,
  });

  final MarkAttendanceController controller;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AttendanceListHeader(controller: controller),
          Obx(
            () => controller.isLoading.value
                ? _buildShimmerStudentsList()
                : _buildRosterList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerStudentsList();
      } else if (controller.userRoster.value == null) {
        return const Center(
            child: MyEmptyStateWidget(
                type: EmptyStateType.noData,
                message: 'No user data available.'));
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.userRoster.value!.userList.length,
          itemBuilder: (context, index) {
            Rx<AttendanceStatus> attendanceStatus = Rx<AttendanceStatus>(
                controller.getAttendanceStatus(
                    controller.userRoster.value!.userList[index]));
            return Column(
              children: [
                AttendanceCard(
                  user: controller.userRoster.value!.userList[index],
                  attendanceStatus: attendanceStatus,
                  onAttendanceChanged: (AttendanceStatus newStatus) {
                    controller.updateAttendanceStatus(
                        controller.userRoster.value!.userList[index],
                        newStatus);
                    attendanceStatus.value = newStatus;
                    controller.isAllMarkAttendance();
                  },
                ),
                if (index != controller.userRoster.value!.userList.length - 1)
                  const Divider(
                    color: MyColors.borderColor,
                    thickness: 0.5,
                    height: 1,
                  ),
              ],
            );
          },
        );
      }
    });
  }

  Widget _buildShimmerStudentsList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.sm + 4),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        width: double.infinity,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Container(
                        height: 8,
                        width: Get.width * 0.4,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AttendanceListHeader extends StatelessWidget {
  const AttendanceListHeader({
    super.key,
    required this.controller,
  });

  final MarkAttendanceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md - 4, horizontal: MySizes.md),
      decoration: BoxDecoration(
        color: MyDynamicColors.activeBlue,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(MySizes.cardRadiusSm),
          topLeft: Radius.circular(MySizes.cardRadiusSm),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                controller.isClassAttendance.value ? "Roll No" : "S.No",
                style: MyTextStyle.bodyLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(width: MySizes.md),
              Text(controller.isClassAttendance.value ? "Student" : "Employee",
                  style: MyTextStyle.bodyLarge.copyWith(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Text("Present",
                  style: MyTextStyle.bodyLarge.copyWith(color: Colors.white)),
              const SizedBox(width: MySizes.md),
              Text("Absent",
                  style: MyTextStyle.bodyLarge.copyWith(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class MarkAllAttendanceWidget extends StatelessWidget {
  const MarkAllAttendanceWidget({super.key, required this.controller});

  final MarkAttendanceController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => MyCard(
          padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mark All",
                style: MyTextStyle.titleLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildMarkAllIcon(AttendanceStatus.present),
                  _buildMarkAllIcon(AttendanceStatus.absent),
                  _buildMarkAllIcon(AttendanceStatus.late),
                  _buildMarkAllIcon(AttendanceStatus.excused),
                  _buildMarkAllIcon(AttendanceStatus.holiday),
                  _buildMarkAllIcon(AttendanceStatus.notApplicable),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildMarkAllIcon(AttendanceStatus status) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.selectedAllStatus.value = status;
        controller.markAllAttendance();
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 5, vertical: MySizes.sm + 4),
        child: Row(
          children: [
            Text(status.code,
                style: MyTextStyle.bodyLarge.copyWith(
                    fontWeight: controller.selectedAllStatus.value == status
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: (controller.selectedAllStatus.value == status &&
                            status != AttendanceStatus.notApplicable)
                        ? status.color
                        : MyColors.iconColor)),
            const SizedBox(
              width: MySizes.xs,
            ),
            Icon(
              controller.selectedAllStatus.value == status
                  ? Icons.check_circle_outline
                  : Icons.circle_outlined,
              size: 20,
              color: (controller.selectedAllStatus.value == status &&
                      status != AttendanceStatus.notApplicable)
                  ? status.color
                  : MyColors.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key, required this.controller});

  final MarkAttendanceController controller;

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
        margin: EdgeInsets.zero,
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
