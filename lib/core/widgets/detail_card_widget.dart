import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import 'card_widget.dart';
import 'divider.dart';

class MyDetailCard extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final IconData? icon;
  final Widget? iconWidget;
  final String? subtitle;
  final Widget? widget;
  final Widget? action;
  final List<ListTileDetails>? list;
  final Color? color;
  final bool? hasDivider;
  final bool? hasIcon;
  final bool? hasSameBorderColor;
  final bool? hasExpandedIcon;
  final bool? initiallyExpanded;

  const MyDetailCard({
    super.key,
    required this.title,
    this.titleStyle,
    this.icon,
    this.iconWidget,
    this.subtitle,
    this.widget, // Widget provided by user
    this.list,
    this.color,
    this.hasDivider = true,
    this.hasIcon = true,
    this.hasSameBorderColor = false,
    this.hasExpandedIcon = true,
    this.initiallyExpanded = true,
    this.action,
  });

  @override
  _MyDetailCardState createState() => _MyDetailCardState();
}

class _MyDetailCardState extends State<MyDetailCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded!;
  }

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
                        if (widget.widget != null && widget.hasExpandedIcon==true)
                          IconButton(
                            icon: Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: widget.color ?? MyColors.activeBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                      ],
                    ),
                    if (_isExpanded &&
                        (widget.widget != null ||
                            widget.list != null &&
                                widget.list!.isNotEmpty)) ...[
                      if (widget.hasDivider!) ...[
                        const SizedBox(height: MySizes.sm),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: MyDottedLine(
                              dashLength: 4,
                              dashGapLength: 4,
                              lineThickness: 1,
                              dashColor: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: MySizes.sm),
                      ]
                    ],

                    if (_isExpanded &&
                        widget.list != null &&
                        widget.list!.isNotEmpty)
                      Wrap(
                        children: widget.list!.map((item) {
                          return listTile(
                            item.field,
                            item.value,
                            item.icon?.icon,
                          );
                        }).toList(),
                      ),
                    // Show the widget provided by the user if expanded
                    if (_isExpanded && widget.widget != null) widget.widget!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding listTile(String field, String value, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        children: [
          if (icon != null)
            MyCard(
              color: widget.color?.withOpacity(0.1) ??
                  MyColors.activeBlue.withOpacity(0.1),
              padding: const EdgeInsets.all(4),
              isCircular: true,
              child: Icon(
                size: 18,
                icon,
                color: widget.color ?? MyColors.activeBlue,
              ),
            ),
          const SizedBox(width: MySizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(Get.context!).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  field,
                  style: Theme.of(Get.context!).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListTileDetails {
  final String field;
  final String value;
  final Icon? icon;
  ListTileDetails({required this.field, required this.value, this.icon});
}
