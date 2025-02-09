import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static final lightElevatedButtonTheme = _buildElevatedButtonTheme(
    foregroundColor: MyColors.lightBackgroundColor,
    backgroundColor: MyColors.primaryColor,
    disabledForegroundColor: MyColors.darkGrey,
    disabledBackgroundColor: MyColors.disabledButtonColor,
  );

  static final darkElevatedButtonTheme = _buildElevatedButtonTheme(
    foregroundColor: MyColors.lightBackgroundColor,
    backgroundColor: MyColors.primaryColor,
    disabledForegroundColor: MyColors.darkGrey,
    disabledBackgroundColor: MyColors.darkerGrey,
  );

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color foregroundColor,
    required Color backgroundColor,
    required Color disabledForegroundColor,
    required Color disabledBackgroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(vertical: MySizes.md),
        textStyle: const TextStyle(
            fontSize: 16,
            color: MyColors.whiteTextColor,
            fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySizes.buttonRadius)),
      ),
    );
  }
}