// MarkAttendanceScreen
import 'package:cambridge_school/app/modules/attendance/attendance_controller.dart';
import 'package:cambridge_school/app/modules/attendance/widgets/mark_attendance_user_tile.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/app_bar.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/dynamic_colors.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/utils/constants/sizes.dart';
import '../../../core/utils/helpers/helper_functions.dart';
import '../../../core/widgets/dropdown_field.dart';

class MarkAttendanceScreen extends GetView<AttendanceController> {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is only put once
    final controller = Get.put(AttendanceController());

    return Scaffold(
      appBar: const MyAppBar(title: 'Mark Attendance'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(MySizes.lg),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MyDatePickerField(
                          selectedDate: controller.selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2026),
                          labelText: 'Date',
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      Expanded(
                        child: MyDropdownField(
                          options: MyLists.userRoleOptions,
                          labelText: "User Type",
                          onSelected: (value) {
                            controller.selectedUserType.value = value!;
                            controller.fetchUsers();
                          },
                          selectedValue: controller.selectedUserType.value.obs,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MySizes.md),
                  Obx(
                        () => Visibility(
                      visible: controller.selectedUserType.value == "Student",
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MyDropdownField(
                                  options: MyLists.classOptions,
                                  labelText: "Class",
                                  onSelected: (value) {
                                    controller.selectedClass.value = value!;
                                    controller.fetchClassRoster();
                                  },
                                  selectedValue:
                                  controller.selectedClass.value.obs,
                                ),
                              ),
                              const SizedBox(
                                width: MySizes.md,
                              ),
                              Expanded(
                                child: MyDropdownField(
                                  options: MyLists.sectionOptions,
                                  labelText: "Section",
                                  onSelected: (value) {
                                    controller.selectedSection.value = value!;
                                    controller.fetchClassRoster();
                                  },
                                  selectedValue:
                                  controller.selectedSection.value.obs,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: MySizes.lg,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MyButton(
                    onPressed: () async {
                      controller.fetchUsers();
                    },
                    text: 'Search',
                  ),
                  const SizedBox(
                    height: MySizes.lg,
                  ),
                  Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _attendanceCardWithIndicator(
                          name: 'Present',
                          value: controller.presentCount.value,
                          total: controller.users.length,
                          color: MyDynamicColors.activeGreen,
                        ),
                        const SizedBox(width: MySizes.lg),
                        _attendanceCardWithIndicator(
                          name: 'Absent',
                          value: controller.absentCount.value,
                          total: controller.users.length,
                          color: MyDynamicColors.activeRed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(MySizes.md),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.borderColor, width: 0.5),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(MySizes.cardRadiusSm))),
              child: Column(
                children: [
                  _buildAttendanceHeader(),
                  MarkAllWidget(
                    onMarkAllPresent: controller.markAllPresent,
                    onMarkAllAbsent: controller.markAllAbsent,
                  ),
                  Obx(
                        () => controller.isLoading.value
                        ? _buildShimmerStudentsList()
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return AttendanceCard(
                          user: user,
                          isPresent: controller.getIsPresent(user),
                          onMarkPresent: () =>
                              controller.markPresent(user),
                          onMarkAbsent: () => controller.markAbsent(user),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attendanceCardWithIndicator({
    required String name,
    required int value,
    required int total,
    required Color color,
  }) {
    double percentage = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: MySizes.sm, horizontal: MySizes.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
        ),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 36,
              animateFromLastPercent: true,
              progressColor: color,
              backgroundColor: color.withOpacity(0.1),
              animation: true,
              animationDuration: 1000,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 6,
              percent: percentage,
              center: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: MySizes.sm),
            Text(
              '$value/$total',
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: MyColors.headlineTextColor),
            ),
            const SizedBox(height: MySizes.sm - 6),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyColors.subtitleTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md ),
      decoration: BoxDecoration(
        color: MyDynamicColors.activeBlue.withOpacity(0.1),
        border: Border(
            bottom: BorderSide(width: 0.5, color: MyDynamicColors.borderColor)),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(MySizes.cardRadiusSm),
          topLeft: Radius.circular(MySizes.cardRadiusSm),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Roll No",
                style: MyTextStyles.bodyLarge,
              ),
              SizedBox(
                width: MySizes.md,
              ),
              Text("Students", style: MyTextStyles.bodyLarge),
            ],
          ),
          Row(
            children: [
              Text("Present", style: MyTextStyles.bodyLarge),
              SizedBox(width: MySizes.md),
              Text("Absent", style: MyTextStyles.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}

class MarkAllWidget extends GetView<AttendanceController> {
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkAllAbsent;

  const MarkAllWidget({
    super.key,
    required this.onMarkAllPresent,
    required this.onMarkAllAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: MyHelperFunctions.isDarkMode(context)
            ? MyDynamicColors.darkerGreyBackgroundColor
            : MyDynamicColors.activeOrangeTint,
        border: Border(
            bottom: BorderSide(width: 0.5, color: MyDynamicColors.borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: MySizes.xl - 14),
                Text(
                  "Mark All",
                  style: MyTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onMarkAllPresent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      controller.isPresentAll.value
                          ? Icons.check_circle_outline
                          : Icons.circle_outlined,
                      size: 24,
                      color: controller.isPresentAll.value
                          ? MyDynamicColors.activeGreen
                          : Colors.black87, // Fixed color values
                    ),
                  ),
                ),
                const SizedBox(width: MySizes.md),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onMarkAllAbsent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      controller.isAbsentAll.value
                          ? Icons.check_circle_outline
                          : Icons.circle_outlined,
                      size: 24,
                      color: controller.isAbsentAll.value
                          ? MyDynamicColors.activeRed
                          : Colors.black87, // Fixed color values
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

Widget _buildShimmerStudentsList() {
  return Shimmer.fromColors(
    baseColor: MyDynamicColors.backgroundColorGreyLightGrey,
    highlightColor: MyDynamicColors.backgroundColorWhiteDarkGrey,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity, height: 35, color: Colors.white),
          ),
        );
      },
    ),
  );
}