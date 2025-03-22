import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/dynamic_colors.dart';

class MyHelperFunctions {
  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message,
      {Color? backgroundColor, IconData? icon}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? MyDynamicColors.activeBlue,
        content: Row(
          children: [
            Icon(icon ?? Icons.info_outline, color: Colors.white),
            const SizedBox(
              width: MySizes.md,
            ),
            Text(
              message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 5000),
      ),
    );
  }

  static void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: MyDynamicColors.activeGreen,icon: Icons.check_circle);
  }

  static void showErrorSnackBar(String errorMessage) {
    print(errorMessage);
    showSnackBar('Error: $errorMessage',
        backgroundColor: MyDynamicColors.activeRed,icon: Icons.error);
  }

  static void showAlertSnackBar(String message) {
    showSnackBar(message, backgroundColor: MyDynamicColors.activeOrange,icon: Icons.warning);
  }

  static void showInfoSnackBar(String message) {
    showSnackBar(message, backgroundColor: MyDynamicColors.activeBlue,icon: Icons.light_mode);
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Loading...'),
          ],
        ),
        duration: Duration(seconds: 10), // Adjust the duration as needed
      ),
    );
  }

  static void showLoadingOverlay() {
    if (!(Get.isDialogOpen ?? false)) {
      showDialog(
        context: Get.context!,
        builder: (_) => WillPopScope(
          onWillPop: () async => false, // Prevent dialog dismissal
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.1),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  // Hide loading overlay
  static void hideLoadingOverlay() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static String extractValueInBrackets(String input) {
    RegExp regex = RegExp(r'\((.*?)\)');
    RegExpMatch? match = regex.firstMatch(input);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '';
    }

    return '';
  }

  static void hideSnackBar(BuildContext context) {
    Get.back();
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDate(int day, int month, int year) {
    DateTime date = DateTime(year, month, day);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static String getTodayDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static double convertFeetInchesToCm(String feetStr, String inchesStr) {
    // Parse feet and inches from the input strings
    final feet = int.tryParse(feetStr) ??
        0; // Convert feet string to integer, default to 0
    final inches = int.tryParse(inchesStr) ??
        0; // Convert inches string to integer, default to 0

    // Convert height to centimeters
    final cm =
        (feet * 30.48) + (inches * 2.54); // 1 foot = 30.48 cm, 1 inch = 2.54 cm
    return cm;
  }

  static String convertCmToFeetInches(double cm) {
    if (cm <= 0) {
      throw ArgumentError("Height in cm must be greater than 0.");
    }

    // Convert cm to total inches
    final totalInches = (cm / 2.54).round(); // 1 inch = 2.54 cm
    final feet = totalInches ~/ 12; // 1 foot = 12 inches
    final inches = totalInches % 12; // Remaining inches after dividing by 12

    // Always return the standard format
    return "${feet}ft ${inches}in"; // Example: 5ft 6in
  }
}
