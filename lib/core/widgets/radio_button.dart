import 'package:flutter/material.dart';

// Enum for radio button state
enum RadioButtonState { selected, unselected }

class MyRadioButton extends StatelessWidget {
  final RadioButtonState radioButtonState; // State of the radio button (selected or unselected)
  final ValueChanged<RadioButtonState> onChanged; // Callback when the radio button state changes
  final double size; // Size of the radio button
  final Color selectedColor; // Color of the radio button when selected
  final Color unselectedColor; // Color of the radio button when unselected
  final Color borderColor; // Border color of the radio button
  final Color fillColor; // Background color of the radio button
  final BorderRadius borderRadius; // Border radius for rounded corners
  final Widget? icon; // Custom icon for selected or unselected state

  const MyRadioButton({
    super.key,
    required this.radioButtonState,
    required this.onChanged,
    this.size = 24.0,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.borderColor = Colors.black,
    this.fillColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color and icon of the radio button based on its state
    Color circleColor;
    Widget? radioIcon;

    switch (radioButtonState) {
      case RadioButtonState.selected:
        circleColor = selectedColor;
        radioIcon = icon ??
            Icon(
              Icons.check,
              color: fillColor,
              size: size * 0.6,
            );
        break;
      case RadioButtonState.unselected:
        circleColor = unselectedColor;
        radioIcon = null;
        break;
    }

    return GestureDetector(
      onTap: () {
        // Change the state of the radio button on tap
        radioButtonState == RadioButtonState.selected
            ? onChanged(RadioButtonState.unselected)
            : onChanged(RadioButtonState.selected);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Container(
            height: size * 0.6,
            width: size * 0.6,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: radioIcon == null
                ? null
                : Center(child: radioIcon),
          ),
        ),
      ),
    );
  }
}
