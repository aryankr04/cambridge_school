
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../subject_management/subject_model.dart';

class AddSubjectDialog extends StatefulWidget {
  final Function(String) onSubmit;
  final String? subject;
  final int? index;

  const AddSubjectDialog({
    super.key,
    required this.onSubmit,
    this.subject,
    this.index,
  });

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController subjectController;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(text: widget.subject ?? '');
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await widget.onSubmit(subjectController.text.trim());
      Get.back();
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to submit subject: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.subject != null
            ? 'Edit Subject'
            : 'Add Subject', // Changed title for clarity
        style: MyTextStyle.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MySearchField(
                  onSelected: (val) => subjectController.text = val,
                  controller: subjectController,
                  options: SchoolSubjects.getSubjects(),
                  labelText: 'Subject Name', // Changed label for clarity
                  showClearIcon: true,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            FilledButton(
              onPressed: _submitForm,
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.activeGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.subject != null ? 'Update' : 'Add'),
            ),
            const SizedBox(width: MySizes.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.activeRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
