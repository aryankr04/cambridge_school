
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/bottom_sheet_dropdown.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../class_model.dart';

class AddSectionDialog extends StatefulWidget {
  final Function(SectionModel) onSubmit;
  final SectionModel? section;
  final int? index;

  const AddSectionDialog({
    super.key,
    required this.onSubmit,
    this.section,
    this.index,
  });

  @override
  State<AddSectionDialog> createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  final _formKey = GlobalKey<FormState>();

  late final RxString sectionName;
  late final RxString classTeacherName;
  late final RxString classTeacherId;
  late final TextEditingController roomNumberController;

  @override
  void initState() {
    super.initState();
    sectionName = (widget.section?.sectionName ?? '').obs;
    classTeacherName = (widget.section?.classTeacherName ?? '').obs;
    classTeacherId = (widget.section?.classTeacherId ?? '').obs;
    roomNumberController =
        TextEditingController(text: widget.section?.roomNumber ?? '');
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
      final newSection = SectionModel(
        sectionName: sectionName.value,
        classTeacherId: classTeacherId.value,
        classTeacherName: classTeacherName.value,
        roomNumber: roomNumberController.text.trim(),
        students: widget.section?.students ?? [],
        routine: widget.section?.routine ?? [],
      );

      await widget.onSubmit(newSection);
      Get.back();
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to submit section: $e');
    }
  }

  List<Map<String, dynamic>> teachers = [
    {'description': '1', 'title': 'Mr. Smith', 'icon': Icons.person},
    {'description': '2', 'title': 'Ms. Johnson', 'icon': Icons.person},
    {'description': '3', 'title': 'Dr. Williams', 'icon': Icons.person},
    {'description': '4', 'title': 'Prof. Davis', 'icon': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.section != null ? 'Edit Section' : 'Add Section',
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
                MyDropdownField(
                  labelText: 'Section Name',
                  options: List.generate(
                      26, (index) => String.fromCharCode(65 + index)),
                  onSelected: (value) {
                    if (value != null) {
                      sectionName.value = value;
                    }
                  },
                  selectedValue: sectionName,
                ),
                MyBottomSheetDropdown(
                  labelText: 'Class Teacher',
                  hintText: 'Choose a teacher',
                  dropdownOptionType: DropdownOptionType.iconWithDescription,
                  optionsForIconWithDescription: teachers,
                  onSingleChanged: (value) {
                    classTeacherName.value = value;
                    classTeacherId.value = teachers.firstWhere(
                            (teacher) => teacher['title'] == value,
                        orElse: () => {'description': ''})['description'];
                  },
                  selectedValue: classTeacherName,
                ),
                MySearchField(
                  onSelected: (val) => roomNumberController.text = val,
                  controller: roomNumberController,
                  options: const [], // Changed to an empty list, as room options will be different
                  labelText: 'Room',
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
              child: Text(widget.section != null ? 'Update' : 'Add'),
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