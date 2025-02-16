import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class MyDialogDropdownController extends GetxController {
  final String? hintText;
  RxList<String> options = <String>[].obs;
  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final bool isMultipleSelection;
  RxList<String> selectedValues = <String>[].obs;
  List<String>? _initialValues;
  RxString errorText = RxString('');

  MyDialogDropdownController({
    this.hintText,
    required List<String> options,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.isMultipleSelection = true,
    List<String>? initialValues,
  })  : assert(
          (isMultipleSelection && onMultipleChanged != null) ||
              (!isMultipleSelection && onSingleChanged != null),
          "Provide onMultipleChanged for multiple selection, onSingleChanged otherwise.",
        ),
        super() {
    _initialValues = initialValues;
    this.options.addAll(options);
    selectedValues.clear();
    if (_initialValues != null) {
      selectedValues.addAll(_initialValues!);
    }
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
      onMultipleChanged?.call(List<String>.from(selectedValues));
    } else {
      onSingleChanged
          ?.call(selectedValues.isNotEmpty ? selectedValues.first : null);
    }
    validate(); // Call validate after updating selectedValues
  }

  bool isOptionSelected(String option) {
    return selectedValues.contains(option);
  }

  void validate() {
    if (options.isNotEmpty) {
      if (isMultipleSelection) {
        if (selectedValues.isEmpty) {
          errorText.value = 'Please select at least one option';
        } else {
          errorText.value = '';
        }
      } else {
        if (selectedValues.isEmpty) {
          errorText.value = 'Please select an option';
        } else {
          errorText.value = '';
        }
      }
    } else {
      errorText.value = 'No options available';
    }
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
  final bool isValid; // Add isValid field for conditional styling

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
    this.isValid = true, // Default to true
  });

  @override
  State<MyDialogDropdown> createState() => _MyDialogDropdownState();
}

class _MyDialogDropdownState extends State<MyDialogDropdown> {
  late final MyDialogDropdownController controller;
  final String uniqueTag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    // Initialize the controller locally
    controller = Get.put(
      MyDialogDropdownController(
        hintText: widget.labelText,
        options: widget.options,
        onSingleChanged: widget.onSingleChanged,
        onMultipleChanged: widget.onMultipleChanged,
        initialValues: widget.initialSelectedValues,
        isMultipleSelection: widget.isMultipleSelection,
      ),
      tag: uniqueTag, // Use a unique tag for each instance
    );

    //Initial validation after setting up
    controller.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: widget.labelStyle ?? MyTextStyles.inputLabel,
          ),
        if (widget.labelText != null) const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            await _showOptionsDialog(context);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.height ?? 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(MySizes.sm),
                color: widget.backgroundColor.withOpacity(0.1),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: (widget.isValid &&
                            controller.errorText.value.isNotEmpty)
                        ? Border.all(color: Colors.red)
                        : null),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Obx(() => RichText(
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
                          )),
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
        Obx(() => Visibility(
              visible: widget.isValid && controller.errorText.value.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  controller.errorText.value,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
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
      } else if (controller.selectedValues.isNotEmpty) {
        return controller.selectedValues.first;
      } else {
        return widget.selectOptionText;
      }
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    } else {
      return widget.selectOptionText;
    }
  }

  Future<void> _showOptionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Select Options', style: MyTextStyles.headlineSmall),
          content: Obx(
            () => SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                children: controller.options.map((option) {
                  final isSelected = controller.selectedValues.contains(option);
                  return FilterChip(
                    side: BorderSide(
                      width: 1,
                      color:
                          isSelected ? MyColors.activeBlue : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    label: Text(option,
                        style: isSelected
                            ? widget.selectedTextStyle ??
                                const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)
                            : widget.unselectedTextStyle ??
                                const TextStyle(
                                    color: MyColors.subtitleTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13)),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                        horizontal: MySizes.sm, vertical: MySizes.sm - 4),
                    selectedColor: MyColors.activeBlue,
                    backgroundColor:
                        isSelected ? MyColors.activeBlue : Colors.grey[200],
                    checkmarkColor: MyColors.activeBlue,
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          if (!widget.isMultipleSelection) {
                            controller.selectedValues.clear();
                          }
                          controller.selectedValues.add(option);
                        } else {
                          controller.selectedValues.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                controller
                    .setSelectedValues(controller.selectedValues.toList());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
