import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyBottomSheetTheme {
  MyBottomSheetTheme._();

  static final lightBottomSheetTheme = _buildBottomSheetTheme(
    backgroundColor: MyColors.white,
  );

  static final darkBottomSheetTheme = _buildBottomSheetTheme(
    backgroundColor: MyColors.black,
  );

  static BottomSheetThemeData _buildBottomSheetTheme({
    required Color backgroundColor,
  }) {
    return BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: backgroundColor,
      modalBackgroundColor: backgroundColor,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}