import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

class MyTextField extends StatelessWidget {
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final TextStyle? prefixTextStyle;

  final String? suffixText;
  final TextStyle? suffixTextStyle;

  final bool showClearButton;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final bool enabled;
  final bool autoFocus;
  final int? maxLines;
  final TextAlign textAlign;
  final bool readOnly;
  final bool isLoading;
  final Color? errorTextColor;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final double? height;

  const MyTextField({
    super.key,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.prefixTextStyle,
    this.suffixText,
    this.suffixTextStyle,
    this.showClearButton = true,
    this.onClear,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.fillColor,
    this.enabled = true,
    this.autoFocus = false,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.isLoading = false,
    this.errorTextColor = Colors.red,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController finalController =
        controller ?? useControllerWithInitialValue(initialValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          ...[
            Text(
              labelText!,
              style: labelStyle ??
                  MyTextStyles.inputLabel,
            ),
            const SizedBox(height: 6),
          ],
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height ?? 0,
          ),
          child: TextFormField(
            initialValue: initialValue,
            controller: finalController,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            validator: validator,
            autofocus: autoFocus,
            maxLines: maxLines,
            textAlign: textAlign,
            readOnly: readOnly,
            enabled: enabled,
            style: MyTextStyles.inputField,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: (value) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
              onFieldSubmitted?.call(value);
            },
            decoration: InputDecoration(
              isDense: true, // Added to reduce extra padding
              hintText: hintText ?? 'Enter $labelText',
              hintStyle: hintStyle??MyTextStyles.placeholder ,
              fillColor: fillColor,
              contentPadding: padding,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefixText: prefixText,
              prefixStyle: prefixTextStyle,
              suffixText: suffixText,
              suffixStyle: suffixTextStyle
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController useControllerWithInitialValue(String? initialValue) {
    final TextEditingController controller =
    TextEditingController(text: initialValue);

    return controller;
  }
}