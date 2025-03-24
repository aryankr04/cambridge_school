import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/enums/schedule_event_type.dart';

class EventItem extends StatelessWidget {
  final int? period;
  final String? interval;
  final bool isStudent;
  final RxBool isWrite;
  final String startsAt;
  final String endsAt;
  final String? subject;
  final String? classTeacherName;
  final String? className;
  final String? sectionName;
  final ScheduleEventType eventType;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const EventItem({
    super.key,
    this.period,
    this.interval,
    required this.isWrite,
    required this.startsAt,
    this.subject,
    this.classTeacherName,
    required this.eventType,
    this.onEditPressed,
    this.onDeletePressed,
    this.className,
    this.sectionName,
    required this.isStudent,
    required this.endsAt,
  });

  @override
  Widget build(BuildContext context) {
    final stripColor = eventType.color;
    final itemText = (eventType == ScheduleEventType.classSession)
        ? subject
        : eventType.displayName;
    final itemEmoji = eventType.emoji;

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: period != null ? stripColor : Colors.transparent,
            ),
            margin: const EdgeInsets.only(right: MySizes.md),
            padding: const EdgeInsets.all(MySizes.sm),
            child: Text(
              period?.toString() ?? ' ', // Handle null period
              style: TextStyle(
                color: period != null ? Colors.white : Colors.transparent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: MyCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.1,
                          height: Get.width * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyColors.borderColor,
                              width: 0.5,
                            ),
                            borderRadius:
                                BorderRadius.circular(MySizes.cardRadiusXs),
                          ),
                          child: Text(
                            itemEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(width: MySizes.sm + 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$startsAt - $endsAt',
                                overflow: TextOverflow.ellipsis,
                                style: MyTextStyle.labelMedium
                                    .copyWith(fontSize: 13),
                              ),
                              Text(
                                itemText!,
                                overflow: TextOverflow.ellipsis,
                                style: MyTextStyle.bodyLarge,
                              ),
                              if (eventType == ScheduleEventType.classSession &&
                                  classTeacherName != null) ...[
                                const SizedBox(height: MySizes.xs - 2),
                                Wrap(
                                  // Use Wrap instead of Row for teacher/class and interval
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: MySizes.xs,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // Added to fit content
                                      children: [
                                        Icon(
                                          isStudent
                                              ? Icons.person
                                              : Icons.assignment,
                                          size: 12,
                                          color: MyDynamicColors
                                              .subtitleTextColor
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          // Wrap the Text in Flexible to avoid overflow
                                          child: Text(
                                            isStudent
                                                ? classTeacherName ?? ''
                                                : '$className $sectionName',
                                            style: MyTextStyle.labelMedium
                                                .copyWith(fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // Added to fit content
                                      children: [
                                        Icon(
                                          Icons.timelapse,
                                          size: 12,
                                          color: MyDynamicColors
                                              .subtitleTextColor
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          // Wrap the Text in Flexible to avoid overflow
                                          child: Text(
                                            '${interval?.trim()}',
                                            style: MyTextStyle.labelMedium
                                                .copyWith(fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ] else
                                Row(
                                  mainAxisSize:
                                      MainAxisSize.min, // Added to fit content
                                  children: [
                                    Icon(
                                      Icons.timelapse,
                                      size: 12,
                                      color: MyDynamicColors.subtitleTextColor
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      // Wrap the Text in Flexible to avoid overflow
                                      child: Text(
                                        '${interval?.trim()}',
                                        style: MyTextStyle.labelMedium
                                            .copyWith(fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Obx(
                          () => isWrite.value
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        MyConfirmationDialog.show(
                                            DialogAction.Delete, onConfirm: () {
                                          onDeletePressed?.call();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: MyDynamicColors.activeRed,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: onEditPressed,
                                      icon: Icon(
                                        Icons.edit,
                                        color: MyDynamicColors.activeBlue,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: stripColor,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(MySizes.cardRadiusSm),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
