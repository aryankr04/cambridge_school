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

class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    this.isExpanded = false,
    this.isEdit = false,
    required this.onEdit,
    required this.onDelete,
  });

  final Notice notice;
  final bool isExpanded;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yy');
    final formattedDate = dateFormatter.format(notice.createdTime);
    final timeFormatter =
        DateFormat('h:mm a'); // 'h' for 1-12 hour format, 'a' for am/pm
    final formattedTime = timeFormatter.format(notice.createdTime);

    final deviceWidth = Get.width;
    final categoryEmoji = MyLists.getNoticeCategoryEmoji(notice.category);

    return MyCard(
      margin: const EdgeInsets.only(
          left: MySizes.md, right: MySizes.md, bottom: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: Text(
                  notice.title,
                  style: MyTextStyles.titleLarge.copyWith(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MySizes.sm),
          const MyDottedLine(dashColor: MyColors.dividerColor),
          const SizedBox(height: MySizes.sm),
          ReadMoreText(
            notice.description,
            style: MyTextStyles.labelMedium.copyWith(color: MyColors.iconColor),
            trimLines: 3,
            trimMode: TrimMode.Line,
            colorClickableText: MyColors.iconColor,
          ),
          const SizedBox(height: MySizes.md),
          Row(
            children: [
              MyLabelChip(
                text: notice.category,
                color: MyColors.getRandomColor(),
              ),
            ],
          ),
          const SizedBox(height: MySizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: MySizes.sm),
              Expanded(
                child: _buildRoundedInfoContainer(
                    notice.createdById, Icons.person),
              ),
              const SizedBox(width: MySizes.sm),
              Expanded(
                child: _buildRoundedInfoContainer(
                    formattedDate, Icons.calendar_month),
              ),
              const SizedBox(width: MySizes.sm),
              Expanded(
                child: _buildRoundedInfoContainer(
                    formattedTime, Icons.access_time),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: MySizes.md),
            const MyDottedLine(dashColor: MyColors.dividerColor),
            const SizedBox(height: MySizes.md),
            const Text('Target Audience', style: MyTextStyles.bodyLarge),
            const SizedBox(height: MySizes.sm),
            Wrap(
              spacing: MySizes.sm,
              runSpacing: MySizes.sm,
              children: notice.targetAudience
                  .map((audience) => Row(
                        children: [
                          MyLabelChip(text: audience),
                        ],
                      ))
                  .toList(),
            ),
            if (notice.targetClass != null &&
                notice.targetClass!.isNotEmpty) ...[
              const SizedBox(height: MySizes.md),
              const Text('Target Class', style: MyTextStyles.bodyLarge),
              const SizedBox(height: MySizes.sm),
              Wrap(
                spacing: MySizes.sm,
                runSpacing: MySizes.sm,
                children: notice.targetClass!
                    .map((audience) => Row(
                          children: [
                            MyLabelChip(text: audience),
                          ],
                        ))
                    .toList(),
              ),
            ]
          ],
          if (isEdit) ...[
            const SizedBox(height: MySizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () => onEdit(),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                  label:
                      const Text('Edit', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(MyColors.activeBlue),
                  ),
                ),
                const SizedBox(width: MySizes.md),
                FilledButton.icon(
                  onPressed: () => MyConfirmationDialog.show(
                      DialogAction.Delete,
                      onConfirm: onDelete),
                  icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                  label: const Text('Delete',
                      style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(MyColors.activeRed),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildRoundedInfoContainer(String text, IconData? icon) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
        color: MyDynamicColors.backgroundColorGreyLightGrey,
      ),
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: MyColors.subtitleTextColor.withOpacity(0.75),
              size: 15,
            ),
            const SizedBox(width: MySizes.xs),
          ],
          Flexible(
            child: Text(
              text,
              style: MyTextStyles.labelMedium.copyWith(
                  fontSize: 11,
                  color: MyColors.subtitleTextColor.withOpacity(0.75)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
