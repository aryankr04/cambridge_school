import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyColorSchemeTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme:  const ColorScheme.light(
      primary: MyColors.primaryColor,
      secondary: MyColors.primaryColor,
      surface: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: MyColors.activeRed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: MyColors.primaryColor,
      secondary: MyColors.primaryColor,
      surface: Colors.black,
      onSurface: Colors.white,
      onError: Colors.black,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      error: MyColors.activeRed,
    ),
  );
}
