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
import '../notice_model.dart';

class NoticeTile extends StatefulWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    this.isEdit = false,
    required this.onEdit,
    required this.onDelete,
  });

  final Notice notice;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<NoticeTile> createState() => _NoticeTileState();
}

class _NoticeTileState extends State<NoticeTile> {
  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = Get.width;
    Theme.of(context);
    final categoryEmoji =
        MyLists.getNoticeCategoryEmoji(widget.notice.category);
    final formattedCreatedTime =
        DateFormat('d MMMM \'at\' h:mm a').format(widget.notice.createdTime);

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
        title: _buildTitle(deviceWidth, widget.notice.title, categoryEmoji,
            formattedCreatedTime),
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
                  widget.notice.description,
                  style: MyTextStyles.labelMedium
                      .copyWith(color: MyColors.iconColor),
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  colorClickableText: MyColors.iconColor,
                ),
                const SizedBox(height: MySizes.md),
                _buildInfoRow('Published By', widget.notice.createdByName,
                    ' (${widget.notice.createdById})'),
                // Added null check
                const SizedBox(height: MySizes.md),

                if (widget.isEdit) ...[
                  const Text(
                    'Audience',
                    style: MyTextStyles.bodyLarge,
                  ),
                  SizedBox(
                    height: MySizes.sm,
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      ...widget.notice.targetAudience.map(
                        (audience) => MyLabelChip(text: audience),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  if (widget.notice.targetClass != null &&
                      widget.notice.targetClass!.isNotEmpty) ...[
                    const Text(
                      'Class',
                      style: MyTextStyles.bodyLarge,
                    ),
                    const SizedBox(
                      height: MySizes.sm,
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        ...widget.notice.targetClass!.map(
                          (audience) => MyLabelChip(text: audience),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                  ],
                  _buildEditActions()
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(double deviceWidth, String title, String categoryEmoji,
      String formattedCreatedTime) {
    return Row(
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
            categoryEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: MySizes.md),
        Expanded(
          // Wrap the Column with Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: MyTextStyles.bodyLarge
                    .copyWith(letterSpacing: 0, height: 1.25,fontSize: 13),
                maxLines: 2, // Limit title to 2 lines
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formattedCreatedTime,
                style: MyTextStyles.labelSmall,
                maxLines: 1, // Limit time to 1 line
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String name,
    String id,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: MyDynamicColors.backgroundColorGreyLightGrey,
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
            Icons.person,
            color: MyColors.subtitleTextColor.withOpacity(0.75),
            size: 18,
          ),
          const SizedBox(width: MySizes.sm),
          Expanded(
            // Wrap the Column with Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11,
                      color: MyColors.subtitleTextColor.withOpacity(0.75),
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Flexible(
                      // Use Flexible instead of Expanded for text
                      flex: 1,
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 12,
                            color: MyColors.subtitleTextColor,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      // Use Flexible instead of Expanded for text
                      flex: 1,
                      child: Text(
                        id,
                        style: const TextStyle(
                            fontSize: 12,
                            color: MyColors.subtitleTextColor,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
          onPressed: () => widget.onEdit(),
          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
          label: const Text('Edit', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(MyColors.activeBlue),
          ),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton.icon(
          onPressed: () => MyConfirmationDialog.show(DialogAction.Delete,
              onConfirm: widget.onDelete),
          icon: const Icon(Icons.delete, color: Colors.white, size: 18),
          label: const Text('Delete', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
          ),
        ),
      ],
    );
  }
}
