// AttendanceCard
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../user_management/create_user/models/user_model.dart';
import 'attendance_controller.dart';

class AttendanceCard extends GetView<AttendanceController> {
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
          () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: MyDynamicColors.activeBlue.withOpacity(0.1),
              radius: 18,
              child: Text(
                user.studentDetails?.rollNumber ?? '?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyDynamicColors.activeBlue,
                ),
              ),
            ),
            const SizedBox(
              width: MySizes.md,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName??'No Name',
                    overflow: TextOverflow.ellipsis,
                    style: MyTextStyles.titleLarge.copyWith(fontSize: 14),
                    maxLines: 1,
                  ),
                  Text(
                    user.userId,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextStyles.labelMedium,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: MySizes.sm,),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                isPresent.value ? onMarkAbsent() : onMarkPresent();
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: isPresent.value
                      ? MyDynamicColors.activeGreenTint
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPresent.value
                      ? Icons.check_circle_outline
                      : Icons.circle_outlined,
                  size: 24,
                  color: isPresent.value
                      ? MyDynamicColors.activeGreen
                      : Colors.black, // Fixed color values
                ),
              ),
            ),
            const SizedBox(
              width: MySizes.md,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                isPresent.value ? onMarkAbsent() : onMarkPresent();
              },
              child: Container(
                padding: const EdgeInsets.all(6.0), // Fixed padding value
                decoration: BoxDecoration(
                  color: isPresent.value
                      ? Colors.transparent
                      : MyDynamicColors.activeRedTint, // Fixed color value
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPresent.value ? Icons.circle_outlined : Icons.cancel,
                  size: 24,
                  color: isPresent.value
                      ? Colors.black
                      : MyDynamicColors.activeRed, // Fixed color values
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}