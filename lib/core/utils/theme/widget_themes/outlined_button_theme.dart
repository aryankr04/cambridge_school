import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = _buildOutlinedButtonTheme(
    foregroundColor: MyColors.darkBackgroundColor,
    borderColor: MyColors.borderColor,
    textColor: MyColors.black,
  );

  static final darkOutlinedButtonTheme = _buildOutlinedButtonTheme(
    foregroundColor: MyColors.lightBackgroundColor,
    borderColor: MyColors.borderColor,
    textColor: MyColors.whiteTextColor,
  );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color foregroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        elevation: 0,
        foregroundColor: foregroundColor,
        side: BorderSide(color: borderColor),
        textStyle: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: MySizes.md, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySizes.buttonRadius)),
      ),
    );
  }
}