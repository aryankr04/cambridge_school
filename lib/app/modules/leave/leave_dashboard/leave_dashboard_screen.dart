import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import 'leave_card_widget.dart';
import 'leave_dashboard_controller.dart';

class LeaveDashboardScreen extends GetView<LeaveDashboardController> {
  const LeaveDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Dashboard'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildContent();
        }
      }),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Main Content)

  /// Builds the main content of the dashboard.
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthSelection(), // Month Selection
        Expanded(child: _buildScrollableContent()), // Scrollable Content
      ],
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Scrollable Content)

  /// Builds the scrollable content containing the stats and leave list.
  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(), // Stats Display
          const MyDottedLine(
            dashColor: MyColors.dividerColor,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          _buildLeaveList(), // Leave List
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Stats Section)

  /// Builds the statistics section of the dashboard.
  Widget _buildStatsSection() {
    return MyCard(
      margin: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaves Overview',
            style: MyTextStyles.headlineSmall.copyWith(fontSize: 18),
          ),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                    'Total Leaves',
                    controller.totalLeaveApplied.value.toString(),
                    Icons.description,
                    MyColors.activeBlue),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: _buildDataCard(
                    'Pending',
                    controller.totalLeaveApplied.value.toString(),
                    Icons.timelapse_rounded,
                    MyColors.activeOrange),
              ),
            ],
          ),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                    'Approved',
                    '${controller.totalLeaveApproved.value}',
                    Icons.check,
                    MyColors.activeGreen,
                    subtitle:
                        '(${controller.leaveApprovalRate.value.toStringAsFixed(0)}%)'),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: _buildDataCard(
                    'Rejected',
                    '${controller.totalLeaveRejected.value}',
                    Icons.close_rounded,
                    MyColors.activeRed,
                    subtitle:
                        '(${controller.leaveRejectionRate.value.toStringAsFixed(0)}%)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Data Card)

  /// Builds a data card widget.
  Widget _buildDataCard(String title, String value, IconData icon, Color color,
      {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(MySizes.md - 4),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            padding: const EdgeInsets.all(MySizes.sm - 2),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: MySizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: MyTextStyles.titleLarge.copyWith(
                        color: MyColors.headlineTextColor, fontSize: 15),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: MySizes.sm - 4),
                    Text(
                      subtitle,
                      style: MyTextStyles.bodyLarge.copyWith(
                          color: MyColors.subtitleTextColor, fontSize: 12),
                    )
                  ]
                ],
              ),
              Text(
                title,
                style: MyTextStyles.bodySmall
                    .copyWith(color: MyColors.subtitleTextColor, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Month Selection)

  /// Builds the month selection section.
  Widget _buildMonthSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          horizontal: MySizes.md, vertical: MySizes.sm), // Add Padding
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: controller.isAllMonths.value,
            onSelected: (selected) {
              if (selected) {
                controller.setAllMonths();
              }
            },
            padding:
                const EdgeInsets.symmetric(horizontal: MySizes.sm, vertical: 6),
            selectedColor: Colors.blue,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
              side: BorderSide(
                color: controller.isAllMonths.value
                    ? Colors.blue
                    : Colors.grey.shade400,
              ),
            ),
            elevation: 4,
            pressElevation: 8,
          ),
          const SizedBox(width: 8),
          ...List.generate(12, (index) {
            final month = DateTime(DateTime.now().year, index + 1);
            final monthName = DateFormat('MMM').format(month);
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(
                    monthName,
                    style: TextStyle(
                      color: !controller.isAllMonths.value &&
                              controller.selectedMonth.value.month == index + 1
                          ? Colors.white
                          : MyColors.subtitleTextColor,
                    ),
                  ),
                  selected: !controller.isAllMonths.value &&
                      controller.selectedMonth.value.month == index + 1,
                  onSelected: (selected) {
                    if (selected) controller.setSelectedMonth(month);
                  },
                  padding: const EdgeInsets.symmetric(
                      horizontal: MySizes.sm, vertical: 6),
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
                    side: BorderSide(
                      color: !controller.isAllMonths.value &&
                              controller.selectedMonth.value.month == index + 1
                          ? Colors.blue
                          : Colors.grey.shade400,
                    ),
                  ),
                  elevation: 4,
                  pressElevation: 8,
                ));
          }),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Leave List)

  /// Builds the list of leave cards.
  Widget _buildLeaveList() {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // disable ListView's internal scrolling
      itemCount: controller.userLeaves.length,
      itemBuilder: (context, index) {
        final leave = controller.userLeaves[index];
        return LeaveCard(
          leave: leave,
          isExpanded: true,
          isEdit: true,
          onEdit: () {
            controller.editLeave(leave);
          },
          onDelete: () {
            controller.deleteLeave(leave);
          },
          isApprover: true,
        );
      },
    );
  }
}
