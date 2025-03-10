import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/constants/text_styles.dart';

class MyTimePickerField extends StatelessWidget {
  final Rx<TimeOfDay?> selectedTime;
  final TimeOfDay? initialTime; // Make initialTime optional
  final ValueChanged<TimeOfDay?>? onTimeChanged;
  final String? labelText;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final EdgeInsets padding;

  const MyTimePickerField({
    super.key,
    required this.selectedTime,
    this.initialTime, // No longer required
    this.onTimeChanged,
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
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () => _selectTime(context),
            child: InputDecorator(
              decoration: InputDecoration(

                labelText: labelText,
                hintText: hintText,
                border: border,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: suffixIcon ?? const Icon(Icons.access_time),
                prefixIcon: prefixIcon,
              ),
              child: Obx(() => Text(
                    selectedTime.value != null
                        ? formatTimeOfDay(
                            selectedTime.value!)
                        : hintText ?? 'Select Time',
                    style: selectedTime.value != null
                        ? textStyle ?? MyTextStyle.inputField
                        : hintStyle??MyTextStyle.placeholder,
                    textAlign: textAlign,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ??
          initialTime ??
          TimeOfDay.now(), // Provide default if initialTime is null
    );

    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
      if (onTimeChanged != null) {
        onTimeChanged!(picked);
      }
    }
  }
}
