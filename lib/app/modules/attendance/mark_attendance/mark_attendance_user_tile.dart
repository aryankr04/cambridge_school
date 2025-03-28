import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../user_management/create_user/models/user_model.dart';
import 'mark_attendance_controller.dart';

class AttendanceCard extends GetView<MarkAttendanceController> {
  final UserModel user;
  final Rx<AttendanceStatus> attendanceStatus;
  final Function(AttendanceStatus) onAttendanceChanged;

  const AttendanceCard({
    super.key,
    required this.user,
    required this.attendanceStatus,
    required this.onAttendanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _showStatusOptions(context);
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: MySizes.xs, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: attendanceStatus.value.color.withOpacity(0.1),
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
                      user.fullName ?? "N/A",
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle.titleLarge.copyWith(fontSize: 14),
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            user.userId,
                            overflow: TextOverflow.ellipsis,
                            style: MyTextStyle.labelMedium,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: MySizes.xs,
                        ),
                        if (attendanceStatus.value !=
                                AttendanceStatus.present &&
                            attendanceStatus.value != AttendanceStatus.absent)
                          MyLabelChip(
                            text: attendanceStatus.value.label,
                            color: attendanceStatus.value.color,
                            textSize: 11,
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            borderRadius: 24,
                          )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MySizes.sm),
              _buildStatusIcon(
                status: AttendanceStatus.present,
                icon: Icons.check_circle_outline,
                isSelected: attendanceStatus.value == AttendanceStatus.present,
              ),
              _buildStatusIcon(
                status: AttendanceStatus.absent,
                icon: Icons.cancel,
                isSelected: attendanceStatus.value == AttendanceStatus.absent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon({
    required AttendanceStatus status,
    required IconData icon,
    required bool isSelected,
  }) {
    return IconButton(
      onPressed: () {
        if (attendanceStatus.value == status) {
          if (attendanceStatus.value == AttendanceStatus.present) {
            attendanceStatus.value = AttendanceStatus.absent;
            onAttendanceChanged(AttendanceStatus.absent);
          } else {
            attendanceStatus.value = AttendanceStatus.present;
            onAttendanceChanged(AttendanceStatus.present);
          }
        } else {
          onAttendanceChanged(status);
        }
      },
      icon: Icon(
        isSelected ? icon : Icons.circle_outlined,
        size: 24,
        color: isSelected ? attendanceStatus.value.color : MyColors.iconColor,
      ),
    );
  }

  Widget _buildOption(AttendanceStatus status) {
    return GestureDetector(
      onTap: () {
        onAttendanceChanged(status);
        Get.back();
      },
      child: Container(
        width: Get.width / 4, // Occupy equal space
        padding: const EdgeInsets.all(MySizes.md),
        decoration: BoxDecoration(
          color: attendanceStatus.value == status
              ? MyColors.activeBlue.withOpacity(0.1)
              : MyDynamicColors.backgroundColorGreyLightGrey,
          borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
          border: Border.all(
            width: 1,
            color: attendanceStatus.value == status
                ? MyColors.activeBlue
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(status.icon,
                size: 24,
                color: attendanceStatus.value == status
                    ? MyColors.activeBlue
                    : MyColors.iconColor),
            const SizedBox(height: MySizes.xs),
            Text(
              status.label,
              textAlign: TextAlign.center,
              style: MyTextStyle.labelLarge.copyWith(
                color: attendanceStatus.value == status
                    ? MyColors.activeBlue
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Text(
                'Select Attendance for ${user.fullName}',
                textAlign: TextAlign.center,
                style: MyTextStyle.headlineSmall,
              ),
            ),
            const SizedBox(
              height: MySizes.sm,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //Distribute evenly
              children: [
                _buildOption(AttendanceStatus.present),
                _buildOption(AttendanceStatus.absent),
                _buildOption(AttendanceStatus.late),
              ],
            ),
            const SizedBox(
              height: MySizes.md,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(AttendanceStatus.excused),
                _buildOption(AttendanceStatus.holiday),
                _buildOption(AttendanceStatus.notApplicable),
              ],
            ),
            const SizedBox(
              height: MySizes.xl,
            ), // Add some bottom padding
          ],
        );
      },
    );
  }
}
