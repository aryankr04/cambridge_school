import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyCheckboxTheme {
  MyCheckboxTheme._();

  static final lightCheckboxTheme = _buildCheckboxTheme(
    checkColorSelected: MyColors.white,
    checkColorUnselected: MyColors.black,
    fillColorSelected: MyColors.primaryColor,
    fillColorUnselected: Colors.transparent,
  );

  static final darkCheckboxTheme = _buildCheckboxTheme(
    checkColorSelected: MyColors.white,
    checkColorUnselected: MyColors.black,
    fillColorSelected: MyColors.primaryColor,
    fillColorUnselected: Colors.transparent,
  );

  static CheckboxThemeData _buildCheckboxTheme({
    required Color checkColorSelected,
    required Color checkColorUnselected,
    required Color fillColorSelected,
    required Color fillColorUnselected,
  }) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySizes.xs)),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return checkColorSelected;
        } else {
          return checkColorUnselected;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return fillColorSelected;
        } else {
          return fillColorUnselected;
        }
      }),
    );
  }
}