import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/app_bar.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/gradients.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../manage_school/models/school_model.dart';
import 'mark_attendance_controller.dart';
import 'mark_attendance_user_tile.dart';

class MarkAttendanceScreen extends GetView<MarkAttendanceController> {
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
  Widget build(BuildContext context) {
    final MarkAttendanceController attendanceController = Get.put(MarkAttendanceController());

    // Initialize the attendance controller with provided parameters
    _initializeController(attendanceController);

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Mark Attendance',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAttendanceDetailsCard(context, attendanceController),
            const SizedBox(height: MySizes.lg),
            _buildAttendanceSummary(attendanceController),
            const SizedBox(height: MySizes.lg),
            _buildAttendanceList(attendanceController),
            const SizedBox(height: MySizes.lg),
           Obx(()=> MyButton(
             text: 'Submit',
             onPressed: () => attendanceController.updateAttendanceOnFirestore(),
             isLoading: attendanceController.isUpdatingAttendance.value,
           ),)
          ],
        ),
      ),
    );
  }

  void _initializeController(MarkAttendanceController controller) {
    // Set initial values from optional parameters
    controller.setShouldFetchUsersOnInit(
        shouldFetch: sectionData != null || initialDate != null || initialAttendanceType != null);

    if (sectionData != null) {
      controller.selectedClass.value = sectionData!.className;
      controller.selectedSection.value = sectionData!.sectionName;
    }
    if (initialDate != null) {
      controller.selectedDate.value = initialDate!;
    }
    if (initialAttendanceType != null) {
      controller.selectedAttendanceFor.value = initialAttendanceType!;
    }

    // Only fetch if initial values are set or `shouldFetchUsersOnInit` is true
    if (controller.shouldFetchUsersOnInit.value) {
      controller.fetchUsers();
    }
  }

  Widget _buildAttendanceDetailsCard(BuildContext context, MarkAttendanceController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: MyBoxShadows.kLightShadow,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionData != null
                    ? "Class ${sectionData!.className}-${sectionData!.sectionName}"
                    : 'Attendance Details',
                style: MyTextStyles.headlineSmall,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    color: MyColors.iconColor,
                    size: 18,
                  ),
                  const SizedBox(width: MySizes.sm),
                  Text(
                    controller.getFormattedSelectedDate(),
                    style: MyTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          FilledButton(
            onPressed: () => _showAttendanceDetailsDialog(context, controller),
            child: const Text('Change'),
          )
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary(MarkAttendanceController controller) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _attendanceCardWithIndicator(
            name: 'Present',
            value: controller.presentCount.value,
            total: controller.userList.length,
            color: MyDynamicColors.activeGreen,
          ),
          const SizedBox(width: MySizes.lg),
          _attendanceCardWithIndicator(
            name: 'Absent',
            value: controller.absentCount.value,
            total: controller.userList.length,
            color: MyDynamicColors.activeRed,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(MarkAttendanceController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.borderColor, width: 0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(MySizes.cardRadiusSm),
        ),
        boxShadow: MyBoxShadows.kLightShadow,
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildAttendanceHeader(),
          _buildMarkAllWidget(controller),
          const SizedBox(height: MySizes.sm),
          Obx(
                () => controller.isLoading.value
                ? _buildShimmerStudentsList()
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.userList.length,
              itemBuilder: (context, index) {
                final user = controller.userList[index];
                return AttendanceCard(
                  user: user,
                  isPresent: controller.isUserPresent(user),
                  onMarkPresent: () =>
                      controller.markUserPresent(user),
                  onMarkAbsent: () =>
                      controller.markUserAbsent(user),
                );
              },
            ),
          ),
          const SizedBox(height: MySizes.sm)
        ],
      ),
    );
  }

  Widget _buildMarkAllWidget(MarkAttendanceController controller) {
    return MarkAllWidget(
      onMarkAllPresent: controller.markAllUsersPresent,
      onMarkAllAbsent: controller.markAllUsersAbsent,
    );
  }

  void _showAttendanceDetailsDialog(
      BuildContext context, MarkAttendanceController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attendance Details',
          style: MyTextStyles.headlineSmall,
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
                        lastDate: DateTime(2026),
                        labelText: 'Date',
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                      child: MyDropdownField(
                        options: const [
                          'Class',
                          'Employee'
                        ], // Use your actual list
                        labelText: "Attendance Type",
                        onSelected: (value) {
                          controller.selectedAttendanceFor.value = value!;
                          controller.fetchUsers();
                        },
                        selectedValue:
                        controller.selectedAttendanceFor.value.obs,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.lg),
                Obx(
                      () => Visibility(
                    visible: controller.selectedAttendanceFor.value == "Class",
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: MyDropdownField(
                                options: MyLists.classOptions,
                                // Use your actual options list
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
                                options: MyLists.sectionOptions,
                                // Use your actual options
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
                        const SizedBox(height: MySizes.lg),
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
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.fetchUsers();
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
          boxShadow: MyBoxShadows.kLightShadow,
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
                "Roll No",
                style: MyTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(width: MySizes.md),
              Text("Students",
                  style: MyTextStyles.bodyLarge.copyWith(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Text("Present",
                  style: MyTextStyles.bodyLarge.copyWith(color: Colors.white)),
              const SizedBox(width: MySizes.md),
              Text("Absent",
                  style: MyTextStyles.bodyLarge.copyWith(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
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
            padding: const EdgeInsets.all(MySizes.md - 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
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
                        height: 12,
                        width: double.infinity,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Container(
                        height: 10,
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

class MarkAllWidget extends GetView<MarkAttendanceController> {
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
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: MyHelperFunctions.isDarkMode(context)
            ? MyDynamicColors.darkerGreyBackgroundColor
            : MyDynamicColors.activeBlueTint,
        border: Border(
            bottom:
            BorderSide(width: 0.5, color: MyDynamicColors.borderColor)),
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
                  child: Icon(
                    controller.isMarkAllPresent.value
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined,
                    size: 24,
                    color: controller.isMarkAllPresent.value
                        ? MyDynamicColors.activeGreen
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: MySizes.md + 18),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onMarkAllAbsent,
                  child: Icon(
                    controller.isMarkAllAbsent.value
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined,
                    size: 24,
                    color: controller.isMarkAllAbsent.value
                        ? MyDynamicColors.activeRed
                        : Colors.black87,
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

