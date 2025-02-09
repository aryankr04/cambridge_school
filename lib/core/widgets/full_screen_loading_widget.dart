import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'card_widget.dart';

class MyFullScreenLoading {
  // Constructor with optional loadingText
  final String? loadingText;

  MyFullScreenLoading({this.loadingText});

  // Method to show the full-screen loading dialog
  static void show({String? loadingText}) {
    Get.dialog(
      PopScope(
        canPop: false, // Disable back navigation
        onPopInvokedWithResult: (didPop, result) {
          // Handle pop result if necessary
        },
        child: Center(
          child: Material(
            color: Colors.black.withOpacity(0.1), // Semi-transparent background
            child: MyCard(
              elevation: 5,
              height: Get.width * .5,
              width: Get.width * 0.6,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    // Lottie.asset(
                    //   'assets/animations/loading_animation.json', // Path to your Lottie file
                    //   width: 150,
                    //   height: 150,
                    //   fit: BoxFit.contain,
                    // ),
                    const SizedBox(
                      height: MySizes.spaceBtwSections,
                    ),
                    Text(
                      loadingText ?? 'Loading', // Use loadingText parameter
                      style: Theme.of(Get.context!)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: MyColors.activeBlue),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  // Method to hide the full-screen loading dialog
  static void hide() {
    if (Get.isDialogOpen == true) {
      Get.back(); // Close the dialog
    }
  }
}
