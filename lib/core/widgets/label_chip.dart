import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

class MyLabelChip extends StatelessWidget {
  final Color? color;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final String text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? constraints;

  const MyLabelChip({
    super.key,
    this.color,
    this.textSize,
    required this.text,
    this.padding,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon, this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: constraints??const BoxConstraints(minWidth: 32),
          alignment: Alignment.center,
          padding: padding ??
              const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(borderRadius ?? MySizes.cardRadiusXs),
            color: color?.withOpacity(0.1) ??
                MyDynamicColors.backgroundColorGreyLightGrey,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Important for fitting content
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8), // Add some spacing between icon and text
              ],
              Text(
                text,
                style: Theme.of(Get.context!).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontSize: textSize ?? 12.0,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8), // Add some spacing between text and icon
                suffixIcon!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}