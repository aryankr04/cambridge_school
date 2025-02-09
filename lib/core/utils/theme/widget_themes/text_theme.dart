import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme lightTextTheme = _buildTextTheme(
    displayColor: MyColors.darkBackgroundColor,
    textColor: MyColors.subtitleTextColor,
    isDark: false,
  );

  static TextTheme darkTextTheme = _buildTextTheme(
    displayColor: MyColors.lightBackgroundColor,
    textColor: MyColors.lightBackgroundColor,
    isDark: true,
  );

  static TextTheme _buildTextTheme({
    required Color displayColor,
    required Color textColor,
    required bool isDark,
  }) {
    return TextTheme(
      headlineLarge: TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.w600, color: displayColor),
      headlineMedium: TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: displayColor),
      headlineSmall: TextStyle().copyWith(fontSize: 20.0, fontWeight: FontWeight.w600, color: displayColor),

      titleLarge: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: displayColor),
      titleMedium: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: textColor),
      titleSmall: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: displayColor),

      bodyLarge: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: displayColor),
      bodyMedium: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: textColor),
      bodySmall: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: displayColor.withOpacity(0.5)),

      labelLarge: TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w500, color: displayColor),
      labelMedium: TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w500, color: textColor.withOpacity(0.5)),
      labelSmall: TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: displayColor.withOpacity(0.5)),
    );
  }
}