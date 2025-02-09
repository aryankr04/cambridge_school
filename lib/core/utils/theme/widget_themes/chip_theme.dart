import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyChipTheme {
  MyChipTheme._();

  static final lightChipTheme = _buildChipTheme(
      disabledColor: MyColors.grey.withOpacity(0.4),
      labelColor: MyColors.black,
      isDark: false
  );

  static final darkChipTheme = _buildChipTheme(
    disabledColor: MyColors.darkerGrey,
    labelColor: MyColors.white,
    isDark: true,
  );

  static ChipThemeData _buildChipTheme({
    required Color disabledColor,
    required Color labelColor,
    required bool isDark,
  }) {
    return ChipThemeData(
      disabledColor: disabledColor,
      labelStyle: TextStyle(color: labelColor),
      selectedColor: MyColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      checkmarkColor: MyColors.white,
    );
  }
}