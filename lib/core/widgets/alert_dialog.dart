import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

enum DialogType {
  OkCancel,    // Basic confirmation (OK and Cancel)
  Exit,        // Exit confirmation dialog
  Success,     // Success message
  Custom,      // Custom dialog for more flexibility
  Warning,     // Warning message (e.g., unsaved changes)
  Error,       // Error message (e.g., failed operation)
  Info,        // Informational message
  Retry,       // Retry operation (e.g., network error)
  NoConnection, // No connection message
  Loading,     // Loading dialog (e.g., show while waiting for an operation to complete)
  Delete,      // Delete confirmation
  Save,        // Save confirmation
  Input,       // Input dialog (e.g., ask for user input)
  SessionExpired, // Session expired notification
  Upgrade,     // App upgrade request
  Permission,  // Permission request (e.g., location, camera)
  RateApp,     // Rate app dialog
  Timeout,     // Timeout message
  TermsAndConditions, // Terms and conditions dialog
}

class MyAlertDialog extends StatelessWidget {
  final DialogType dialogType;
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final TextEditingController? inputController;

  const MyAlertDialog({
    super.key,
    required this.dialogType,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.inputController,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText = confirmText;
    String cancelButtonText = cancelText;
    Color color = Colors.black;
    Icon icon = const Icon(Icons.circle);
    Widget? inputField;

    switch (dialogType) {
      case DialogType.OkCancel:
        buttonText = 'OK';
        cancelButtonText = 'Cancel';
        color = Colors.blue;
        icon = Icon(Icons.info_outline, size: 24, color: color);
        break;
      case DialogType.Exit:
        color = Colors.orange;
        icon = Icon(Icons.exit_to_app, size: 24, color: color);
        break;
      case DialogType.Success:
        color = Colors.green;
        icon = Icon(Icons.check_circle, size: 24, color: color);
        break;
      case DialogType.Warning:
        color = Colors.yellow;
        icon = Icon(Icons.warning, size: 24, color: color);
        break;
      case DialogType.Error:
        color = Colors.red;
        icon = Icon(Icons.error, size: 24, color: color);
        break;
      case DialogType.Info:
        color = Colors.blue;
        icon = Icon(Icons.info, size: 24, color: color);
        break;
      case DialogType.Retry:
        color = Colors.orange;
        icon = Icon(Icons.refresh, size: 24, color: color);
        break;
      case DialogType.NoConnection:
        color = Colors.red;
        icon = Icon(Icons.signal_wifi_off, size: 24, color: color);
        break;
      case DialogType.Loading:
        color = Colors.blue;
        icon = Icon(Icons.hourglass_empty, size: 24, color: color);
        break;
      case DialogType.Delete:
        color = Colors.red;
        icon = Icon(Icons.delete_forever, size: 24, color: color);
        break;
      case DialogType.Save:
        color = Colors.green;
        icon = Icon(Icons.save, size: 24, color: color);
        break;
      case DialogType.Input:
        color = Colors.blue;
        icon = Icon(Icons.input, size: 24, color: color);
        inputField = TextField(
          controller: inputController,
          decoration: const InputDecoration(hintText: 'Enter text here'),
        );
        break;
      case DialogType.SessionExpired:
        color = Colors.red;
        icon = Icon(Icons.access_alarm, size: 24, color: color);
        break;
      case DialogType.Upgrade:
        color = Colors.blue;
        icon = Icon(Icons.system_update, size: 24, color: color);
        break;
      case DialogType.Permission:
        color = Colors.blue;
        icon = Icon(Icons.camera_alt, size: 24, color: color);
        break;
      case DialogType.RateApp:
        color = Colors.orange;
        icon = Icon(Icons.star_rate, size: 24, color: color);
        break;
      case DialogType.Timeout:
        color = Colors.red;
        icon = Icon(Icons.timer_off, size: 24, color: color);
        break;
      case DialogType.TermsAndConditions:
        color = Colors.blue;
        icon = Icon(Icons.description, size: 24, color: color);
        break;
      case DialogType.Custom:
        // TODO: Handle this case.
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.1),
            child: icon,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (inputField != null) ...[
            const SizedBox(height: 16),
            inputField,
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onCancel != null)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onCancel!();
                  },
                  child: Text(cancelButtonText),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: Text(buttonText, style: TextStyle(color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Static method to show the dialog
  static Future<void> show({
    required DialogType dialogType,
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    TextEditingController? inputController,
  }) {
    // Check if the context is available before proceeding
    final BuildContext? context = Get.context;
    if (context == null) {
      // Handle the case where context is not available, perhaps log an error or return
      return Future.value();
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyAlertDialog(
          dialogType: dialogType,
          title: title,
          content: content,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmText: confirmText,
          cancelText: cancelText,
          inputController: inputController,
        );
      },
    );
  }

}
