import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class SchoolDialogDropdownController extends GetxController {
  final String? hintText;
  final List<String> options;
  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final bool isMultipleSelection;
  RxList<String> selectedValues = <String>[].obs;
  List<String>? _initialValues;

  SchoolDialogDropdownController({
    this.hintText,
    required this.options,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.isMultipleSelection = true,
    List<String>? initialValues,
  }) : _initialValues = initialValues {
    selectedValues.clear();
    if (_initialValues != null) {
      selectedValues.addAll(_initialValues!);
    }
    assert(
    (isMultipleSelection && onMultipleChanged != null) ||
        (!isMultipleSelection && onSingleChanged != null),
    "Provide onMultipleChanged for multiple selection, onSingleChanged otherwise.",
    );
  }

  List<String>? get initialValues => _initialValues;

  set initialValues(List<String>? value) {
    _initialValues = value;
    selectedValues.clear();
    selectedValues.addAll(_initialValues ?? []);
  }

  void setSelectedValues(List<String> values) {
    if (!isMultipleSelection) {
      if (values.length > 1) {
        values = [values.first];
      }
    }

    selectedValues.assignAll(values);

    if (isMultipleSelection) {
      onMultipleChanged!(values);
    } else {
      onSingleChanged!(values.isNotEmpty ? values.first : null);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class MyDialogDropdown extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final List<String> options;
  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final List<String>? initialSelectedValues;
  final bool isMultipleSelection;
  final bool showMultiple;
  final TextStyle? labelStyle;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? iconColor;
  final IconData? icon;
  final String selectOptionText;
  final double? height; // Added height parameter

  const MyDialogDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.options,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.initialSelectedValues,
    this.isMultipleSelection = false,
    this.showMultiple = false,
    this.labelStyle,
    this.backgroundColor = MyColors.activeBlue,
    this.borderRadius,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.iconColor,
    this.icon = Icons.arrow_drop_down,
    this.selectOptionText = 'Select Option',
    this.height,
  }) : assert(
  (isMultipleSelection && onMultipleChanged != null) ||
      (!isMultipleSelection && onSingleChanged != null),
  "Provide onMultipleChanged for multiple selection, onSingleChanged otherwise.",
  );

  @override
  State<MyDialogDropdown> createState() => _MyDialogDropdownState();
}

class _MyDialogDropdownState extends State<MyDialogDropdown> {
  late final SchoolDialogDropdownController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      SchoolDialogDropdownController(
        hintText: widget.labelText,
        options: widget.options,
        onSingleChanged: widget.onSingleChanged,
        onMultipleChanged: widget.onMultipleChanged,
        initialValues: widget.initialSelectedValues,
        isMultipleSelection: widget.isMultipleSelection,
      ),
      tag: widget.labelText,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<SchoolDialogDropdownController>(
        tag: widget.labelText)) {
      Get.delete<SchoolDialogDropdownController>(tag: widget.labelText);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: widget.labelStyle ??
                MyTextStyles.inputLabel,
          ),
        if (widget.labelText != null) const SizedBox(height: 6),
        InkWell(
          onTap: () => _showOptionsDialog(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.height ?? 0,  // Use height parameter here
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(MySizes.sm),
                color: widget.backgroundColor.withOpacity(0.1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Obx(
                    () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          ),
                          children: [
                            TextSpan(
                              text: controller.selectedValues.isEmpty
                                  ? widget.selectOptionText
                                  : _getDisplayText(),
                              style: controller.selectedValues.isEmpty
                                  ? MyTextStyles.placeholder
                                  : MyTextStyles.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: MySizes.sm),
                    Icon(
                      widget.icon,
                      color: widget.iconColor ?? MyColors.iconColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (widget.isMultipleSelection) {
      if (controller.selectedValues.length > 1) {
        if (widget.showMultiple) {
          return 'Multiple';
        } else {
          return controller.selectedValues.join(', ');
        }
      } else {
        return controller.selectedValues.first;
      }
    } else {
      return controller.selectedValues.first;
    }
  }

  Future<void> _showOptionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Options',
              style: MyTextStyles.headlineSmall),
          content: SingleChildScrollView(child: Obx(() => _buildChips(context))),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: controller.options.map((option) {
        final isSelected = controller.selectedValues.contains(option);
        return FilterChip(
          side: BorderSide(
            width: 1,
            color: isSelected ? MyColors.activeBlue : Colors.transparent,
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          label: Text(option,
              style: isSelected
                  ? widget.selectedTextStyle ?? const TextStyle(
                  color: MyColors.activeBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)
                  : widget.unselectedTextStyle ?? const TextStyle(
                  color: MyColors.subtitleTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 13)),
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(
              horizontal: MySizes.sm, vertical: MySizes.sm - 4),
          selectedColor: MyColors.activeBlue.withOpacity(0.2),
          backgroundColor: Colors.grey[200],
          checkmarkColor: MyColors.activeBlue,
          selected: isSelected,
          onSelected: (bool selected) {
            List<String> newValues = List.from(controller.selectedValues);
            if (selected) {
              if (!widget.isMultipleSelection) {
                newValues.clear();
              }
              newValues.add(option);
            } else {
              newValues.remove(option);
            }
            if (Get.isRegistered<SchoolDialogDropdownController>(
                tag: widget.labelText)) {
              controller.setSelectedValues(newValues);
            }
          },
        );
      }).toList(),
    );
  }
}