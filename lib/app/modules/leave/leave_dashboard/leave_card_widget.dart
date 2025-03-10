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

class LeaveCard extends StatefulWidget {
  final LeaveModel leave;
  final bool isEdit;
  final bool isApprover;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveCard({
    Key? key,
    required this.leave,
    this.isEdit = false,
    this.isApprover = false,
    this.onEdit,
    this.onDelete,
    this.onApprove,
    this.onReject,
  }) : super(key: key);

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = Get.width;
    final theme = Theme.of(context);
    final subtitleColor = MyDynamicColors.subtitleTextColor;
    final String periodText =
        "${widget.leave.endDate.difference(widget.leave.startDate).inDays + 1} Days";
    final String formattedAppliedAt =
        DateFormat('d MMMM \'at\' h:mm a').format(widget.leave.appliedAt);
    final String formattedStartDate =
        DateFormat('d MMM, y').format(widget.leave.startDate);
    final String formattedEndDate =
        DateFormat('d MMM, y').format(widget.leave.endDate);

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
          left: MySizes.md, right: MySizes.md, bottom: MySizes.md),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
          side: BorderSide.none,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide.none,
        ),
        childrenPadding: EdgeInsets.zero,
        tilePadding: const EdgeInsets.symmetric(horizontal: MySizes.md),
        title: _buildTitle(deviceWidth, theme, formattedAppliedAt),
        onExpansionChanged: (bool expanded) {
          _isExpanded.value = expanded;
        },
        children: [
          const MyDottedLine(dashColor: MyColors.dividerColor),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  widget.leave.reason,
                  style: MyTextStyle.labelMedium
                      .copyWith(color: MyColors.iconColor),
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  colorClickableText: MyColors.iconColor,
                ),
                const SizedBox(height: MySizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        subtitleColor,
                        Icons.date_range_rounded,
                        'Start',
                        formattedStartDate,
                      ),
                    ),
                    const SizedBox(width: MySizes.sm),
                    Expanded(
                      child: _buildInfoRow(
                        subtitleColor,
                        Icons.date_range_rounded,
                        'End',
                        formattedEndDate,
                      ),
                    ),
                    const SizedBox(width: MySizes.sm),
                    _buildPeriodContainer(subtitleColor, periodText),
                  ],
                ),
                const SizedBox(height: MySizes.md),
                if (!widget.isApprover &&
                    widget.leave.status == 'approved') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          subtitleColor,
                          Icons.person,
                           'Approved By',
                          '${widget.leave.approverName} (${widget.leave.approverId})',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MySizes.md),
                ] else
                  const SizedBox.shrink(),
                if (widget.isApprover) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          subtitleColor,
                          Icons.person,
                          'Applicant',
                          '${widget.leave.applicantName} (${widget.leave.applicantId})',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MySizes.md),
                ] else
                  const SizedBox.shrink(),
                if (widget.isEdit &&
                    widget.onEdit != null &&
                    widget.onDelete != null && widget.leave.status!='approved')
                  _buildEditActions(),
                if (widget.isApprover &&
                    widget.onApprove != null &&
                    widget.onReject != null && widget.leave.status=='pending')
                  _buildApproverActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
      double deviceWidth, ThemeData theme, String formattedAppliedAt) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth * 0.1,
                  height: deviceWidth * 0.1,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.borderColor, width: 0.5),
                    borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
                  ),
                  child: Text(
                    MyLists.getLeaveTypeEmoji(widget.leave.leaveType),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: MySizes.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.leave.leaveType,
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      formattedAppliedAt,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            _buildStatusChip(widget.leave.status),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
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

  Widget _buildPeriodContainer(Color? subtitleColor, String periodText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: MyColors.softGrey,
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
                  periodText,
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
    );
  }

  Widget _buildEditActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: widget.onEdit,
          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
          label: const Text('Edit', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(MyColors.activeBlue),
          ),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton.icon(
          onPressed: widget.onDelete == null
              ? null
              : () => MyConfirmationDialog.show(DialogAction.Delete,
                  onConfirm: widget.onDelete!),
          icon: const Icon(Icons.delete, color: Colors.white, size: 18),
          label: const Text('Delete', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
          ),
        ),
      ],
    );
  }

  Widget _buildApproverActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: widget.onApprove,
          icon: const Icon(Icons.check, color: Colors.white, size: 18),
          label: const Text('Approve', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(MyDynamicColors.activeGreen),
          ),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton.icon(
          onPressed: widget.onReject,
          icon: const Icon(Icons.close, color: Colors.white, size: 18),
          label: const Text('Reject', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
          ),
        ),
      ],
    );
  }

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
}
