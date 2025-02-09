import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double thumbSize;

  const MySlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.label = '',
    this.activeColor = MyColors.activeBlue,
    this.inactiveColor = MyColors.grey,
    this.thumbColor = MyColors.activeBlue,
    this.thumbSize = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: inactiveColor,
            thumbColor: thumbColor,
            overlayColor: thumbColor.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbSize),
            trackHeight: 3,
            overlayShape: RoundSliderOverlayShape(overlayRadius: thumbSize * 2),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
          ),
        ),
        // Displaying the value of the slider below it (optional)
        Text(
          value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
