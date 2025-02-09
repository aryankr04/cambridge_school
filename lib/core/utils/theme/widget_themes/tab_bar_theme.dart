import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyTabBarTheme {
  MyTabBarTheme._();

  static final lightTabBarTheme = _buildTabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: MyColors.subtitleTextColor,
    indicatorColor: MyColors.primaryColor,
    isDark: false,
  );

  static final darkTabBarTheme = _buildTabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white.withOpacity(0.6),
    indicatorColor: MyColors.lightGreyBackgroundColor,
    isDark: true,
  );

  static const defaultTabBarTheme = TabBarTheme();

  static TabBarTheme _buildTabBarTheme({
    required Color labelColor,
    required Color unselectedLabelColor,
    required Color indicatorColor,
    required bool isDark,
  }) {
    return TabBarTheme(
      labelStyle: const TextStyle(
          color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(
          color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
      unselectedLabelColor: unselectedLabelColor,
      indicator: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      splashFactory: NoSplash.splashFactory,
      dividerColor: Colors.transparent,
    );
  }
}