import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? icon;

  const MyDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Custom Widget
              if (icon != null) icon!,
              const SizedBox(height: 8),
              // Title
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.md),
              // Message
              content,
              const SizedBox(height: 16),
              // Actions
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> show(
      String title,
    Widget content,
  ) async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return MyDialog(
          title: title,
          content: content,
        );
      },
    );
  }
}
