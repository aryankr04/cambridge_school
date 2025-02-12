// core/utils/ui_utils.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiUtils {
  static void showSnackBar(String message) {
    Get.snackbar('Message', message);
  }
}