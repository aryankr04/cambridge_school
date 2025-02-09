import 'package:flutter/material.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/appbar_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/bottom_navigation_bar.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/card_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/chip_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/color_scheme_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/dialog_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/tab_bar_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/text_theme.dart';

import '../constants/colors.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = _buildThemeData(Brightness.light);
  static ThemeData darkTheme = _buildThemeData(Brightness.dark);

  static ThemeData _buildThemeData(Brightness brightness) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      disabledColor: MyColors.grey,
      brightness: brightness,
      primaryColor: MyColors.primaryColor,
    );

    final primaryColor = MaterialColor(
      MyColors.primaryColor.value,
      const <int, Color>{
        50: MyColors.primaryColor,
        100: MyColors.primaryColor,
        200: MyColors.primaryColor,
        300: MyColors.primaryColor,
        400: MyColors.primaryColor,
        500: MyColors.primaryColor,
        600: MyColors.primaryColor,
        700: MyColors.primaryColor,
        800: MyColors.primaryColor,
        900: MyColors.primaryColor,
      },
    );

    final colorScheme = brightness == Brightness.light
        ? MyColorSchemeTheme.lightTheme.colorScheme
        : MyColorSchemeTheme.darkTheme.colorScheme;

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: brightness == Brightness.light
          ? MyTextTheme.lightTextTheme
          : MyTextTheme.darkTextTheme,
      chipTheme: brightness == Brightness.light
          ? MyChipTheme.lightChipTheme
          : MyChipTheme.darkChipTheme,
      tabBarTheme: brightness == Brightness.light
          ? MyTabBarTheme.lightTabBarTheme
          : MyTabBarTheme.darkTabBarTheme,
      bottomNavigationBarTheme: brightness == Brightness.light
          ? MyBottomNavigationBarTheme.lightBottomNavigationBar
          : MyBottomNavigationBarTheme.darkBottomNavigationBar,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? Colors.white
          : MyColors.black,
      appBarTheme: brightness == Brightness.light
          ? MyAppBarTheme.lightAppBarTheme
          : MyAppBarTheme.darkAppBarTheme,
      checkboxTheme: brightness == Brightness.light
          ? MyCheckboxTheme.lightCheckboxTheme
          : MyCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: brightness == Brightness.light
          ? MyBottomSheetTheme.lightBottomSheetTheme
          : MyBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: brightness == Brightness.light
          ? MyElevatedButtonTheme.lightElevatedButtonTheme
          : MyElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: brightness == Brightness.light
          ? MyOutlinedButtonTheme.lightOutlinedButtonTheme
          : MyOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: brightness == Brightness.light
          ? MyTextFormFieldTheme.lightInputDecorationTheme
          : MyTextFormFieldTheme.darkInputDecorationTheme,
      dialogTheme: brightness == Brightness.light
          ? MyDialogTheme.lightDialogTheme
          : MyDialogTheme.darkDialogTheme,
      cardTheme: brightness == Brightness.light
          ? MyCardTheme.lightCardTheme
          : MyCardTheme.darkCardTheme,
    );

  }
}