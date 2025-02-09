import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyCardTheme {
  MyCardTheme._();

  static final lightCardTheme = _buildCardTheme(
    color: MyColors.white,
  );
  static final darkCardTheme = _buildCardTheme(
    color: MyColors.primaryColor.withOpacity(0.5),
  );

  static CardTheme _buildCardTheme({
    required Color color,
  }) {
    return CardTheme(
      color: color,
    );
  }
}