import 'package:flutter/material.dart';

class MyBoxShadows {
  // Light shadow
  // static const List<BoxShadow> kLightShadow = [
  //   BoxShadow(
  //     color: Colors.black12,
  //     blurRadius: 4,
  //     spreadRadius: 1,
  //     offset: Offset(0, 2),
  //   ),
  // ];

  static const List<BoxShadow> kLightShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 4,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ];

  // Medium shadow
  static const List<BoxShadow> kMediumShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6,
      spreadRadius: 2,
      offset: Offset(0, 4),
    ),
  ];

  // Dark shadow
  static const List<BoxShadow> kDarkShadow = [
    BoxShadow(
      color: Colors.black38,
      blurRadius: 10,
      spreadRadius: 3,
      offset: Offset(0, 6),
    ),
  ];

  // Soft shadow (for subtle UI effects)
  static const List<BoxShadow> kSoftShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 10,
      spreadRadius: 5,
      offset: Offset(0, 3),
    ),
  ];

  // Elevated shadow (for floating elements like buttons, cards)
  static const List<BoxShadow> kElevatedShadow = [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 15,
      spreadRadius: 4,
      offset: Offset(0, 8),
    ),
  ];

  // Intense shadow (for deep shadows, dark mode effects)
  static const List<BoxShadow> kIntenseShadow = [
    BoxShadow(
      color: Colors.black87,
      blurRadius: 20,
      spreadRadius: 6,
      offset: Offset(0, 10),
    ),
  ];
}