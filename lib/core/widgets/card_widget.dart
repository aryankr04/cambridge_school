import 'package:flutter/material.dart';

import '../utils/constants/dynamic_colors.dart';

class MyCard extends StatelessWidget {
  final Widget child; // The content inside the card
  final double? elevation; // The shadow depth of the card
   final Color? color; // Background color of the card
  final BorderRadiusGeometry? borderRadius; // Border radius for rounded corners
  final EdgeInsetsGeometry? padding; // Padding inside the card
  final BoxShadow? boxShadow; // Custom box shadow
  final VoidCallback? onTap; // Optional onTap gesture callback
  final double? width; // Width of the card
  final double? height; // Height of the card
  final Border? border; // Optional border around the card
  final EdgeInsetsGeometry? margin; // Optional margin around the card
  final bool hasShadow; // Option to enable/disable shadow
  final bool isCircular; // Option to make the card circular
  final Alignment alignment;

   const MyCard({
    super.key,
    required this.child,
    this.elevation = 0,
    this.color,

    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.all(16.0),
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
    this.border,
    this.margin,
    this.hasShadow = true,
    this.isCircular = false,
    this.alignment=Alignment.center
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      alignment: alignment,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color??MyDynamicColors.backgroundColorWhiteDarkGrey,
        borderRadius: isCircular ? null : borderRadius,
        border: border,
        boxShadow: hasShadow && boxShadow != null ? [boxShadow!] : [],
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      ),
      padding: padding,
      child: child,
    );

    return GestureDetector(
      onTap: onTap,
      child: isCircular
          ? Container(
        margin: margin,
        child: ClipOval(child: cardContent),
      )
          : Card(
        elevation: hasShadow ? elevation! : 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius!,
        ),
        margin: margin,
        color: color,
        child: cardContent,
      ),
    );
  }
}
