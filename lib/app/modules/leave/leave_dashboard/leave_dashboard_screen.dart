import 'package:cambridge_school/app/modules/leave/apply_leave/apply_leave_screen.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/gradients.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/banner_card.dart';
import '../../../../core/widgets/selection_widget.dart';
import 'leave_card_widget.dart';
import 'leave_dashboard_controller.dart';

class LeaveDashboardScreen extends GetView<LeaveDashboardController> {
  const LeaveDashboardScreen({Key? key}) : super(key: key);

  // Constants
  static const String kAllMonths = 'All';
  static const String kLeavesOverviewTitle = 'Leaves Overview';
  static const String kTotalLeaves = 'Total Leaves';
  static const String kPending = 'Pending';
  static const String kApproved = 'Approved';
  static const String kRejected = 'Rejected';
  static const String kApplyForLeave = 'Apply For Leave';
  static const String kSubmitLeaveRequest =
      'Submit leave request quickly and easily.';
  static const String kApplyNow = 'Apply Now';
  static const String kSickEmoji = '🤒';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Dashboard'),
      ),
      backgroundColor: MyColors.softGrey,
      body: Obx(() =>
          controller.isLoading.value ? _buildLoadingScreen() : _buildContent()),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Loading Screen)
  Widget _buildLoadingScreen() {
    return Column(
      children: [
        _buildMonthSelection(),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const _ShimmerContent(),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Main Content)

  /// Builds the main content of the dashboard.
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildScrollableContent()),
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.md),
            child: MyBannerCard(
              title: kApplyForLeave,
              description: kSubmitLeaveRequest,
              onPressed: () {
                Get.to(() => const ApplyLeaveScreen());
              },
              buttonText: kApplyNow,
              icon: const Text(kSickEmoji, style: TextStyle(fontSize: 48)),
              gradient: MyGradient.lightBlue,
            ),
          ),
          _buildMonthSelection(),
          _buildStatsSection(),
          _buildLeaveList(),
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
          Text(kLeavesOverviewTitle,
              style: MyTextStyle.headlineSmall.copyWith(fontSize: 18)),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                    kTotalLeaves,
                    controller.totalLeaveApplied.value.toString(),
                    Icons.description,
                    MyColors.activeBlue),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: _buildDataCard(
                    kPending,
                    controller.totalLeavePending.value.toString(),
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
                  kApproved,
                  '${controller.totalLeaveApproved.value}',
                  Icons.check,
                  MyColors.activeGreen,
                  subtitle:
                      '(${controller.leaveApprovalRate.value.toStringAsFixed(0)}%)',
                ),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: _buildDataCard(
                  kRejected,
                  '${controller.totalLeaveRejected.value}',
                  Icons.close_rounded,
                  MyColors.activeRed,
                  subtitle:
                      '(${controller.leaveRejectionRate.value.toStringAsFixed(0)}%)',
                ),
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
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: MySizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value,
                      style: MyTextStyle.titleLarge.copyWith(
                          color: MyColors.headlineTextColor, fontSize: 15)),
                  if (subtitle != null) ...[
                    const SizedBox(width: MySizes.sm - 4),
                    Text(subtitle,
                        style: MyTextStyle.bodyLarge.copyWith(
                            color: MyColors.subtitleTextColor, fontSize: 12)),
                  ]
                ],
              ),
              Text(title,
                  style: MyTextStyle.bodySmall.copyWith(
                      color: MyColors.subtitleTextColor, fontSize: 13)),
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
    final months = List.generate(12, (index) {
      final month = DateTime(DateTime.now().year, index + 1);
      return DateFormat('MMM').format(month);
    });

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: MySizes.md-4),
      padding: const EdgeInsets.symmetric(
          horizontal: MySizes.md, vertical: MySizes.sm),
      child: MySelectionWidget(
        items: [kAllMonths, ...months],
        selectedItem: controller.isAllMonths.value
            ? kAllMonths
            : DateFormat('MMM').format(controller.selectedMonth.value),
        onSelectionChanged: (value) {
          if (value == kAllMonths) {
            controller.setAllMonths();
          } else {
            final monthIndex = months.indexOf(value!);
            final month = DateTime(DateTime.now().year, monthIndex + 1);
            controller.setSelectedMonth(month);
          }
        },
        scrollDirection: Axis.horizontal,
        tag: 'months',
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
          isEdit: true,
          onEdit: () {
            controller.editLeave(leave);
          },
          onDelete: () {
            controller.deleteLeave(leave);
          },
        );
      },
    );
  }
}

class _ShimmerContent extends StatelessWidget {
  const _ShimmerContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: MySizes.md),
          ),
          Row(
            children: [
              Expanded(child: _buildShimmerDataCard()),
              const SizedBox(width: MySizes.md),
              Expanded(child: _buildShimmerDataCard()),
            ],
          ),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              Expanded(child: _buildShimmerDataCard()),
              const SizedBox(width: MySizes.md),
              Expanded(child: _buildShimmerDataCard()),
            ],
          ),
          const MyDottedLine(dashColor: MyColors.dividerColor),
          const SizedBox(height: MySizes.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => _buildShimmerLeaveCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerDataCard() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(MySizes.md - 4),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: Colors.white,
      ),
    );
  }

  Widget _buildShimmerLeaveCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      padding: const EdgeInsets.all(MySizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 16,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: MySizes.sm),
          ),
          Container(
            width: 150,
            height: 12,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: MySizes.sm),
          ),
          Container(
            width: double.infinity,
            height: 12,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: MySizes.sm),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 60,
                height: 25,
                color: Colors.white,
                margin: const EdgeInsets.only(left: MySizes.sm),
              ),
              Container(
                width: 60,
                height: 25,
                color: Colors.white,
                margin: const EdgeInsets.only(left: MySizes.sm),
              ),
            ],
          )
        ],
      ),
    );
  }
}
