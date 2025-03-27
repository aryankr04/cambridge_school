import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

class MySnackBar {
  static void showSnackBar(String message,
      {Color? backgroundColor, IconData? icon}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? MyDynamicColors.activeBlue,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? Icons.info_outline, color: Colors.white),
            const SizedBox(width: MySizes.md),
            Expanded(
              child: Text(
                message,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 3000),
        dismissDirection:  DismissDirection.horizontal,
      ),
    );
  }


  static void showSuccessSnackBar(String message) {
    showSnackBar(message,
        backgroundColor: MyDynamicColors.activeGreen, icon: Icons.check_circle);
  }

  static void showErrorSnackBar(String errorMessage) {
    print(errorMessage);
    showSnackBar('Error: $errorMessage',
        backgroundColor: MyDynamicColors.activeRed, icon: Icons.error);
  }

  static void showAlertSnackBar(String message) {
    showSnackBar(message,
        backgroundColor: MyDynamicColors.activeOrange, icon: Icons.warning);
  }

  static void showInfoSnackBar(String message) {
    showSnackBar(message,
        backgroundColor: MyDynamicColors.activeBlue, icon: Icons.light_mode);
  }
}
