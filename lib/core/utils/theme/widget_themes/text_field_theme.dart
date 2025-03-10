import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/text_styles.dart';

class MyTextFormFieldTheme {
  MyTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = _buildInputDecorationTheme(
    borderColor: MyColors.primaryColor,
    errorColor: MyColors.activeRed,
    textColor: MyColors.placeholderColor,
    iconColor: MyColors.iconColor,
    fillColor: MyColors.activeBlue.withOpacity(0.1),
    isDark: false,
  );

  static InputDecorationTheme darkInputDecorationTheme = _buildInputDecorationTheme(
    borderColor: MyColors.white,
    errorColor: MyColors.activeRed,
    textColor: MyColors.white,
    iconColor: MyColors.darkGrey,
    fillColor: MyColors.activeBlue.withOpacity(0.1),
    isDark: true,
  );

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color borderColor,
    required Color errorColor,
    required Color textColor,
    required Color iconColor,
    required Color fillColor,
    required bool isDark,
  }) {
    return InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: iconColor,
      suffixIconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      labelStyle: const TextStyle().copyWith(
        fontSize: MySizes.fontSizeMd,
        color: textColor,
      ),

      hintStyle: MyTextStyle.placeholder.copyWith(color: textColor),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      floatingLabelStyle: const TextStyle().copyWith(color: textColor.withOpacity(0.8)),
      fillColor: fillColor,
      filled: true,
      errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),

      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
        borderSide: BorderSide(width: 1.5, color: borderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
        borderSide: BorderSide(width: 1, color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
        borderSide: BorderSide(width: 2, color: errorColor),
      ),
    );
  }
}