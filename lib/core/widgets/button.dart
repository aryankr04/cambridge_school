import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final Icon? icon;
  final bool isLoading;
  final double iconSize;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool isDisabled;
  final BorderSide? borderSide;
  final Gradient? gradient;
  final Color? splashColor;
  final bool hasShadow;
  final bool enableRippleEffect;
  final bool isOutlined;
  final EdgeInsetsGeometry? margin;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 24.0,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    this.iconSize = 20.0,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
    this.elevation = 2.0,
    this.isDisabled = false,
    this.borderSide,
    this.gradient,
    this.splashColor,
    this.hasShadow = true,
    this.enableRippleEffect = true,
    this.isOutlined = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 50.0,
        child: isOutlined
            ? OutlinedButton(
                onPressed: isDisabled ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      textColor ?? (isOutlined ? Colors.black : Colors.white),
                  backgroundColor: Colors.transparent,
                  side: borderSide ??
                      BorderSide(
                          color:
                              isDisabled ? MyColors.borderColor : MyColors.grey,
                          width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  padding: padding,
                  splashFactory: enableRippleEffect
                      ? InkRipple.splashFactory
                      : InkSplash.splashFactory,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: MySizes.lg,
                        width: MySizes.lg,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: Colors.black,
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) icon!,
                          if (icon != null) const SizedBox(width: 8),
                          Text(
                            text,
                            style: textStyle ??
                                TextStyle(
                                  color: isDisabled
                                      ? MyColors.borderColor
                                      : (textColor ??
                                          MyColors.headlineTextColor),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
              )
            : ElevatedButton(
                onPressed: isDisabled ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: textColor ?? Colors.white,
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).primaryColor,
                  disabledForegroundColor: splashColor?.withOpacity(0.38),
                  disabledBackgroundColor: splashColor?.withOpacity(0.12),
                  elevation: hasShadow ? elevation : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side: BorderSide.none,
                  ),
                  padding: padding,
                  splashFactory: enableRippleEffect
                      ? InkRipple.splashFactory
                      : InkSplash.splashFactory,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: MySizes.lg,
                        width: MySizes.lg,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) icon!,
                          if (icon != null) const SizedBox(width: 8),
                          Text(
                            text,
                            style: textStyle ??
                                TextStyle(
                                  color: textColor ?? Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
