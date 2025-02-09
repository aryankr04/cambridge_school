import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'colors.dart';

class MyDynamicColors {
  // App theme colors
  static Color getThemeBasedColor(Color lightColor, Color darkColor) {
    bool isDarkMode =
        MediaQuery.of(Get.context!).platformBrightness == Brightness.dark;
    return isDarkMode ? darkColor : lightColor;
  }

  // Primary color
  static Color get primaryColor => getThemeBasedColor(
      MyColors.primaryColor, MyColors.primaryColor.withOpacity(0.8));

  // Primary Tint Color
  static Color get primaryTintColor => getThemeBasedColor(
      MyColors.primaryTintColor, MyColors.primaryTintColor.withOpacity(0.8));

  // Secondary color
  static Color get secondaryColor => getThemeBasedColor(
      MyColors.secondaryColor, MyColors.secondaryColor.withOpacity(0.8));

  // Secondary Tint Color
  static Color get secondaryTintColor => getThemeBasedColor(
      MyColors.secondaryTintColor,
      MyColors.secondaryTintColor.withOpacity(0.8));

  // Primary text color
  static Color get primaryTextColor =>
      getThemeBasedColor(MyColors.primaryColor, MyColors.white);

  // Headline text color
  static Color get headlineTextColor =>
      getThemeBasedColor(MyColors.headlineTextColor, MyColors.white);

  // Subtitle text color
  static Color get subtitleTextColor => getThemeBasedColor(
      MyColors.subtitleTextColor, MyColors.whiteTextColor.withOpacity(0.5));

  // White text color
  static Color get whiteTextColor =>
      getThemeBasedColor(MyColors.white, MyColors.white);
  static const Color placeholderColor = CupertinoColors.inactiveGray;

  /// Background color tint for light & dark grey for dark theme
  static Color get backgroundColorTintDarkGrey => getThemeBasedColor(
      MyColors.primaryTintColor, MyColors.darkGreyBackgroundColor);

  // Background color tint for light & light grey for Dark theme
  static Color get backgroundColorTintLightGrey => getThemeBasedColor(
      MyColors.primaryTintColor, MyColors.lightGreyBackgroundColor);

  // Background color primary for light & light grey for dark theme
  static Color get backgroundColorPrimaryLightGrey => getThemeBasedColor(
      MyColors.primaryColor, MyColors.lightGreyBackgroundColor);

  // Background color primary for light & dark grey for dark theme
  static Color get backgroundColorPrimaryDarkGrey => getThemeBasedColor(
      MyColors.primaryColor, MyColors.darkGreyBackgroundColor);

  // Background color white for light & dark grey for dark theme
  static Color get backgroundColorWhiteDarkGrey =>
      getThemeBasedColor(MyColors.white, MyColors.darkGreyBackgroundColor);

  // Background color white for light & light grey for dark theme
  static Color get backgroundColorWhiteLightGrey =>
      getThemeBasedColor(MyColors.white, MyColors.lightGreyBackgroundColor);

  // Background color grey for light & light grey for dark theme
  static Color get backgroundColorGreyLightGrey => getThemeBasedColor(
      MyColors.backgroundAccentColor, const Color(0xFF373948));

 

  //Button Primary Color
  static Color get primaryButtonColor => getThemeBasedColor(
      MyColors.primaryButtonColor, MyColors.primaryButtonColor);

  //Button Secondary Color
  static Color get secondaryButtonColor => getThemeBasedColor(
      MyColors.secondaryButtonColor, MyColors.secondaryButtonColor);

  //Button Tertiary Color
  static Color get tertiaryButtonColor => getThemeBasedColor(
      MyColors.tertiaryButtonColor, MyColors.tertiaryButtonColor);

  //Button Disable Color
  static Color get disabledButtonColor => getThemeBasedColor(
      MyColors.disabledButtonColor, MyColors.disabledButtonColor);

  //Icon Primary Color
  static Color get primaryIconColor =>
      getThemeBasedColor(MyColors.primaryColor, MyColors.white);

  // Icon Color
  static Color get iconColor =>
      getThemeBasedColor(MyColors.iconColor, MyColors.white);

  //Icon Disabled Color
  static Color get disabledIconColor =>
      getThemeBasedColor(MyColors.disabledIconColor, MyColors.white);

  // Border color
  static Color get borderColor => getThemeBasedColor(
      MyColors.borderColor, MyColors.lightGreyBackgroundColor);

  // Border primary color
  static Color get primaryBorderColor =>
      getThemeBasedColor(MyColors.primaryColor, MyColors.white);

  //Active Green Color
  static Color get activeGreen =>
      getThemeBasedColor(MyColors.activeGreen, MyColors.activeGreen);

  //Active Blue Color
  static Color get activeBlue =>
      getThemeBasedColor(MyColors.activeBlue, MyColors.activeBlue);

  //Active Orange Color
  static Color get activeOrange =>
      getThemeBasedColor(MyColors.activeOrange, MyColors.activeOrange);

  //Active Red Color
  static Color get activeRed =>
      getThemeBasedColor(MyColors.activeRed, MyColors.activeRed);

  //Active Green Color
  static Color get activeGreenTint =>
      getThemeBasedColor(MyColors.activeGreenTint, MyColors.activeGreenTint);

  //Active Blue Color
  static Color get activeBlueTint =>
      getThemeBasedColor(MyColors.activeBlueTint, MyColors.activeBlueTint);

  //Active Orange Color
  static Color get activeOrangeTint =>
      getThemeBasedColor(MyColors.activeOrangeTint, MyColors.activeOrangeTint);

  //Active Red Color
  static Color get activeRedTint =>
      getThemeBasedColor(MyColors.activeRedTint, MyColors.activeRedTint);

  
  
  

  //My Grey
  static const Color lightGreyBackgroundColor = Color(0xFF373948);
  static const Color darkGreyBackgroundColor = Color(0xFF272733);
  static const Color darkerGreyBackgroundColor = Color(0xFF1D1D27);

  // Background colors
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF202124);

  // Neutral Shades
  static const Color black = Color(0xFF1D1D27);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

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
}
