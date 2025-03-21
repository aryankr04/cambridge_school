import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dynamic_colors.dart';

class MyStepper extends StatelessWidget {
  final int noOfSteps;
  final int activeStep;

  const MyStepper({
    super.key,
    required this.activeStep,
    required this.noOfSteps,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Ensure horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          noOfSteps,
              (index) => _buildStep(context, index),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int index) {
    final isActive = activeStep == index;
    final isCompleted = activeStep > index;

    return Row(
      mainAxisSize: MainAxisSize.min, // Important: Use min size to avoid expanding unnecessary
      children: [
        // Use a ternary operator for concise conditional rendering.

             Container(
          width: MySizes.lg,
          height: MySizes.lg,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? MyDynamicColors.activeGreen
                : isActive
                ? MyDynamicColors.activeBlue
                : MyDynamicColors.softGrey,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            )
                : Text(
              '${index + 1}',
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : MyDynamicColors.subtitleTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (index < noOfSteps - 1) _buildLine(isCompleted),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Container(
      width: 20,
      height: 4,
      color: isCompleted ? MyDynamicColors.activeGreen : Colors.grey[300],
    );
  }
}