import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/card_widget.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../leave_model.dart';

class LeaveCard extends StatelessWidget {
  //----------------------------------------------------------------------------
  // Properties

  final LeaveModel leave;
  final bool isExpanded;
  final bool isEdit;
  final bool isApprover;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  //----------------------------------------------------------------------------
  // Constructor

  const LeaveCard({
    super.key,
    required this.leave,
    this.isExpanded = false,
    this.isEdit = false,
    this.isApprover = false,
    this.onEdit,
    this.onDelete,
    this.onApprove,
    this.onReject,
  });

  //----------------------------------------------------------------------------
  // Helper Methods (Status Chip)

  /// Determines the color and text based on the leave status.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return MyDynamicColors.activeGreen;
      case 'pending':
        return MyDynamicColors.activeOrange;
      case 'rejected':
        return MyDynamicColors.activeRed;
      default:
        return Colors.grey;
    }
  }

  /// Builds the status chip based on the leave status.
  Widget _buildStatusChip(String status) {
    return MyLabelChip(
        text: _getStatusText(status), color: _getStatusColor(status));
  }

  /// Returns the label text based on the leave status.
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  //----------------------------------------------------------------------------
  // Helper Widgets (Buttons)

  /// Builds the edit actions (Edit and Delete buttons).
  Widget _buildEditActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
          label: const Text('Edit', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(MyColors.activeBlue),
          ),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton.icon(
          onPressed: onDelete == null
              ? null
              : () => MyConfirmationDialog.show(DialogAction.Delete,
                  onConfirm: onDelete!),
          icon: const Icon(Icons.delete, color: Colors.white, size: 18),
          label: const Text('Delete', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
          ),
        ),
      ],
    );
  }

  /// Builds the approver actions (Approve and Reject buttons).
  Widget _buildApproverActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: onApprove,
          icon: const Icon(Icons.check, color: Colors.white, size: 18),
          label: const Text('Approve', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(MyDynamicColors.activeGreen),
          ),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton.icon(
          onPressed: onReject,
          icon: const Icon(Icons.close, color: Colors.white, size: 18),
          label: const Text('Reject', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // Helper Widget (Info Row)

  /// Builds an information row with an icon and label.
  Widget buildInfoRow(
    Color? color,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: MyColors.softGrey,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: MySizes.sm,
        horizontal: MySizes.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: MySizes.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11, color: color, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget Building (Core)

  @override
  Widget build(BuildContext context) {
    final deviceWidth = Get.width;
    final theme = Theme.of(context);
    final subtitleColor = MyDynamicColors.subtitleTextColor;
    const softGrey = MyColors.softGrey;

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
          left: MySizes.md, right: MySizes.md, bottom: MySizes.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.sm + 4),
            decoration: const BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: MyColors.borderColor, width: 0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: deviceWidth * 0.1,
                      height: deviceWidth * 0.1,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: MyColors.borderColor, width: 0.5),
                        borderRadius:
                            BorderRadius.circular(MySizes.cardRadiusXs),
                      ),
                      child: Text(
                        MyLists.getLeaveTypeEmoji(leave.leaveType),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leave.leaveType,
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat('d MMMM \'at\' h:mm a')
                              .format(leave.appliedAt),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                _buildStatusChip(leave.status),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  leave.reason,
                  style: MyTextStyles.labelMedium
                      .copyWith(color: MyColors.iconColor),
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  colorClickableText: MyColors.iconColor,
                ),
                const SizedBox(height: MySizes.md + 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildInfoRow(
                        subtitleColor,
                        Icons.date_range_rounded,
                        'Start',
                        DateFormat('d MMM, y').format(leave.startDate),
                      ),
                    ),
                    const SizedBox(width: MySizes.sm),
                    Expanded(
                      child: buildInfoRow(
                        subtitleColor,
                        Icons.date_range_rounded,
                        'End',
                        DateFormat('d MMM, y').format(leave.endDate),
                      ),
                    ),
                    const SizedBox(width: MySizes.sm),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(MySizes.cardRadiusSm),
                        color: softGrey,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: MySizes.sm,
                        horizontal: MySizes.sm + 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: subtitleColor,
                            size: 18,
                          ),
                          const SizedBox(width: MySizes.xs),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Period",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: subtitleColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${leave.endDate.difference(leave.startDate).inDays + 1} Days",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subtitleColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: MySizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: buildInfoRow(
                          subtitleColor,
                          Icons.person,
                          'Applicant',
                          '${leave.applicantName} (${leave.applicantId})',
                        ),
                      ),
                    ],
                  ),
                ],
                if (isEdit && onEdit != null && onDelete != null) ...[
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  _buildEditActions(),
                ],
                if (isApprover && onApprove != null && onReject != null) ...[
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  _buildApproverActions(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

}
