import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/constants/colors.dart';
import '../../core/utils/constants/dynamic_colors.dart';
import '../../core/utils/constants/sizes.dart';

class SelectionController extends GetxController {
  var selectedItem = Rx<String?>(null);  // Single item for single-select
  var selectedItems = <String>[].obs;   // List of items for multi-select
}

enum SelectionWidgetType { chip, icon }

class MySelectionWidget extends StatefulWidget {
  final List<String> items;
  final List<String>? selectedItems;  // Changed to a list for multi-select
  final String? selectedItem;  // Single item for single-select
  final double? width;
  final double? height;
  final double spacing; // Spacing between items
  final ValueChanged<String?>? onSelectionChanged;
  final String Function(String item)? displayTextBuilder;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final EdgeInsetsGeometry? itemPadding;
  final bool isMultiSelect;
  final ValueChanged<List<String>>? onMultiSelectChanged;
  final SelectionWidgetType selectionWidgetType;
  final Widget? content;
  final String? title;

  const MySelectionWidget({
    super.key,
    required this.items,
    this.selectedItem,
    this.selectedItems,
    this.height = 80,
    this.width = 100,
    this.spacing = 8.0, // Default spacing
    this.onSelectionChanged,
    this.displayTextBuilder,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.itemPadding,
    this.isMultiSelect = false,
    this.onMultiSelectChanged,
    this.selectionWidgetType = SelectionWidgetType.chip,
    this.content,
    this.title,
  });

  @override
  _MySelectionWidgetState createState() => _MySelectionWidgetState();
}

class _MySelectionWidgetState extends State<MySelectionWidget> {
  late final SelectionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SelectionController());

    // Initialize selected item(s) based on the provided parameters
    if (widget.isMultiSelect) {
      // For multi-select, initialize with the list of selected items
      if (widget.selectedItems != null) {
        controller.selectedItems.addAll(widget.selectedItems!);  // Set selected items if passed
      }
    } else {
      // For single-select, initialize with the single selected item
      if (widget.selectedItem != null) {
        controller.selectedItem.value = widget.selectedItem;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleSelection(String item) {
      if (widget.isMultiSelect) {
        if (controller.selectedItems.contains(item)) {
          controller.selectedItems.remove(item);  // Deselect item
        } else {
          controller.selectedItems.add(item);  // Select item
        }

        // Notify parent widget about the selection change
        widget.onMultiSelectChanged?.call(controller.selectedItems.toList());
      } else {
        controller.selectedItem.value = item;
        widget.onSelectionChanged?.call(item);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16-4),
        ],
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: widget.items.map((item) {
            return Obx(() {
              final isSelected = widget.isMultiSelect
                  ? controller.selectedItems.contains(item)
                  : controller.selectedItem.value == item;

              return GestureDetector(
                onTap: () => handleSelection(item),
                child: Container(
                  width: widget.selectionWidgetType == SelectionWidgetType.icon ? widget.width : null,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.selectedColor ?? MyColors.activeBlue.withOpacity(0.1)
                        : widget.unselectedColor ?? MyDynamicColors.backgroundColorGreyLightGrey,
                    borderRadius: BorderRadius.circular(
                      widget.selectionWidgetType == SelectionWidgetType.icon
                          ? MySizes.cardRadiusMd
                          : MySizes.cardRadiusXlg,
                    ),
                    border: Border.all(
                      color: isSelected ? MyColors.activeBlue : Colors.transparent,
                      width: isSelected ? 1.0 : 0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.selectionWidgetType == SelectionWidgetType.icon) ...[
                        SizedBox(
                          height: widget.height,
                          child: widget.content ?? const SizedBox(),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.selectionWidgetType == SelectionWidgetType.chip
                              ? MySizes.md
                              : MySizes.sm,
                          vertical: widget.selectionWidgetType == SelectionWidgetType.chip
                              ? MySizes.sm
                              : MySizes.sm,
                        ),
                        child: Text(
                          widget.displayTextBuilder?.call(item) ?? item,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: isSelected
                              ? (widget.selectedTextStyle ?? (widget.selectionWidgetType == SelectionWidgetType.icon
                              ? Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: MyColors.activeBlue,
                          )
                              : Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: MyColors.activeBlue,
                          )))
                              : (widget.unselectedTextStyle ?? (widget.selectionWidgetType == SelectionWidgetType.icon
                              ? Theme.of(context).textTheme.labelLarge
                              : Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400))),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
