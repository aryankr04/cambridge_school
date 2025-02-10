import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';

enum MyIconButtonShape { rectangle, circle }

class MyIconButton extends StatelessWidget {
  final Widget content; // Icon, Image, SVG, or Lottie
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final Color containerColor;
  final Color shadowColor;
  final bool hasShadow;
  final Color borderColor;
  final double borderRadius;
  final double elevation;
  final double padding;
  final MyIconButtonShape shape; // New shape option

  const MyIconButton({
    super.key,
    required this.content,
    required this.text,
    required this.onPressed,
    this.width = 80.0,
    this.height = 80.0,
    this.textStyle,
    this.containerColor = Colors.white,
    this.shadowColor = Colors.black12,
    this.hasShadow = false,
    this.borderColor = MyColors.borderColor,
    this.borderRadius = 12.0,
    this.elevation = 6.0,
    this.padding = 8.0,
    this.shape = MyIconButtonShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: containerColor,
              shape: shape == MyIconButtonShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: shape == MyIconButtonShape.circle
                  ? null
                  : BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: elevation,
                        spreadRadius: 1,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ]
                  : null,
            ),
            child: Center(child: content), // Icon, Image, SVG, or Lottie
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: textStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          )
        ],
      ),
    );
  }
}
