import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';

enum DropdownOptionType { chip, icon, iconWithDescription }

enum DropdownType { dropdown, bottomSheetDropdown }

enum DropdownWidgetType { general, filter, choiceChip }

class MyBottomSheetDropdownController extends GetxController {
  final String? hintText;
  final Function(String)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final bool isMultipleSelection;
  final bool showAllOption;
  final String tag;

  RxList<String> options = <String>[].obs; // Make this an RxList
  RxList<String> selectedValues = <String>[].obs;
  RxString errorText = RxString('');
  Rx<String> selectedValue = Rx<String>('');

  List<String>? _initialValues;
  final Rx<String> initialSelectedValue;

  MyBottomSheetDropdownController({
    this.hintText,
    required List<String> options,
    this.onSingleChanged,
    this.onMultipleChanged,
    this.isMultipleSelection = true,
    this.showAllOption = false,
    String? initialSelectedValuePassed,
    List<String>? initialValues,
    required this.tag,
  })  : initialSelectedValue = Rx<String>(initialSelectedValuePassed ?? ''),
        assert(
        (isMultipleSelection && onMultipleChanged != null) ||
            (!isMultipleSelection && onSingleChanged != null),
        "Provide onMultipleChanged for multiple selection, onSingleChanged otherwise.",
        ) {
    selectedValue.value = initialSelectedValue.value;
    _initialValues = initialValues;
    this.options.addAll(options);
    selectedValues.clear();

    if (initialSelectedValue.value.isNotEmpty) {
      selectedValue.value = initialSelectedValue.value;
      selectedValues.add(initialSelectedValue.value);
    } else if (_initialValues != null) {
      selectedValues.addAll(_initialValues!);
      if (!isMultipleSelection && _initialValues!.isNotEmpty) {
        selectedValue.value = _initialValues!.first;
      }
    }

    if (showAllOption && isMultipleSelection) {
      this.options.insert(0, 'All');
    }

    initialSelectedValue.listen((newValue) {
      selectedValue.value = newValue;
      if (!isMultipleSelection) {
        selectedValues.clear();
        if (newValue.isNotEmpty) {
          selectedValues.add(newValue);
        }
      }
    });
  }

  List<String>? get initialValues => _initialValues;

  set initialValues(List<String>? value) {
    _initialValues = value;
    selectedValues.clear();

    if (initialSelectedValue.value.isNotEmpty) {
      selectedValue.value = initialSelectedValue.value;
      selectedValues.add(initialSelectedValue.value);
    } else {
      selectedValues.addAll(_initialValues ?? []);

      if (!isMultipleSelection) {
        if (value != null && value.isNotEmpty) {
          selectedValue.value = value.first;
        } else {
          selectedValue.value = '';
        }
      }
    }
  }

  void setSelectedValues(List<String> values) {
    if (!isMultipleSelection) {
      values = values.take(1).toList();
    }

    selectedValues.assignAll(values);

    if (isMultipleSelection) {
      onMultipleChanged?.call(selectedValues.toList());
    } else {
      selectedValue.value =
      selectedValues.isNotEmpty ? selectedValues.first : '';
      onSingleChanged?.call(selectedValue.value);
    }
    validate();
  }

  bool isOptionSelected(String option) => selectedValues.contains(option);

  void validate() {
    if (options.isNotEmpty) {
      final isValid = selectedValues.isNotEmpty ||
          (!isMultipleSelection && selectedValue.value.isNotEmpty);
      errorText.value = isValid
          ? ''
          : isMultipleSelection
          ? 'Please select at least one option'
          : 'Please select an option';
    } else {
      errorText.value = 'No options available';
    }
  }

  @override
  void onClose() {
    print('Controller with tag $tag is being closed');
    super.onClose();
  }
}

class MyBottomSheetDropdown extends StatefulWidget {
  final DropdownOptionType dropdownOptionType;
  final DropdownType dropdownType;
  final DropdownWidgetType dropdownWidgetType;
  final Rx<String>? selectedValue;
  final List<String>? initialSelectedValues;
  final bool isMultipleSelection;
  final bool isValid;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final Function(String)? onSingleChanged;
  final Function(List<String>?)? onMultipleChanged;
  final List<Map<String, dynamic>> optionsForIconWithDescription;
  final List<Map<String, IconData>> optionsForIcon;
  final List<String> optionsForChips;
  final bool showAllOption;
  final bool showMultiple;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const MyBottomSheetDropdown({
    super.key,
    this.selectedValue,
    this.labelText,
    this.hintText,
    this.optionsForChips = const [],
    this.onSingleChanged,
    this.onMultipleChanged,
    this.initialSelectedValues,
    this.isMultipleSelection = false,
    this.showMultiple = false,
    this.labelStyle,
    this.isValid = false,
    this.showAllOption = false,
    this.dropdownOptionType = DropdownOptionType.chip,
    this.dropdownType = DropdownType.bottomSheetDropdown,
    this.optionsForIcon = const [],
    this.optionsForIconWithDescription = const [],
    this.dropdownWidgetType = DropdownWidgetType.general,
    this.prefixIcon,
    this.suffixIcon,
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
        options: widget.optionsForChips,
        onSingleChanged: widget.onSingleChanged,
        onMultipleChanged: widget.onMultipleChanged,
        initialValues: widget.initialSelectedValues,
        isMultipleSelection: widget.isMultipleSelection,
        showAllOption: widget.showAllOption,
        initialSelectedValuePassed: widget.selectedValue?.value,
        tag: uniqueTag,
      ),
      tag: uniqueTag,
    );

    controller.validate();
  }

  @override
  void didUpdateWidget(covariant MyBottomSheetDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.optionsForChips != oldWidget.optionsForChips) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.options.assignAll(widget.optionsForChips);

        // Filter selectedValues to remove invalid options
        controller.selectedValues
            .removeWhere((value) => !controller.options.contains(value));

        controller.validate(); // Revalidate after filtering
      });
    }

    if (widget.selectedValue != null &&
        oldWidget.selectedValue != widget.selectedValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.initialSelectedValue.value =
            widget.selectedValue?.value ?? '';
      });
    }
  }

  @override
  void dispose() {
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
        Padding(
          padding: const EdgeInsets.only(bottom: MySizes.md),
          child: _buildDropdownContainer(),
        ),
        Obx(
              () => Visibility(
            visible: widget.isValid && controller.errorText.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                controller.errorText.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownContainer() {
    switch (widget.dropdownWidgetType) {
      case DropdownWidgetType.general:
        return GeneralDropdownContainer(
          hintText: widget.hintText ?? 'Select ${widget.labelText}',
          controller: controller,
          onTap: () {
            // Show the bottom sheet using Obx
            _showOptionsBottomSheet(context);
          },
          showMultiple: widget.showMultiple,
          isValid: widget.isValid,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        );
      case DropdownWidgetType.filter:
        return FilterDropdownContainer(
          hintText: widget.hintText ?? 'Select ${widget.labelText}',
          controller: controller,
          onTap: () {
            // Show the bottom sheet using Obx
            _showOptionsBottomSheet(context);
          },
          showMultiple: widget.showMultiple,
          isValid: widget.isValid,
        );
      case DropdownWidgetType.choiceChip:
        return ChoiceChipDropdownContainer(
          hintText: widget.hintText ?? 'Select ${widget.labelText}',
          controller: controller,
        );
    }
  }

  // Helper method to show the bottom sheet with options
  Future<void> _showOptionsBottomSheet(BuildContext context) async {
    switch (widget.dropdownOptionType) {
      case DropdownOptionType.chip:
        _showFilterChipBottomSheet(context);
        break;
      case DropdownOptionType.icon:
        _showIconBottomSheet(context);
        break;
      case DropdownOptionType.iconWithDescription:
        _showIconWithDescriptionBottomSheet(context);
        break;
    }
  }

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
                  child: Text(
                    'Select ${widget.labelText}',
                    style: MyTextStyle.headlineSmall.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {},
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
                            if (!widget.isMultipleSelection) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        isExpanded: true,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.isMultipleSelection)
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

  Future<void> _showIconWithDescriptionBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select ${widget.labelText}',
                    style: MyTextStyle.headlineSmall.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.optionsForIconWithDescription.map((item) {
                  final title = item['title'] as String;
                  final description = item['description'] as String;
                  final icon = item['icon'] as IconData;
                  final isSelected = controller.isOptionSelected(title);

                  return GestureDetector(
                    onTap: () {
                      if (!widget.isMultipleSelection) {
                        controller.selectedValues.clear();
                      }
                      isSelected
                          ? controller.selectedValues.remove(title)
                          : controller.selectedValues.add(title);

                      controller.setSelectedValues(
                          List.of(controller.selectedValues));
                      if (!widget.isMultipleSelection)
                        Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: MySizes.sm + 4, vertical: MySizes.sm),
                      margin: const EdgeInsets.only(bottom: MySizes.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? MyColors.activeBlue.withOpacity(0.1)
                            : MyDynamicColors.backgroundColorGreyLightGrey,
                        borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusSm),
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? MyColors.activeBlue
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icon,
                              color: isSelected
                                  ? MyColors.activeBlue
                                  : MyColors.iconColor),
                          const SizedBox(width: MySizes.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: MyTextStyle.bodyLarge.copyWith(
                                    color:
                                    isSelected ? MyColors.activeBlue : null,
                                  ),
                                ),
                                Text(
                                  description,
                                  style: MyTextStyle.labelSmall.copyWith(
                                    color:
                                    isSelected ? MyColors.activeBlue : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                if (widget.isMultipleSelection)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFilterChipBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Obx(() => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                left: MySizes.md, right: MySizes.md, bottom: MySizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select ${widget.labelText ?? widget.hintText}',
                    style: MyTextStyle.headlineSmall.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0 + 4,
                    runSpacing: 8 + 4,
                    children: controller.options.map((option) {
                      final isSelected =
                      controller.isOptionSelected(option);
                      return GestureDetector(
                        onTap: () {
                          if (!widget.isMultipleSelection) {
                            controller.selectedValues.clear();
                          }
                          isSelected
                              ? controller.selectedValues.remove(option)
                              : controller.selectedValues.add(option);

                          controller.setSelectedValues(
                              List.of(controller.selectedValues));

                          if (!widget.isMultipleSelection) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          constraints:
                          BoxConstraints(minWidth: Get.width * 0.12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: MySizes.sm + 4,
                              vertical: MySizes.sm),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? MyColors.activeBlue.withOpacity(0.1)
                                : MyDynamicColors
                                .backgroundColorGreyLightGrey,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              width: 1,
                              color: isSelected
                                  ? MyColors.activeBlue
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            option,
                            style: MyTextStyle.labelLarge.copyWith(
                              color:
                              isSelected ? MyColors.activeBlue : null,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.isMultipleSelection)
                  ElevatedButton(
                    child: const Text('Done'),
                    onPressed: () {
                      final selectedValues =
                      controller.selectedValues.toList();
                      controller.setSelectedValues(selectedValues);

                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ));
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
    this.prefixIcon,
    this.suffixIcon,
  });

  final bool isValid;
  final String hintText;
  final MyBottomSheetDropdownController controller;
  final VoidCallback onTap;
  final bool showMultiple;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

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
              if (prefixIcon != null) ...[
                Icon(prefixIcon, color: MyColors.iconColor, size: 18),
                const SizedBox(width: MySizes.sm),
              ],
              Expanded(
                child: Obx(() {
                  return Text(
                    controller.selectedValues.isEmpty &&
                        controller.selectedValue.value.isEmpty
                        ? hintText
                        : _getDisplayText(controller),
                    style: controller.selectedValues.isEmpty &&
                        controller.selectedValue.value.isEmpty
                        ? MyTextStyle.placeholder
                        : MyTextStyle.inputField,
                    maxLines: null,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: MySizes.sm),
                Icon(suffixIcon, color: MyColors.iconColor, size: 18),
              ],
              const SizedBox(width: MySizes.sm),
              const Icon(Icons.arrow_drop_down_outlined,
                  color: MyColors.iconColor),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText(MyBottomSheetDropdownController controller) {
    if (controller.selectedValues.contains('All')) {
      return 'All';
    }
    if (controller.selectedValues.length > 1) {
      return showMultiple ? 'Multiple' : controller.selectedValues.join(', ');
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    } else {
      return controller.selectedValue.value;
    }
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
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Obx(() {
                    return Text(
                      (controller.selectedValues.isEmpty &&
                          controller.selectedValue.value.isEmpty)
                          ? hintText
                          : _getDisplayText(controller),
                      style: MyTextStyle.inputField
                          .copyWith(color: MyColors.subtitleTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
                const Icon(Icons.arrow_drop_down_outlined,
                    color: MyColors.subtitleTextColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayText(MyBottomSheetDropdownController controller) {
    if (controller.selectedValues.contains('All')) {
      return 'All';
    }
    if (controller.selectedValues.length > 1) {
      return showMultiple ? 'Multiple' : controller.selectedValues.join(', ');
    } else if (controller.selectedValues.isNotEmpty) {
      return controller.selectedValues.first;
    } else {
      return controller.selectedValue.value;
    }
  }
}

class ChoiceChipDropdownContainer extends StatelessWidget {
  const ChoiceChipDropdownContainer({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final MyBottomSheetDropdownController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SingleChildScrollView(
        child: Wrap(
          spacing: 8.0 + 4,
          runSpacing: 8 + 4,
          children: controller.options.map((option) {
            final isSelected = controller.isOptionSelected(option);
            return GestureDetector(
              onTap: () {
                if (!controller.isMultipleSelection) {
                  controller.selectedValues.clear();
                }
                isSelected
                    ? controller.selectedValues.remove(option)
                    : controller.selectedValues.add(option);

                controller
                    .setSelectedValues(List.of(controller.selectedValues));
              },
              child: Container(
                constraints: BoxConstraints(minWidth: Get.width * 0.12),
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.sm + 4, vertical: MySizes.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MyColors.activeBlue.withOpacity(0.1)
                      : MyDynamicColors.backgroundColorGreyLightGrey,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    width: 1,
                    color:
                    isSelected ? MyColors.activeBlue : Colors.transparent,
                  ),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  option,
                  style: MyTextStyle.labelLarge.copyWith(
                    color: isSelected ? MyColors.activeBlue : null,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}