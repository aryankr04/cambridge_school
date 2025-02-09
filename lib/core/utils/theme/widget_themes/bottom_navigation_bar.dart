import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyBottomNavigationBarTheme {
  MyBottomNavigationBarTheme._();

  static final lightBottomNavigationBar = _buildBottomNavigationBarTheme(
    selectedItemColor: MyColors.primaryColor,
    unselectedItemColor: MyColors.iconColor,
    backgroundColor: MyColors.black,
    isDark: false,
  );

  static final darkBottomNavigationBar = _buildBottomNavigationBarTheme(
    selectedItemColor: MyColors.white,
    unselectedItemColor: MyColors.white.withOpacity(.5),
    backgroundColor: MyColors.white,
    isDark: true,
  );

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme({
    required Color selectedItemColor,
    required Color unselectedItemColor,
    required Color backgroundColor,
    required bool isDark,
  }) {
    return BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      backgroundColor: backgroundColor,
      elevation: 10,
    );
  }
}