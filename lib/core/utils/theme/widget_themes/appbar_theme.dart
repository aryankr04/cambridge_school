import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static final lightAppBarTheme = _buildAppBarTheme(
    backgroundColor: MyColors.activeBlue,
    iconColor: MyColors.darkBackgroundColor,
    textColor: MyColors.white,
    isDark: false,
  );

  static final darkAppBarTheme = _buildAppBarTheme(
    backgroundColor: Colors.transparent,
    iconColor: MyColors.white,
    textColor: MyColors.white,
    isDark: true,
  );

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required bool isDark,
  }) {
    return AppBarTheme(
      elevation: 5,
      centerTitle: true,
      scrolledUnderElevation: 4,
      backgroundColor: backgroundColor,
      surfaceTintColor: isDark ? Colors.transparent : Colors.black,
      iconTheme: IconThemeData(color: iconColor, size: MySizes.iconMd),
      actionsIconTheme: IconThemeData(color: iconColor, size: MySizes.iconMd),
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: textColor),
      shadowColor: Colors.black.withOpacity(0.5),
    );
  }
}