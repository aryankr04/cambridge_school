import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../user_management/create_user/models/user_model.dart';
import 'mark_attendance_controller.dart';

class AttendanceCard extends GetView<MarkAttendanceController> {
  final UserModel user;
  final RxBool isPresent;
  final VoidCallback onMarkPresent;
  final VoidCallback onMarkAbsent;

  const AttendanceCard({
    super.key,
    required this.user,
    required this.isPresent,
    required this.onMarkPresent,
    required this.onMarkAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => isPresent.value ? onMarkAbsent() : onMarkPresent(),
        child: Container(
          color: isPresent.value
              ? MyDynamicColors.activeGreen.withOpacity(0.1)
              : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: isPresent.value
                    ? MyDynamicColors.activeGreen.withOpacity(0.1)
                    : MyDynamicColors.lightGrey,
                radius: 18,
                child: Text(
                  user.studentDetails?.rollNumber ?? '?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName??"N/A",
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle.titleLarge.copyWith(fontSize: 14),
                      maxLines: 1,
                    ),
                    Text(
                      user.userId,
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle.labelMedium,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MySizes.sm),
              _buildStatusIcon(
                icon: isPresent.value
                    ? Icons.check_circle_outline
                    : Icons.circle_outlined,
                color: isPresent.value
                    ? MyDynamicColors.activeGreen
                    : Colors.black,
              ),
              const SizedBox(width: MySizes.md + 18),
              _buildStatusIcon(
                icon: isPresent.value ? Icons.circle_outlined : Icons.cancel_outlined,
                color: isPresent.value
                    ? Colors.black
                    : MyDynamicColors.activeRed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon({required IconData icon, required Color color}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => isPresent.value ? onMarkAbsent() : onMarkPresent(),
      child: Icon(icon, size: 24, color: color),
    );
  }
}
