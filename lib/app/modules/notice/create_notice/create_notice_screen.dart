// create_notice_screen.dart
import 'package:cambridge_school/app/modules/user_management/create_user/models/roles.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/dialog_dropdown.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/text_field.dart';
import '../notice_model.dart';
import 'create_notice_controller.dart';

class CreateNoticeScreen extends StatefulWidget {
  final Notice? noticeToEdit;

  const CreateNoticeScreen({super.key, this.noticeToEdit});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  final CreateNoticeController controller = Get.put(CreateNoticeController());

  @override
  void initState() {
    super.initState();
    // Initialize the form with the notice details if it's an edit operation
    if (widget.noticeToEdit != null) {
      controller.populateFormForEdit(widget.noticeToEdit!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noticeToEdit == null ? 'Create Notice' : 'Edit Notice'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                controller.titleController,
                'Title',
                'Enter the title',
              ),
              _buildTextField(
                controller.descriptionController,
                'Description',
                'Enter the description',
                maxLines: 4,
              ),
              MyDropdownField(
                options: MyLists.noticeCategories(),
                onSelected: (val) {
                  controller.selectedCategory.value = val;
                },
                selectedValue: controller.selectedCategory,
                labelText: 'Category',
              ),
              SizedBox(height: MySizes.md,),
              Padding(
                padding: const EdgeInsets.only(bottom: MySizes.lg),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Is Important',
                        style: MyTextStyles.inputLabel,
                      ),
                    ),
                    const SizedBox(height: MySizes.sm),
                    Obx(() => SwitchListTile(
                      title: const Text(
                        'Mark this as an important notice',
                        style: MyTextStyles.inputField,
                      ),
                      value: controller.isImportant.value,
                      onChanged: controller.toggleImportance,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: MyColors.activeBlue.withOpacity(0.1),
                      visualDensity: const VisualDensity(vertical: -3),
                      inactiveTrackColor: MyColors.grey.withOpacity(0.1),
                      inactiveThumbColor: MyColors.darkGrey,
                      trackOutlineColor:
                      WidgetStateProperty.resolveWith((states) {
                        return states.contains(WidgetState.selected)
                            ? MyColors.activeBlue
                            : MyColors.darkGrey;
                      }),
                    )),
                  ],
                ),
              ),
              MyDialogDropdown(
                optionsForChips: Roles().getAllRolesAsString(),
                isMultipleSelection: true,
                onMultipleChanged: (List<String>? values) {
                  controller.selectedTargetAudience.clear();
                  if (values != null) {
                    controller.selectedTargetAudience.addAll(values);
                  }
                },
                labelText: 'Target Audience',
                showAllOption: true,
                initialSelectedValues: controller.selectedTargetAudience.toList(),
              ),
              const SizedBox(height: MySizes.lg),
              Obx(() => controller.selectedTargetAudience.contains('Student') ||
                  controller.selectedTargetAudience.contains('All')
                  ? MyDialogDropdown(
                optionsForChips: MyLists.classOptions,
                isMultipleSelection: true,
                onMultipleChanged: (List<String>? values) {
                  controller.selectedForClass.clear();
                  if (values != null) {
                    controller.selectedForClass.addAll(values);
                  }
                },
                labelText: 'For Class',
                showAllOption: true,
                initialSelectedValues: controller.selectedForClass.toList(),
              )
                  : const SizedBox.shrink()),
              const SizedBox(height: MySizes.lg),
              MyButton(
                onPressed: () {
                  if (widget.noticeToEdit == null) {
                    // Call the addNoticeToFirebase function to create a new notice
                    controller.addNoticeToFirebase();
                  } else {
                    // Call the updateNoticeInFirebase function to update the existing notice
                    controller.updateNoticeInFirebase(widget.noticeToEdit!);
                  }
                },
                text: widget.noticeToEdit == null ? 'Submit Notice' : 'Update Notice',
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MySizes.lg),
      child: MyTextField(
        controller: controller,
        hintText: hint,
        labelText: label,
        maxLines: maxLines,
      ),
    );
  }
}