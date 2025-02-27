import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Icon? leadingIcon;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final Color? titleColor;
  final double elevation;
  final Function? onLeadingIconPressed;
  final double height;

  const MyAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.leadingIcon,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
    this.titleColor,
    this.elevation = 4.0,
    this.onLeadingIconPressed,
    this.height = kToolbarHeight, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      leading: showBackButton
          ? IconButton(
        icon: Icon(leadingIcon?.icon ?? Icons.arrow_back,color: Colors.white,),
        onPressed: () {
          if (onLeadingIconPressed != null) {
            onLeadingIconPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
      )
          : leadingIcon != null
          ? IconButton(
        icon: leadingIcon!,

        color: Colors.white,
        onPressed: () {
          if (onLeadingIconPressed != null) {
            onLeadingIconPressed!();
          }
        },
      )
          : null,
      title: Text(
        title,
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
