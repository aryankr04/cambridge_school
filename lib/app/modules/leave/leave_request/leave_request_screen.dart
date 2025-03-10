import 'dart:math';

import 'package:cambridge_school/app/modules/leave/leave_request/leave_request_controller.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../leave_dashboard/leave_card_widget.dart';
import '../../../../core/widgets/selection_widget.dart';

class LeaveRequestScreen extends StatelessWidget {
  LeaveRequestScreen({super.key});

  final LeaveRequestController controller = Get.put(LeaveRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
      ),
      backgroundColor: MyColors.softGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelection(), // Display month selection even when loading
              Expanded(child: _buildLoadingShimmer()),
            ],
          );
        } else {
          return _buildContent();
        }
      }),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthSelection(),
        Expanded(child: _buildScrollableContent()),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildStatsSection(),
          _buildFilterSection(),
          _buildLeaveList(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return MyCard(
      margin: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaves Overview',
            style: MyTextStyle.headlineSmall.copyWith(fontSize: 18),
          ),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                    'Total Leaves',
                    controller.totalLeaves.value.toString(),
                    Icons.description,
                    MyColors.activeBlue),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: _buildDataCard(
                    'Pending',
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
                    style: MyTextStyle.titleLarge
                        .copyWith(color: MyColors.headlineTextColor, fontSize: 15),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: MySizes.sm - 4),
                    Text(
                      subtitle,
                      style: MyTextStyle.bodyLarge
                          .copyWith(color: MyColors.subtitleTextColor, fontSize: 12),
                    )
                  ]
                ],
              ),
              Text(
                title,
                style: MyTextStyle.bodySmall
                    .copyWith(color: MyColors.subtitleTextColor, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelection() {
    final months = List.generate(12, (index) {
      final month = DateTime(DateTime.now().year, index + 1);
      return DateFormat('MMM').format(month);
    });

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: MySizes.md, vertical: MySizes.sm),
      child: GetBuilder<SelectionController>(
        init: SelectionController(),
        builder: (selectionController) {
          return MySelectionWidget(
            items: ['All', ...months],
            selectedItem: controller.isAllMonths.value
                ? 'All'
                : DateFormat('MMM').format(controller.selectedMonth.value),
            onSelectionChanged: (value) {
              if (value == 'All') {
                controller.setAllMonths();
              } else {
                final monthIndex = months.indexOf(value!);
                final month = DateTime(DateTime.now().year, monthIndex + 1);
                controller.setSelectedMonth(month);
              }
            },
            scrollDirection: Axis.horizontal,
            tag: 'months',

          );
        },
      ),
    );
  }

  Widget _buildLeaveList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filteredLeaves.length,
      itemBuilder: (context, index) {
        final leave = controller.filteredLeaves[index];
        return LeaveCard(
          leave: leave,
          isApprover: true,
          onApprove: () {
            controller.approveLeave(leave);
          },
          onReject: () {
            controller.rejectLeave(leave);
          },
        );
      },
    ));
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                'Filter List',
                style: MyTextStyle.titleLarge,
              ),
              SizedBox(width: MySizes.sm),
              Icon(
                Icons.filter_alt_outlined,
                color: MyColors.headlineTextColor,
                size: 20,
              ),
            ],
          ),
          FilledButton(
            onPressed: () {
              _showFilterDialog(Get.context!);
            },
            child: const Text('Filter'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Filter & Sort',
            style: MyTextStyle.headlineSmall,
          ),
          content: GetBuilder<SelectionController>(
            init: SelectionController(),
            builder: (selectionController) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter',
                      style: MyTextStyle.titleLarge,
                    ),
                    const SizedBox(height: MySizes.sm),
                    MySelectionWidget(
                      onSelectionChanged: (value) {
                        // Pass the selected status value directly
                        controller.setSelectedStatusFilter(value == 'All' ? null : value);
                      },
                      items: const ['All', 'Pending', 'Approved', 'Rejected'],
                      displayTextBuilder: (status) => status,
                      tag: 'Filter',
                    ),
                    const SizedBox(height: MySizes.md),
                    const Text(
                      'Sort',
                      style: MyTextStyle.titleLarge,
                    ),
                    const SizedBox(height: MySizes.sm),
                    MySelectionWidget(
                      onSelectionChanged: (value) {
                        controller
                            .setSelectedSortOption(_stringToSortOption(value!));
                      },
                      tag: 'Sort',

                      items: const [
                        'Applied Date (Newest)',
                        'Applied Date (Oldest)',
                        'Leave Type (A-Z)',
                        'Leave Type (Z-A)',
                        'Applicant ID (A-Z)',
                        'Applicant ID (Z-A)',
                        'Leave Period (Shortest)',
                        'Leave Period (Longest)'
                      ],
                      displayTextBuilder: (sortOption) => sortOption,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            FilledButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  SortOption _stringToSortOption(String sortOptionString) {
    switch (sortOptionString) {
      case 'Applied Date (Newest)':
        return SortOption.appliedDateDescending;
      case 'Applied Date (Oldest)':
        return SortOption.appliedDateAscending;
      case 'Leave Type (A-Z)':
        return SortOption.leaveTypeAscending;
      case 'Leave Type (Z-A)':
        return SortOption.leaveTypeDescending;
      case 'Applicant ID (A-Z)':
        return SortOption.applicantIdAscending;
      case 'Applicant ID (Z-A)':
        return SortOption.applicantIdDescending;
      case 'Leave Period (Shortest)':
        return SortOption.periodAscending;
      case 'Leave Period (Longest)':
        return SortOption.periodDescending;
      default:
        return SortOption.appliedDateDescending;
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
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
                      Expanded(
                        child: _buildShimmerDataCard(),
                      ),
                      const SizedBox(width: MySizes.md),
                      Expanded(
                        child: _buildShimmerDataCard(),
                      ),
                    ],
                  ),
                  const SizedBox(height: MySizes.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildShimmerDataCard(),
                      ),
                      const SizedBox(width: MySizes.md),
                      Expanded(
                        child: _buildShimmerDataCard(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: MySizes.md, horizontal: MySizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: MySizes.sm),
                      const Icon(
                        Icons.filter_alt_outlined,
                        color: MyColors.headlineTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildShimmerLeaveCard();
              },
            ),
          ],
        ),
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
            offset: const Offset(0, 3),
          ),
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
class TransformMatrices {
  static Matrix4 scaleDown(TransformableListItem item) {
    const endScaleBound = 0.3;
    final animationProgress = item.visibleExtent / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);
      paintTransform
        ..translate(item.size.width / 2)
        ..scale(scale)
        ..translate(-item.size.width / 2);
    }

    return paintTransform;
  }

  static Matrix4 rotate(TransformableListItem item) {
    const maxRotationTurnsInRadians = pi / 2.0;
    final animationProgress = 1 - item.visibleExtent / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final isEven = item.index?.isEven ?? false;

      final FractionalOffset fractionalOffset;
      final int rotateDirection;

      switch (item.position) {
        case TransformableListItemPosition.topEdge:
          fractionalOffset = isEven
              ? FractionalOffset.bottomLeft
              : FractionalOffset.bottomRight;
          rotateDirection = isEven ? -1 : 1;
          break;
        case TransformableListItemPosition.middle:
          return paintTransform;
        case TransformableListItemPosition.bottomEdge:
          fractionalOffset =
          isEven ? FractionalOffset.topLeft : FractionalOffset.topRight;
          rotateDirection = isEven ? 1 : -1;
          break;
      }

      final rotateAngle = animationProgress * maxRotationTurnsInRadians;
      final translation = fractionalOffset.alongSize(item.size);

      paintTransform
        ..translate(translation.dx, translation.dy)
        ..rotateZ(rotateDirection * rotateAngle)
        ..translate(-translation.dx, -translation.dy);
    }

    return paintTransform;
  }

  static Matrix4 wheel(TransformableListItem item) {
    const maxRotationTurnsInRadians = pi / 5.0;
    const minScale = 0.6;
    const maxScale = 1.0;
    const depthFactor = 0.01;

    final medianOffset = item.constraints.viewportMainAxisExtent / 2;
    final animationProgress =
        1 - item.offset.dy.clamp(0, double.infinity) / medianOffset;
    final scale = minScale + (maxScale - minScale) * animationProgress.abs();

    final translationOffset = FractionalOffset.center.alongSize(item.size);
    final rotationMatrix = Matrix4.identity()
      ..setEntry(3, 2, depthFactor)
      ..rotateX(maxRotationTurnsInRadians * animationProgress)
      ..scale(scale);

    final result = Matrix4.identity()
      ..translate(translationOffset.dx, translationOffset.dy)
      ..multiply(rotationMatrix)
      ..translate(-translationOffset.dx, -translationOffset.dy);

    return result;
  }
}