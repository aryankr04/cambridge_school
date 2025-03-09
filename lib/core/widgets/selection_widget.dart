import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/constants/colors.dart';
import '../../core/utils/constants/dynamic_colors.dart';
import '../../core/utils/constants/sizes.dart';

// **************************************************************************
// Enums
// **************************************************************************

enum SelectionWidgetType { chip, icon }

// **************************************************************************
// Controller
// **************************************************************************

class SelectionController extends GetxController {
  // Keep track of multiple controllers if needed (for different widgets on same screen)
  static final _controllers = <String, SelectionController>{};

  static SelectionController findOrCreate(String tag) {
    if (_controllers.containsKey(tag)) {
      return _controllers[tag]!;
    } else {
      final controller = Get.put(SelectionController(), tag: tag);
      _controllers[tag] = controller;
      return controller;
    }
  }

  final selectedItem = Rx<String?>(null);
  final selectedItems = <String>[].obs;

  void clearSelection() {
    selectedItem.value = null;
    selectedItems.clear();
  }
}

// **************************************************************************
// Widget
// **************************************************************************

class MySelectionWidget extends StatefulWidget {
  final List<String> items;
  final List<String>? selectedItems;
  final String? selectedItem;
  final double? width;
  final double? height;
  final double spacing;
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
  final Axis scrollDirection;
  final String tag;  // Add a tag to identify the controller

  const MySelectionWidget({
    super.key,
    required this.items,
    this.selectedItem,
    this.selectedItems,
    this.height = 80,
    this.width = 100,
    this.spacing = 8.0,
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
    this.scrollDirection = Axis.vertical,
    required this.tag, // Make tag required
  });

  @override
  State<MySelectionWidget> createState() => _MySelectionWidgetState();
}

// **************************************************************************
// Widget State
// **************************************************************************

class _MySelectionWidgetState extends State<MySelectionWidget> {
  late final SelectionController controller;

  @override
  void initState() {
    super.initState();
    controller = SelectionController.findOrCreate(widget.tag);  // Use tag to find or create
    _initializeSelection();
  }

  @override
  void didUpdateWidget(covariant MySelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the items list changes, re-initialize the selection.
    if (oldWidget.items != widget.items || oldWidget.isMultiSelect != widget.isMultiSelect || oldWidget.selectedItem != widget.selectedItem || oldWidget.selectedItems != widget.selectedItems) {
      _initializeSelection();
    }
  }

  @override
  void dispose() {
    // Don't dispose the controller. Let GetX handle it
    super.dispose();
  }

  void _initializeSelection() {
    controller.clearSelection(); // Clear existing selection

    if (widget.isMultiSelect) {
      if (widget.selectedItems != null) {
        controller.selectedItems.addAll(widget.selectedItems!);
      }
    } else {
      if (widget.selectedItem != null) {
        controller.selectedItem.value = widget.selectedItem;
      }
    }
  }

  void _handleSelection(String item) {
    if (widget.isMultiSelect) {
      if (controller.selectedItems.contains(item)) {
        controller.selectedItems.remove(item);
      } else {
        controller.selectedItems.add(item);
      }
      widget.onMultiSelectChanged?.call(controller.selectedItems.toList());
    } else {
      controller.selectedItem.value = item;
      widget.onSelectionChanged?.call(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) _buildTitle(context),
        _buildSelectionList(),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16 - 4),
      ],
    );
  }

  Widget _buildSelectionList() {
    return SingleChildScrollView(
      scrollDirection: widget.scrollDirection,
      child: Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        direction: widget.scrollDirection == Axis.horizontal
            ? Axis.horizontal
            : Axis.vertical,
        children: widget.items.map((item) => _buildSelectionItem(item)).toList(),
      ),
    );
  }

  Widget _buildSelectionItem(String item) {
    return Obx(() {
      final isSelected = widget.isMultiSelect
          ? controller.selectedItems.contains(item)
          : controller.selectedItem.value == item;

      return GestureDetector(
        onTap: () => _handleSelection(item),
        child: Container(
          width:
          widget.selectionWidgetType == SelectionWidgetType.icon ? widget.width : null,
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
          child: _buildItemContent(item, isSelected),
        ),
      );
    });
  }

  Widget _buildItemContent(String item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.selectionWidgetType == SelectionWidgetType.icon) _buildIconContent(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.selectionWidgetType == SelectionWidgetType.chip ? MySizes.md : MySizes.sm,
            vertical: widget.selectionWidgetType == SelectionWidgetType.chip ? MySizes.sm : MySizes.sm,
          ),
          child: Text(
            widget.displayTextBuilder?.call(item) ?? item,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: isSelected
                ? (widget.selectedTextStyle ??
                (widget.selectionWidgetType == SelectionWidgetType.icon
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: MyColors.activeBlue,
                )
                    : Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: MyColors.activeBlue,
                )))
                : (widget.unselectedTextStyle ??
                (widget.selectionWidgetType == SelectionWidgetType.icon
                    ? Theme.of(context).textTheme.labelLarge
                    : Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ))),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildIconContent() {
    return SizedBox(
      height: widget.height,
      child: widget.content ?? const SizedBox(),
    );
  }
}