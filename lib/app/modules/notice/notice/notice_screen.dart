// notice_screen.dart
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/gradients.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/dialog_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/banner_card.dart';
import '../../attendance/mark_attendance/mark_attendance_screen.dart';
import '../../user_management/create_user/models/roles.dart';
import '../create_notice/create_notice_screen.dart';
import '../notice_model.dart';
import 'notice_controller.dart';
import 'notice_tile.dart';

class NoticeScreen extends StatelessWidget {
  final NoticeController controller = Get.find<NoticeController>();

  NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticeboard')),
      backgroundColor: MyColors.lightGrey,
      body: RefreshIndicator(
        onRefresh: controller.fetchNotices,
        displacement: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: MySizes.md),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                  child: Row(
                    children: [
                      const SizedBox(width: MySizes.md),
                      const Icon(
                        Icons.filter_alt_outlined,
                        color: MyColors.iconColor,
                      ),
                      const SizedBox(width: MySizes.sm),
                      const Text(
                        'Filter',
                        style: MyTextStyles.titleLarge,
                      ),
                      const SizedBox(width: MySizes.md),
                      SizedBox(
                        width: 125,
                        child: MyDialogDropdown(
                          optionsForChips: Roles().getAllRolesAsString(),
                          isMultipleSelection: true,
                          onMultipleChanged: (List<String>? values) {
                            controller.setSelectedTargetAudience(values);
                          },
                          showAllOption: true,
                          showMultiple: true,
                          dropdownWidgetType: DropdownWidgetType.Filter,
                          hintText: 'Role',
                        ),
                      ),
                      const SizedBox(width: MySizes.lg),
                      Obx(() => controller.selectedTargetAudience
                          .contains('Student') ||
                          controller.selectedTargetAudience.contains('All')
                          ? Row(
                        children: [
                          SizedBox(
                            width: 125,
                            child: MyDialogDropdown(
                              optionsForChips: MyLists.classOptions,
                              isMultipleSelection: true,
                              onMultipleChanged: (List<String>? values) {
                                controller.setSelectedForClass(values);
                              },
                              hintText: 'Class',
                              showAllOption: true,
                              dropdownWidgetType:
                              DropdownWidgetType.Filter,
                            ),
                          ),
                          const SizedBox(width: MySizes.md),
                        ],
                      )
                          : const SizedBox.shrink()),
                      SizedBox(
                        width: 125,
                        child: MyDialogDropdown(
                          optionsForChips: Roles().getAllRolesAsString(),
                          isMultipleSelection: true,
                          onMultipleChanged: (List<String>? values) {
                            controller.setSelectedTargetAudience(values);
                          },
                          showAllOption: true,
                          showMultiple: true,
                          dropdownWidgetType: DropdownWidgetType.Filter,
                          hintText: 'Category',
                        ),
                      ),
                      const SizedBox(width: MySizes.lg),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
              child: MyBannerCard(
                title: 'Publish Important Notices',
                description: 'Create and share school-wide notices.',
                onPressed: () {
                  // Navigate to CreateNoticeScreen
                  Get.to(() => CreateNoticeScreen());
                },
                buttonText: 'Create Notice',
                icon: const Text('📢', style: TextStyle(fontSize: 56)),
                gradient: MyGradient.lightBlue,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.all(MySizes.md),
                    child: _buildShimmerNoticeList(),
                  );
                } else if (controller.errorMessage.value != null) {
                  return Center(
                      child: Text('Error: ${controller.errorMessage.value}'));
                } else if (controller.filteredNoticeList.isEmpty) {
                  return RefreshIndicator(
                      onRefresh: controller.fetchNotices,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                          return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight,
                                ),
                                child: const Center(
                                    child: Text('No notices available.')),
                              ));
                        },
                      ));
                } else {
                  return NoticeList(
                    notices: controller.filteredNoticeList,
                    onDelete: (Notice notice) {
                      controller.deleteNotice(notice);
                    },
                    onEdit: (Notice notice) {
                      // Navigate to CreateNoticeScreen with the notice to edit
                      Get.to(() => CreateNoticeScreen(noticeToEdit: notice));
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerNoticeList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: MySizes.md),
            padding: const EdgeInsets.all(MySizes.md),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: Get.width * 0.1,
                      height: Get.width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(MySizes.cardRadiusXs)),
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
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
                            height: 12,
                            width: Get.width * 0.4,
                            color: Colors.grey[300]!,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.md),
                Container(
                  height: 8,
                  width: double.infinity,
                  color: Colors.grey[300]!,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                Container(
                  height: 8,
                  width: Get.width,
                  color: Colors.grey[300]!,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                const SizedBox(
                  height: MySizes.md,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NoticeList extends StatelessWidget {
  final List<Notice> notices;
  final Function(Notice) onDelete;
  final Function(Notice) onEdit;

  const NoticeList(
      {super.key,
        required this.notices,
        required this.onDelete,
        required this.onEdit});

  @override
  Widget build(BuildContext context) {
    String? currentMonth;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        final notice = notices[index];
        final noticeMonth = DateFormat('MMMM yyyy')
            .format(DateTime.parse(notice.createdTime.toString()));
        final isNewMonth = currentMonth != noticeMonth;
        currentMonth = noticeMonth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewMonth)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: MySizes.md - 4, horizontal: MySizes.md),
                child: Text(
                  noticeMonth,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.headlineTextColor),
                ),
              ),
            NoticeTile(
              notice: notice,
              isExpanded: false,
              isEdit: true,
              onEdit: () => onEdit(notice), // Pass the notice to onEdit
              onDelete: () => onDelete(notice),
            ),
          ],
        );
      },
    );
  }
}