import 'package:cambridge_school/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

enum DialogAction { Delete, Save, Exit, Edit, }

class MyConfirmationDialog extends StatelessWidget {
  final DialogAction action;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const MyConfirmationDialog({
    super.key,
    required this.action,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    String content = '';
    String confirmText = '';
    String cancelText = 'Cancel';
    Color color = Colors.black;
    IconData icon = Icons.circle; // Changed to IconData

    switch (action) {
      case DialogAction.Delete:
        title = 'Confirm Deletion';
        content = 'Are you sure you want to delete this item?';
        confirmText = 'Delete';
        color = MyDynamicColors.activeRed;
        icon = Icons.delete_forever_rounded;
        break;
      case DialogAction.Save:
        title = 'Confirm Save';
        content = 'Are you sure you want to save this item?';
        confirmText = 'Save';
        color = MyDynamicColors.activeGreen;
        icon = Icons.save_rounded;
        break;
      case DialogAction.Exit:
        title = 'Confirm Exit';
        content = 'Are you sure you want to exit without saving your changes?';
        confirmText = 'Exit';
        color = MyDynamicColors.activeRed;
        icon = Icons.exit_to_app_rounded;
        break;
      case DialogAction.Edit:
        title = 'Confirm Edit';
        content = 'Are you sure you want to edit this item?';
        confirmText = 'Edit';
        color = MyDynamicColors.activeBlue; // Example color
        icon = Icons.edit_rounded;
        break;

    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(MySizes.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, size: 24, color: color), // Used IconData
          ),
          const SizedBox(height: MySizes.md),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MySizes.sm),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MySizes.lg),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) onCancel!();
                  },
                  text: cancelText,
                  backgroundColor: Colors.grey.shade300,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: MySizes.md),
              Expanded(
                child: MyButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  text: confirmText,
                  backgroundColor: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Static method to show the dialog
  static Future<void> show(
      DialogAction action, {
        required VoidCallback onConfirm,
        VoidCallback? onCancel,
      }) {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return MyConfirmationDialog(
          action: action,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }
}