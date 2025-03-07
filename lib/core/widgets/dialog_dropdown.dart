import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

enum DropdownOptionType {
  Chip,
  Icon,
  IconWithDescription,
}

enum DropdownType {
  Dropdown,
  DialogDropdown,
}

enum DropdownWidgetType {
  General,
  Filter,
}

class MyDialogDropdownController extends GetxController {
  final String? hintText;
  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final bool isMultipleSelection;
  final bool showAllOption;

  RxList<String> options = <String>[].obs;
  RxList<String> selectedValues = <String>[].obs;
  RxString errorText = RxString('');

  List<String>? _initialValues;

  MyDialogDropdownController({
    this.hintText,
    required List<String> options,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.isMultipleSelection = true,
    this.showAllOption = false,
    List<String>? initialValues,
  }) : assert(
  (isMultipleSelection && onMultipleChanged != null) ||
      (!isMultipleSelection && onSingleChanged != null),
  "Provide onMultipleChanged for multiple selection, onSingleChanged otherwise.",
  ) {
    _initialValues = initialValues;
    this.options.addAll(options);
    selectedValues.clear();
    if (_initialValues != null) {
      selectedValues.addAll(_initialValues!);
    }

    if (showAllOption && isMultipleSelection) {
      this.options.insert(0, 'All');
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
      values = values.take(1).toList(); // Ensure only one value is selected
    }

    selectedValues.assignAll(values);

    if (isMultipleSelection) {
      // Simplify the "All" logic
      if (selectedValues.contains('All')) {
        onMultipleChanged?.call(['All']);
      } else {
        onMultipleChanged?.call(selectedValues.toList()); // Pass a copy
      }
    } else {
      onSingleChanged
          ?.call(selectedValues.isNotEmpty ? selectedValues.first : null);
    }
    validate();
  }

  bool isOptionSelected(String option) => selectedValues.contains(option);

  void validate() {
    if (options.isNotEmpty) {
      final isValid = selectedValues.isNotEmpty;
      errorText.value = isValid
          ? ''
          : isMultipleSelection
          ? 'Please select at least one option'
          : 'Please select an option';
    } else {
      errorText.value = 'No options available';
    }
  }
}

class MyDialogDropdown extends StatefulWidget {
  final DropdownOptionType dropdownOptionType;
  final DropdownType dropdownType;
  final DropdownWidgetType dropdownWidgetType;

  final List<String>? initialSelectedValues;

  final bool isMultipleSelection;
  final bool isValid;

  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;

  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;

  final List<Map<String, dynamic>> optionsForIconWithDescription;
  final List<Map<String, IconData>> optionsForIcon;
  final List<String> optionsForChips;

  final bool showAllOption;
  final bool showMultiple;

  const MyDialogDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.optionsForChips,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.initialSelectedValues,
    this.isMultipleSelection = false,
    this.showMultiple = false,
    this.labelStyle,
    this.isValid = false,
    this.showAllOption = false,
    this.dropdownOptionType = DropdownOptionType.Chip,
    this.dropdownType = DropdownType.DialogDropdown,
    this.optionsForIcon = const [], // Initialize with an empty list
    this.optionsForIconWithDescription =
    const [], // Initialize with an empty list
    this.dropdownWidgetType = DropdownWidgetType.General,
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
    controller = Get.put(
      MyDialogDropdownController(
        hintText: widget.hintText ?? widget.labelText, // Use hintText if available, otherwise labelText
        options: widget.optionsForChips,
        onSingleChanged: widget.onSingleChanged,
        onMultipleChanged: widget.onMultipleChanged,
        initialValues: widget.initialSelectedValues,
        isMultipleSelection: widget.isMultipleSelection,
        showAllOption: widget.showAllOption,
      ),
      tag: uniqueTag,
    );

    controller.validate();
  }

  @override
  void dispose() {
    Get.delete<MyDialogDropdownController>(tag: uniqueTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: widget.labelStyle ?? MyTextStyles.inputLabel,
          ),
          const SizedBox(height: 6),
        ],
        GestureDetector(
          onTap: () => _showOptionsDialog(context),
          child: Container(
            decoration: _getDefaultDecoration(widget.dropdownWidgetType),
            child: Container(
              decoration: BoxDecoration(
                border: (widget.isValid && controller.errorText.isNotEmpty)
                    ? Border.all(color: Colors.red)
                    : null,
              ),
              padding: widget.dropdownWidgetType == DropdownWidgetType.General
                  ? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10)
                  : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => Text(
                      controller.selectedValues.isEmpty
                          ? widget.hintText ?? 'Select Option' //show hint text
                          : _getDisplayText(),
                      style: controller.selectedValues.isEmpty
                          ? (widget.dropdownWidgetType == DropdownWidgetType.Filter?MyTextStyles.inputField:MyTextStyles.placeholder)
                          : MyTextStyles.inputField,
                      maxLines: (widget.dropdownWidgetType == DropdownWidgetType.Filter)?1:null,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  const SizedBox(width: MySizes.sm),
                  const Icon(Icons.arrow_drop_down_outlined,
                      color: MyColors.iconColor),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
          visible: widget.isValid && controller.errorText.isNotEmpty,
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

  // Helper function to get default container decoration for each dropdown type
  BoxDecoration _getDefaultDecoration(DropdownWidgetType type) {
    switch (type) {
      case DropdownWidgetType.General:
        return BoxDecoration(
          color: MyColors.activeBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        );

      case DropdownWidgetType.Filter:
        return BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyColors.iconColor),
          borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
        );
    }
  }

  String _getDisplayText() {
    if (widget.isMultipleSelection) {
      if (controller.selectedValues.contains('All')) {
        return 'All';
      }
      if (controller.selectedValues.length > 1) {
        return widget.showMultiple
            ? 'Multiple'
            : controller.selectedValues.join(', ');
      } else if (controller.selectedValues.isNotEmpty) {
        return controller.selectedValues.first;
      }
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    }
    return ''; // Return an empty string if nothing is selected.
  }

  Future<void> _showOptionsDialog(BuildContext context) async {
    switch (widget.dropdownOptionType) {
      case DropdownOptionType.Chip:
        _showFilterChipDialog(context);
        break;
      case DropdownOptionType.Icon:
        _showIconDialog(context);
        break;
      case DropdownOptionType.IconWithDescription:
        _showIconWithDescriptionDialog(context); // Call new method
        break;
    }
  }

  // Icon With Description Dialog
  Future<void> _showIconWithDescriptionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          const Text('Select Options', style: MyTextStyles.headlineSmall),
          content: SingleChildScrollView(
            child: Column(
              children: widget.optionsForIconWithDescription.map((item) {
                final title = item['title'] as String;
                final description = item['description'] as String;
                final icon = item['icon'] as IconData;

                return ListTile(
                  leading: Icon(icon),
                  title: Text(title),
                  subtitle: Text(description),
                  onTap: () {
                    controller.setSelectedValues(
                        [title]); // or whatever you want to pass
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Filter Chip Dialog
  Future<void> _showFilterChipDialog(BuildContext context) async {
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
                  final isSelected = controller.isOptionSelected(option);
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
                            ? const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)
                            : const TextStyle(
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
                          if (option == 'All' && widget.isMultipleSelection) {
                            controller.selectedValues.clear();
                            controller.selectedValues.add('All');
                          } else {
                            controller.selectedValues.add(option);
                          }
                        } else {
                          if (option == 'All' && widget.isMultipleSelection) {
                            controller.selectedValues.clear();
                          } else {
                            controller.selectedValues.remove(option);
                            controller.selectedValues.remove('All');
                          }
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
                final selectedValues =
                controller.selectedValues.toList(); //Create a copy
                if (selectedValues.contains('All')) {
                  controller.setSelectedValues(['All']);
                } else {
                  controller.setSelectedValues(selectedValues);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Accordion Dialog
  Future<void> _showIconDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          const Text('Select Options', style: MyTextStyles.headlineSmall),
          content: SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  // You might want to manage expansion state per item
                  // but for this simple example, we will always keep it open
                });
              },
              children: widget.optionsForChips.map((option) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(option),
                    );
                  },
                  body: ListTile(
                    title: Text('Details for $option'),
                    onTap: () {
                      controller.setSelectedValues([option]);
                      Navigator.of(context).pop();
                    },
                  ),
                  isExpanded: true, // Always expanded for simplicity
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}