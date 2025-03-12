import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyColors {
  // Primary Color
  static const Color primaryColor = Color(0xFF0077FF);
  static const Color primaryTintColor = Color(0xFFebf1ff);


  // Secondary Color
  static const Color secondaryColor = Color(0xFFFF9B25);
  static const Color secondaryTintColor = Color(0xFFffebd3);

  // Background Color
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF1D1D27);

  // Illustration Theme Color
  static const Color illustrationThemeColor = Color(0xFFFFA726);

  // Background Accent Color
  static const Color backgroundAccentColor = Color(0xFFF2F2F7);

  // Text Colors
  static const Color headlineTextColor = Color(0xFF202124);
  static const Color subtitleTextColor = Color(0xFF555555);
  static const Color bodyTextColor = Color(0xFF333333);
  static const Color captionTextColor = Color(0xFF999999);
  static const Color whiteTextColor = Color(0xFFFFFFFF);

  //Button Colors
  static const Color primaryButtonColor = Color(0xFF0077FF);
  static const Color secondaryButtonColor = Color(0xFF34C759);
  static const Color tertiaryButtonColor = Color(0xFFFFA500);
  static const Color disabledButtonColor = Color(0xFFA6A6A6);

  // Link Color
  static const Color linkColor = Color(0xFF0077FF);

  // Navigation Color
  static const Color navigationColor = Color(0xFF0077FF);

  // Selection Color
  static const Color selectionColor = Color(0xFF0077FF);

  // Placeholder Color
  static const Color placeholderColor = Color(0xFFA6A6A6);

  // Divider Color
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Overlay Color
  static const Color overlayColor = Color.fromRGBO(0, 0, 0, 0.5);

  //Active Colors
  static const Color activeGreen = CupertinoColors.activeGreen;
  static const Color activeGreenTint = Color(0xFFE7F9F1);

  static const Color activeOrange = CupertinoColors.activeOrange;
  static const Color activeOrangeTint = Color(0xFFFFF8E3);

  static const Color activeBlue = CupertinoColors.activeBlue;
  static const Color activeBlueTint = Color(0xFFEBF1F8);

  static const Color activeRed = CupertinoColors.destructiveRed;
  static const Color activeRedTint = Color(0xFFFAEDED);

  //Icon Color
  static const Color iconColor = Color(0xFF616972);
  static const Color disabledIconColor = Color(0xFFA6A6A6);

  // Border Colors
  static const Color borderColor = Color(0xffD9DBDD);

  //Colors
  static const Color colorOrange = Color(0xFFFF9066);
  static const Color colorYellow = Color(0xFFFFC844);
  static const Color colorGreen = Color(0xFF3AD0AE);
  static const Color colorSkyBlue = Color(0xFF3ED4F6);
  static const Color colorBlue = Color(0xFF5BBFFF);
  static const Color colorTeal = Color(0xFF3CC4C4);
  static const Color colorPink = Color(0xFFD67AF1);
  static const Color colorRed = Color(0xFFFF769F);
  static const Color colorPurple = Color(0xFFB16FEF);
  static const Color colorViolet = Color(0xFF787DFF);

  static const List<Color> colorList = [
    activeBlue,
    activeGreen,
    activeOrange,
    activeRed,
    colorViolet,
    colorPink
  ];
  static const List<Color> allColorList = [
    colorOrange,
    colorYellow,
    colorGreen,
    colorSkyBlue,
    colorBlue,
    colorTeal,
    colorPink,
    colorRed,
    colorPurple,
    colorViolet,
  ];
  static Color getRandomColor() {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
  // Neutral Shades
  static const Color black = Color(0xFF1D1D27);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

  //Grey
  static const Color lightGreyBackgroundColor = Color(0xFF373948);
  static const Color darkGreyBackgroundColor = Color(0xFF272733);
  static const Color darkerGreyBackgroundColor = Color(0xFF1D1D27);
}
