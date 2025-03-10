import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/box_shadow.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class MyDropdownField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final List<String> options;
  final Rx<String?>? selectedValue;
  final bool isValidate;
  final void Function(String?)? onSelected;
  final bool enabled;
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
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
    this.decoration,
    required this.options,
    this.selectedValue,
    this.isValidate = false,
    this.onSelected,
    this.enabled = true,
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
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _closeDropdown();
      }
    });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final String defaultHintText = widget.labelText != null
        ? 'Select ${widget.labelText}'
        : 'Select an Option';

    return Focus(
      focusNode: _focusNode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null) ...[
            Text(widget.labelText!, style: MyTextStyle.inputLabel),
            const SizedBox(height: 6),
          ],
          Padding(
            // padding: const EdgeInsets.only(bottom: MySizes.md),
            padding: EdgeInsets.zero,
            child: GestureDetector(
              onTap: () {
                _toggleDropdown();
                _focusNode.requestFocus(); // Request focus when tapped
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: widget.decoration ??
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(MySizes.sm),
                      color: MyColors.activeBlue.withOpacity(0.1),
                    ),
                height: widget.height,
                padding: widget.padding,
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      widget.prefixIcon!,
                      const SizedBox(width: 8.0),
                    ],
                    Expanded(
                      child: Obx(() => Text(
                        (_selectedValue.value != null && _selectedValue.value!.isNotEmpty)
                            ? _selectedValue.value!
                            : widget.hintText ?? defaultHintText,
                        style: _selectedValue.value != null
                            ? widget.selectedTextStyle ?? MyTextStyle.inputField
                            : widget.hintTextStyle ??
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          ),
          Obx(() {
            if (!_isDropdownOpen.value) {
              return const SizedBox.shrink();
            }
            return Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                margin: const EdgeInsets.only(top: 4),
                padding: widget.dropdownPadding,
                decoration: BoxDecoration(
                  color: widget.dropdownBackgroundColor ?? Colors.white,
                  borderRadius:
                  widget.dropdownBorderRadius ?? BorderRadius.circular(4),
                  boxShadow: MyBoxShadows.kMediumShadow,
                ),
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.options.length,
                    itemBuilder: (context, index) {
                      final option = widget.options[index];
                      return Material(
                        color: _selectedValue.value == option
                            ? Colors.lightBlue.withOpacity(0.3)
                            : Colors.transparent,
                        child: InkWell( // Use InkWell for better ripple effect
                          onTap: () {
                            _selectedValue.value = option;
                            widget.onSelected?.call(option);
                            _closeDropdown();
                            _focusNode.unfocus(); //remove the focus from the field after selection
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding as needed
                            child: Text(option),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
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
    );
  }
}