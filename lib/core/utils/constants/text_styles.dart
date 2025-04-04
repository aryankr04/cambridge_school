import 'package:flutter/material.dart';

import 'colors.dart';

/// Custom Class for Individual Text Styles
class MyTextStyle {
  static const TextStyle headlineLarge = TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600, color: MyColors.darkBackgroundColor);
  static const TextStyle headlineMedium = TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: MyColors.darkBackgroundColor);
  static const TextStyle headlineSmall = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: MyColors.darkBackgroundColor);

  static const TextStyle titleLarge = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: MyColors.darkBackgroundColor);
  static const TextStyle titleMedium = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: MyColors.subtitleTextColor);
  static const TextStyle titleSmall = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: MyColors.darkBackgroundColor);

  static const TextStyle bodyLarge = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: MyColors.darkBackgroundColor);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: MyColors.subtitleTextColor);
  static  TextStyle bodySmall = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: MyColors.captionTextColor);

  static const TextStyle labelLarge = TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: MyColors.darkBackgroundColor);
  static  TextStyle labelMedium = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: MyColors.captionTextColor);
  static  TextStyle labelSmall = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: MyColors.captionTextColor);


  static const TextStyle placeholder = TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: MyColors.placeholderColor);
  static const TextStyle inputField = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: MyColors.darkBackgroundColor);
  static const TextStyle inputLabel = TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: MyColors.darkBackgroundColor);

  static const TextStyle buttonText = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: MyColors.white);
}
