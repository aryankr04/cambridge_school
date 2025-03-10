import 'package:flutter/material.dart';
import '../../../core/utils/constants/dynamic_colors.dart';
import '../../../core/utils/constants/sizes.dart';

enum TimelineItemType {
  classEvent,
  breakEvent,
  departure,
  assembly,
  start,
}
extension TimelineItemTypeExtension on TimelineItemType {
  static TimelineItemType fromString(String type) {
    switch (type) {
      case 'Class':
        return TimelineItemType.classEvent;
      case 'Break':
        return TimelineItemType.breakEvent;
      case 'Assembly':
        return TimelineItemType.assembly;
      case 'Departure':
        return TimelineItemType.departure;
      default:
        return TimelineItemType.start;
    }
  }

  String get displayName {
    switch (this) {
      case TimelineItemType.classEvent:
        return 'Class';
      case TimelineItemType.breakEvent:
        return 'Break';
      case TimelineItemType.assembly:
        return 'Assembly';
      case TimelineItemType.departure:
        return 'Departure';
      case TimelineItemType.start:
        return 'Start';
    }
  }
}

class TimelineItem extends StatefulWidget {
  final bool isMatch;
  final bool isStudent;
  final bool isWrite;
  final String id;
  final String startsAt;
  final String endsAt;
  final String? subject;
  final String? classTeacherName;
  final String? className;
  final String? sectionName;
  final TimelineItemType itemType;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const TimelineItem(
      {super.key,
        required this.id,
        required this.isWrite,
        required this.startsAt,
        this.subject,
        this.classTeacherName,
        required this.itemType,
        this.onEditPressed,
        this.onDeletePressed,
        this.className,
        this.sectionName,
        required this.isStudent, required this.endsAt, required this.isMatch});

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

TimelineItemType getItemType(String eventType) {
  switch (eventType) {
    case 'Class':
      return TimelineItemType.classEvent;
    case 'Break':
      return TimelineItemType.breakEvent;
    case 'Departure':
      return TimelineItemType.departure;
    case 'Start':
      return TimelineItemType.start;
    case 'Assembly':
      return TimelineItemType.assembly;
    default:
      throw Exception('Invalid event type: $eventType');
  }
}

class _TimelineItemState extends State<TimelineItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 70,
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.startsAt,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.isWrite)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this routine?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      widget.onDeletePressed!();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon:  Icon(
                          Icons.delete,
                          color: MyDynamicColors.activeRed,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onEditPressed!();
                        },
                        icon:  Icon(
                          Icons.edit,
                          color: MyDynamicColors.activeBlue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                if(!widget.isWrite)SizedBox(height: getItemHeight()-24,),
                if (!widget.isMatch)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 70,
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.endsAt,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            // Vertical Line and Circle Avatar
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: getCircleColor(),
                  radius: 5,
                ),
                Container(
                  width: 2,
                  height: widget.isWrite?getItemHeight()+10:getItemHeight(),
                  color: getCircleColor(),
                ),
                if (widget.itemType == TimelineItemType.departure || !widget.isMatch)
                  CircleAvatar(
                    backgroundColor: getCircleColor(),
                    radius: 5,
                  ),
              ],
            ),
            const SizedBox(width: 8),

            // Event Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: getContainerColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getItemText(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: getItemTextColor(),
                        ),
                      ),
                      if (widget.itemType == TimelineItemType.classEvent &&
                          widget.classTeacherName != null)
                        Row(
                          children: [
                            Icon(
                              widget.isStudent ? Icons.person : Icons.class_,
                              size: 16,
                              color: MyDynamicColors.iconColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.isStudent
                                    ? widget.classTeacherName ?? ''
                                    : '${widget.className} ${widget.sectionName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,

                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        !widget.isMatch?const SizedBox(height: MySizes.lg,):const SizedBox()
      ],
    );

  }

  Color getCircleColor() {
    switch (widget.itemType) {
      case TimelineItemType.classEvent:
        return MyDynamicColors.activeBlue;
      case TimelineItemType.breakEvent:
        return MyDynamicColors.activeOrange;
      case TimelineItemType.departure:
        return MyDynamicColors.activeRed;
      case TimelineItemType.start:
        return MyDynamicColors.activeGreen;
      case TimelineItemType.assembly:
        return MyDynamicColors.activeOrange;
      default:
        return Colors.black;
    }
  }

  double getItemHeight() {
    switch (widget.itemType) {
      case TimelineItemType.classEvent:
        return 75;
      case TimelineItemType.breakEvent:
        return 60;
      case TimelineItemType.departure:
        return 60;
      case TimelineItemType.start:
        return 60;
      case TimelineItemType.assembly:
        return 60;
      default:
        return 0;
    }
  }

  Color getContainerColor() {
    switch (widget.itemType) {
      case TimelineItemType.classEvent:
        return MyDynamicColors.activeBlue.withOpacity(0.1);
      case TimelineItemType.breakEvent:
        return MyDynamicColors.activeOrange.withOpacity(0.1);
      case TimelineItemType.departure:
        return MyDynamicColors.activeRed.withOpacity(0.1);
      case TimelineItemType.start:
        return MyDynamicColors.activeGreen.withOpacity(0.1);
      case TimelineItemType.assembly:
        return MyDynamicColors.activeOrange.withOpacity(0.1);
      default:
        return Colors.black;
    }
  }

  String getItemText() {
    switch (widget.itemType) {
      case TimelineItemType.classEvent:
        return widget.subject ?? '';
      case TimelineItemType.breakEvent:
        return 'Break';
      case TimelineItemType.departure:
        return 'Departure';
      case TimelineItemType.start:
        return 'Start';
      case TimelineItemType.assembly:
        return 'Assembly';
      default:
        return '';
    }
  }

  Color getItemTextColor() {
    switch (widget.itemType) {
      case TimelineItemType.classEvent:
        return MyDynamicColors.activeBlue;
      case TimelineItemType.breakEvent:
        return MyDynamicColors.activeOrange;
      case TimelineItemType.departure:
        return MyDynamicColors.activeRed;
      case TimelineItemType.start:
        return MyDynamicColors.activeGreen;
      case TimelineItemType.assembly:
        return MyDynamicColors.activeOrange;
      default:
        return Colors.black;
    }
  }
}