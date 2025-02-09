import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import 'card_widget.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final IconData? icon;
  final Widget? iconWidget;
  final String? subtitle;
  final Widget? action;
  final Color? color;
  final bool? hasIcon;
  final bool? hasSameBorderColor;

  const MyListTile({
    super.key,
    required this.title,
    this.titleStyle,
    this.icon,
    this.iconWidget,
    this.subtitle,
    this.color,
    this.hasIcon = true,
    this.hasSameBorderColor = false,
    this.action,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: MyCard(
        border: Border.all(
          width: 0.5,
          color: (widget.hasSameBorderColor ?? false)
              ? (widget.color ?? MyColors.activeBlue)
              : MyColors.borderColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        hasShadow: false,
        color: MyDynamicColors.backgroundColorWhiteDarkGrey,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Left indicator bar
            Container(
              width: MySizes.sm - 2,
              decoration: BoxDecoration(
                color: widget.color ?? MyColors.activeBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Icon/Widget and details
                        Flexible(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Vertically center the items
                            children: [
                              // Icon or Custom Widget
                              if (widget.hasIcon!)
                                MyCard(
                                  border: Border.all(
                                    width: 0.5,
                                    color: (widget.hasSameBorderColor ?? false)
                                        ? (widget.color?.withOpacity(0.5) ??
                                        MyColors.activeBlue)
                                        : MyColors.borderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      MySizes.borderRadiusMd),
                                  height: Get.width * 0.1,
                                  width: Get.width * 0.1,
                                  hasShadow: false,
                                  padding: EdgeInsets.zero,
                                  child: widget.iconWidget ??
                                      Icon(
                                        widget.icon ?? Icons.error,
                                        size: 24,
                                        color: widget.color ??
                                            MyColors.activeBlue,
                                      ),
                                ),
                              const SizedBox(width: MySizes.sm),
                              // Title and subtitle
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Center vertically
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: widget.titleStyle ??
                                          Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    // if (widget.subtitle != null)
                                    //   const SizedBox(height: SchoolSizes.xs),
                                    if (widget.subtitle != null)
                                      Text(
                                        widget.subtitle!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Down Arrow icon for expansion only if widget is provided
                        if (widget.action != null) widget.action!,

                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
