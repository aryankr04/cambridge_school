import 'package:flutter/material.dart';

import '../../../../core/utils/constants/dynamic_colors.dart';

class SchoolStepper extends StatefulWidget {
  final int noOfSteps;
  final int activeStep;

  const SchoolStepper({
    super.key,
    required this.activeStep,
    required this.noOfSteps,
  });

  @override
  _SchoolStepperState createState() => _SchoolStepperState();
}

class _SchoolStepperState extends State<SchoolStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.noOfSteps,
        (index) => _buildStep(index),
      ),
    );
  }

  Widget _buildStep(int index) {
    final isActive = widget.activeStep == index;
    final isCompleted = widget.activeStep > index;

    return Row(
      children: [
        Container(
          width: 30 - 5,
          height: 30 - 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? MyDynamicColors.primaryColor
                : isActive
                    ? MyDynamicColors.primaryColor
                    : MyDynamicColors.softGrey,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : MyDynamicColors.subtitleTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        if (index < widget.noOfSteps - 1) _buildLine(isCompleted),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: 100,
        ),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Container(
            width: 20,
            height: 4,
            color: isCompleted
                ? MyDynamicColors.primaryColor
                : Colors.grey[300],
          );
        });
  }
}
