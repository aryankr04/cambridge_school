import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyDialogTheme {
  MyDialogTheme._();

  static final lightDialogTheme = _buildDialogTheme(
    backgroundColor: MyColors.white,
  );

  static final darkDialogTheme = _buildDialogTheme(
    backgroundColor: MyColors.darkBackgroundColor,
  );

  static DialogTheme _buildDialogTheme({
    required Color backgroundColor,
  }) {
    return DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: backgroundColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}