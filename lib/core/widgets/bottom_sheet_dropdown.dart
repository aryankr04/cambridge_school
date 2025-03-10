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
  BottomSheetDropdown,
}

enum DropdownWidgetType {
  General,
  Filter,
}

class MyBottomSheetDropdownController extends GetxController {
  final String? hintText;
  final Function(String?)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final bool isMultipleSelection;
  final bool showAllOption;

  RxList<String> options = <String>[].obs;
  RxList<String> selectedValues = <String>[].obs;
  RxString errorText = RxString('');

  List<String>? _initialValues;

  MyBottomSheetDropdownController({
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

class MyBottomSheetDropdown extends StatefulWidget {
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

  const MyBottomSheetDropdown({
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
    this.dropdownType = DropdownType.BottomSheetDropdown,
    this.optionsForIcon = const [], // Initialize with an empty list
    this.optionsForIconWithDescription =
        const [], // Initialize with an empty list
    this.dropdownWidgetType = DropdownWidgetType.General,
  });

  @override
  State<MyBottomSheetDropdown> createState() => _MyBottomSheetDropdownState();
}

class _MyBottomSheetDropdownState extends State<MyBottomSheetDropdown> {
  late final MyBottomSheetDropdownController controller;
  final String uniqueTag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      MyBottomSheetDropdownController(
        hintText: widget.hintText ?? widget.labelText,
        // Use hintText if available, otherwise labelText
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
    Get.delete<MyBottomSheetDropdownController>(tag: uniqueTag);
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
            style: widget.labelStyle ?? MyTextStyle.inputLabel,
          ),
          const SizedBox(height: 6),
        ],
        _buildDropdownContainer(),
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

  Widget _buildDropdownContainer() {
    switch (widget.dropdownWidgetType) {
      case DropdownWidgetType.General:
        return GeneralDropdownContainer(
          hintText: widget.hintText ?? 'Select Option',
          controller: controller,
          onTap: () => _showOptionsBottomSheet(context),
          showMultiple: widget.showMultiple,
          isValid: widget.isValid,
        );
      case DropdownWidgetType.Filter:
        return FilterDropdownContainer(
          hintText: widget.hintText ?? widget.labelText ?? 'Select',
          controller: controller,
          onTap: () => _showOptionsBottomSheet(context),
          showMultiple: widget.showMultiple,
          isValid: widget.isValid,
        );
    }
  }

  Future<void> _showOptionsBottomSheet(BuildContext context) async {
    switch (widget.dropdownOptionType) {
      case DropdownOptionType.Chip:
        _showFilterChipBottomSheet(context);
        break;
      case DropdownOptionType.Icon:
        _showIconBottomSheet(context);
        break;
      case DropdownOptionType.IconWithDescription:
        _showIconWithDescriptionBottomSheet(context); // Call new method
        break;
    }
  }

  // Icon With Description BottomSheet
  Future<void> _showIconWithDescriptionBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      showDragHandle: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select ${widget.labelText}',
                        style:
                            MyTextStyle.headlineSmall.copyWith(fontSize: 18))),
                const SizedBox(height: 16),
                SingleChildScrollView(
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
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Filter Chip BottomSheet
  Future<void> _showFilterChipBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                left: MySizes.md, right: MySizes.md, bottom: MySizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select ${widget.labelText ?? widget.hintText}',
                        style:
                            MyTextStyle.headlineSmall.copyWith(fontSize: 18))),
                const SizedBox(height: 16),
                Obx(
                  () => SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      children: controller.options.map((option) {
                        final isSelected = controller.isOptionSelected(option);
                        return FilterChip(
                          side: BorderSide(
                            width: 1,
                            color: isSelected
                                ? MyColors.activeBlue
                                : Colors.transparent,
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
                          backgroundColor: isSelected
                              ? MyColors.activeBlue
                              : Colors.grey[200],
                          checkmarkColor: MyColors.activeBlue,
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                if (!widget.isMultipleSelection) {
                                  controller.selectedValues.clear();
                                }
                                if (option == 'All' &&
                                    widget.isMultipleSelection) {
                                  controller.selectedValues.clear();
                                  controller.selectedValues.add('All');
                                } else {
                                  controller.selectedValues.add(option);
                                }
                              } else {
                                if (option == 'All' &&
                                    widget.isMultipleSelection) {
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
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Done'),
                  onPressed: () {
                    final selectedValues =
                        controller.selectedValues.toList(); // Create a copy

                    if (widget.showAllOption && widget.isMultipleSelection) {
                      if (selectedValues.contains('All')) {
                        controller.setSelectedValues(['All']);
                      } else {
                        controller.setSelectedValues(selectedValues);
                      }
                    } else {
                      controller.setSelectedValues(selectedValues);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Accordion BottomSheet
  Future<void> _showIconBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: MySizes.md),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select ${widget.labelText}',
                        style:
                            MyTextStyle.headlineSmall.copyWith(fontSize: 18))),
                const SizedBox(height: 16),
                SingleChildScrollView(
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
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GeneralDropdownContainer extends StatelessWidget {
  const GeneralDropdownContainer({
    super.key,
    required this.isValid,
    required this.hintText,
    required this.controller,
    required this.onTap,
    required this.showMultiple,
  });

  final bool isValid;
  final String hintText;
  final MyBottomSheetDropdownController controller;
  final VoidCallback onTap;
  final bool showMultiple;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.activeBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: (isValid && controller.errorText.isNotEmpty)
                ? Border.all(color: Colors.red)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => Text(
                      controller.selectedValues.isEmpty
                          ? hintText //show hint text
                          : _getDisplayText(),
                      style: controller.selectedValues.isEmpty
                          ? MyTextStyle.placeholder
                          : MyTextStyle.inputField,
                      maxLines: null,
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
    );
  }

  String _getDisplayText() {
    if (controller.selectedValues.contains('All')) {
      return 'All';
    }
    if (controller.selectedValues.length > 1) {
      return showMultiple ? 'Multiple' : controller.selectedValues.join(', ');
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    }
    return ''; // Return an empty string if nothing is selected.
  }
}

class FilterDropdownContainer extends StatelessWidget {
  const FilterDropdownContainer({
    super.key,
    required this.isValid,
    required this.hintText,
    required this.controller,
    required this.onTap,
    required this.showMultiple,
  });

  final bool isValid;
  final String hintText;
  final MyBottomSheetDropdownController controller;
  final VoidCallback onTap;
  final bool showMultiple;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyColors.iconColor),
          borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: (isValid && controller.errorText.isNotEmpty)
                ? Border.all(color: Colors.red)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => Text(
                      controller.selectedValues.isEmpty
                          ? hintText //show hint text
                          : _getDisplayText(),
                      style: controller.selectedValues.isEmpty
                          ? MyTextStyle.inputField
                              .copyWith(color: MyColors.subtitleTextColor)
                          : MyTextStyle.inputField,
                      maxLines: 1,
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
    );
  }

  String _getDisplayText() {
    if (controller.selectedValues.contains('All')) {
      return 'All';
    }
    if (controller.selectedValues.length > 1) {
      return showMultiple ? 'Multiple' : controller.selectedValues.join(', ');
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    }
    return ''; // Return an empty string if nothing is selected.
  }
}
