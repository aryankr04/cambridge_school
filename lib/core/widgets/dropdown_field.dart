import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/box_shadow.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class MyDropdownField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final List<String> options;
  final Rx<String?>? selectedValue;
  final bool isValidate;
  final void Function(String?)? onSelected;
  final bool enabled;
  final double? height;
  final TextStyle? selectedTextStyle;
  final TextStyle? hintTextStyle;
  final Color? dropdownBackgroundColor;
  final BorderRadius? dropdownBorderRadius;
  final EdgeInsetsGeometry? dropdownPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? arrowColor;

  const MyDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
    this.decoration,
    required this.options,
    this.selectedValue,
    this.isValidate = false,
    this.onSelected,
    this.enabled = true,
    this.height,
    this.selectedTextStyle,
    this.hintTextStyle,
    this.dropdownBackgroundColor,
    this.dropdownBorderRadius,
    this.dropdownPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.arrowColor,
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  final RxBool _isDropdownOpen = false.obs;
  late Rx<String?> _selectedValue;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue ?? Rx<String?>(null);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (widget.enabled) {
      _isDropdownOpen.toggle();
    }
  }

  void _closeDropdown() {
    if (_isDropdownOpen.value) {
      _isDropdownOpen.value = false;
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String defaultHintText = widget.labelText != null
        ? 'Select ${widget.labelText}'
        : 'Select an Option';

    return Focus(
      focusNode: _focusNode,
      child: Padding(
        padding: const EdgeInsets.only(bottom: MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Text(widget.labelText!, style: MyTextStyle.inputLabel),
              const SizedBox(height: 6),
            ],
            GestureDetector(
              onTap: widget.enabled
                  ? () {
                _toggleDropdown();
              }
                  : null,
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: widget.decoration ??
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(MySizes.sm),
                      color: MyColors.activeBlue.withOpacity(0.1),
                    ),
                padding: widget.padding,
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      widget.prefixIcon!,
                      const SizedBox(width: 8.0),
                    ],
                    Expanded(
                      child: Obx(() => Text(
                        (_selectedValue.value != null &&
                            _selectedValue.value!.isNotEmpty)
                            ? _selectedValue.value!
                            : widget.hintText ?? defaultHintText,
                        style: (_selectedValue.value != null &&
                            _selectedValue.value!.isNotEmpty)
                            ? widget.selectedTextStyle ??
                            MyTextStyle.inputField
                            : widget.hintTextStyle ??
                            Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: MyColors.placeholderColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    if (widget.suffixIcon != null) ...[
                      const SizedBox(width: 8.0),
                      widget.suffixIcon!,
                    ],
                    Icon(
                      _isDropdownOpen.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: widget.arrowColor,
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (!_isDropdownOpen.value) {
                return const SizedBox.shrink();
              }
              return _buildDropdownOptions();
            }),
            if (widget.isValidate) ...[
              Obx(() {
                if (_selectedValue.value == null && !_isDropdownOpen.value) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Please select a value',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownOptions() {
    return ClipRRect(
      borderRadius: widget.dropdownBorderRadius ?? BorderRadius.circular(4),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(4),
        padding: widget.dropdownPadding,
        decoration: BoxDecoration(
          color: widget.dropdownBackgroundColor ?? Colors.white,
          boxShadow: MyBoxShadows.kMediumShadow,
          borderRadius: widget.dropdownBorderRadius ?? BorderRadius.circular(4),
        ),
        constraints: const BoxConstraints(
            maxHeight: 200,
            maxWidth: double.infinity),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options
                .map((option) => Material(
              color: _selectedValue.value == option
                  ? MyColors.activeBlue.withOpacity(0.1)
                  : Colors.transparent,
              child: InkWell(
                onTap: () {
                  _selectedValue.value = option;
                  widget.onSelected?.call(option);
                  _closeDropdown();
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Text(
                      option,
                      style: _selectedValue.value == option
                          ? MyTextStyle.bodyLarge.copyWith(
                          color: MyColors.activeBlue,
                          fontWeight: FontWeight.bold)
                          : MyTextStyle.bodyMedium,
                    ),
                  ),
                ),
              ),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }
}