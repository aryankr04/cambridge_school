import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

class MyDatePickerField extends StatelessWidget {
  final Rx<DateTime?> selectedDate;
  final DateTime? initialDate; // Make initialDate optional
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateChanged;
  final String? labelText;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final EdgeInsets padding;

  const MyDatePickerField({
    super.key,
    required this.selectedDate,
    this.initialDate, // Changed to optional
    required this.firstDate,
    required this.lastDate,
    this.onDateChanged,
    this.labelText,
    this.hintText,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.suffixIcon,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: MyTextStyle.inputLabel,
          ),
          const SizedBox(height: 6),
        ],
        Padding(
          // padding: const EdgeInsets.only(bottom: MySizes.md),
          padding: EdgeInsets.zero,

          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: hintText,
                border: border,
                suffixIcon: suffixIcon ?? const Icon(Icons.calendar_month),
                prefixIcon: prefixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: MyDynamicColors.primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
                  borderSide: BorderSide(
                    width: 1,
                    color: MyDynamicColors.activeRed,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
                  borderSide: BorderSide(
                    width: 2,
                    color: MyDynamicColors.activeRed,
                  ),
                ),
              ),
              child: Obx(() => Text(
                    selectedDate.value != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
                        : hintText ?? 'Select Date',
                    style: selectedDate.value != null
                        ? textStyle ?? MyTextStyle.inputField
                        : hintStyle ?? MyTextStyle.placeholder,
                    textAlign: textAlign,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // CLAMP THE INITIAL DATE to be within the valid range.  THIS IS CRITICAL!
    DateTime safeInitialDate = firstDate; //Default to firstDate

    if (initialDate != null) {
      safeInitialDate = initialDate!;
    }
    if (initialDate != null && initialDate!.isBefore(firstDate)) {
      safeInitialDate = firstDate;
    } else if (initialDate != null && initialDate!.isAfter(lastDate)) {
      safeInitialDate = lastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      // USE safeInitialDate HERE!  This prevents the crash!
      initialDate: selectedDate.value ?? safeInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      if (onDateChanged != null) {
        onDateChanged!(picked);
      }
    }
  }
}
