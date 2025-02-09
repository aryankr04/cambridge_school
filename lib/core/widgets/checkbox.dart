import 'package:flutter/material.dart';

// Enum for checkbox state
enum CheckboxState { checked, unchecked, indeterminate }

class MyCheckbox extends StatelessWidget {
  final CheckboxState checkboxState; // State of the checkbox (checked, unchecked, indeterminate)
  final ValueChanged<CheckboxState> onChanged; // Callback when the checkbox state changes
  final double size; // Size of the checkbox
  final Color checkedColor; // Color of the checkbox when checked
  final Color uncheckedColor; // Color of the checkbox when unchecked
  final Color borderColor; // Border color of the checkbox
  final Color fillColor; // Background color of the checkbox
  final BorderRadius borderRadius; // Border radius for rounded corners
  final Widget? icon; // Custom icon for checked or unchecked state

  const MyCheckbox({
    super.key,
    required this.checkboxState,
    required this.onChanged,
    this.size = 24.0,
    this.checkedColor = Colors.blue,
    this.uncheckedColor = Colors.grey,
    this.borderColor = Colors.black,
    this.fillColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color of the checkbox based on its state
    Color boxColor;
    Widget? checkIcon;

    switch (checkboxState) {
      case CheckboxState.checked:
        boxColor = checkedColor;
        checkIcon = icon ??
            Icon(
              Icons.check,
              color: fillColor,
              size: size * 0.6,
            );
        break;
      case CheckboxState.unchecked:
        boxColor = uncheckedColor;
        checkIcon = null;
        break;
      case CheckboxState.indeterminate:
        boxColor = uncheckedColor;
        checkIcon = Icon(
          Icons.remove,
          color: fillColor,
          size: size * 0.6,
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        // Cycle through the checkbox states on tap
        CheckboxState newState;
        if (checkboxState == CheckboxState.checked) {
          newState = CheckboxState.unchecked;
        } else if (checkboxState == CheckboxState.unchecked) {
          newState = CheckboxState.indeterminate;
        } else {
          newState = CheckboxState.checked;
        }
        onChanged(newState); // Trigger callback with new state
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: checkIcon == null
            ? null
            : Center(child: checkIcon),
      ),
    );
  }
}
