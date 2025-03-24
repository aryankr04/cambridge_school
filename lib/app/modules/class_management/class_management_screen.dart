import 'package:cambridge_school/app/modules/class_management/widgets/add_section_dialog.dart';
import 'package:cambridge_school/app/modules/class_management/widgets/add_subject_dialog.dart';
import 'package:cambridge_school/app/modules/class_management/widgets/section_tile.dart';
import 'package:cambridge_school/app/modules/class_management/widgets/subject_tile.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/snack_bar.dart';
import 'class_management_controller.dart';
import 'class_model.dart';

class ClassManagementScreen extends GetView<ClassManagementController> {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Management')),
      backgroundColor: MyColors.lightGrey,
      body: Obx(_buildBody),
    );
  }

  Widget _buildBody() {
    return controller.isLoading.value
        ? _buildShimmerLoading()
        : _buildContent();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(MySizes.md),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClassSelectionHeader(),
                const SizedBox(height: MySizes.sm),
                MyBottomSheetDropdown(
                  optionsForChips:controller.availableClassNames,
                  onSingleChanged: (value) {
                    controller.selectedClassName.value = value;
                    controller.fetchClass(value);
                  },
                  dropdownWidgetType: DropdownWidgetType.choiceChip,
                  selectedValue: controller.selectedClassName,
                ),
              ],
            ),
          ),
          const SizedBox(height: MySizes.sm),
          _buildClassDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildClassSelectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Select a Class", style: MyTextStyle.headlineSmall),
        TextButton.icon(
          onPressed: _showAddClassDialog,
          label: const Text('Add Class'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildClassDetailsSection() {
    return Obx(() {
      final selectedClass = controller.classModels.value;
      return (controller.isLoadingClass.value &&
              controller.selectedClassName.value.isNotEmpty)
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: _buildShimmerClassDetails(),
              ),
            )
          : selectedClass != null
              ? MyCard(
                  margin: const EdgeInsets.all(MySizes.md),
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildClassTitleAndActions(),
                      const Divider(
                        height: 1,
                        color: MyColors.dividerColor,
                        thickness: 0.5,
                      ),
                      _buildSectionsList(),
                      const Divider(
                        height: 1,
                        color: MyColors.dividerColor,
                        thickness: 0.5,
                      ),
                      _buildSubjectsList(),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                  children: [
                    SvgPicture.asset(
                        'assets/images/illustrations/empty_state_illustration/e_commerce_3.svg'),
                    const Text(
                      'Please select a class',
                      style: MyTextStyle.titleMedium,
                    ),
                  ],
                ));
    });
  }

  Widget _buildClassTitleAndActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                controller.selectedClassName.value,
                style: MyTextStyle.headlineSmall,
              )),
          controller.isEditMode.value
              ? _buildEditingActions()
              : TextButton.icon(
                  onPressed: () => controller.isEditMode(true),
                  label: const Text('Edit Class'),
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEditingActions() {
    return Row(
      children: [
        _buildIconButton(
          icon: Icons.save,
          color: MyColors.activeGreen,
          onPressed: controller.updateClassToFirebase,
        ),
        const SizedBox(width: MySizes.sm),
        _buildIconButton(
          icon: Icons.delete,
          color: MyColors.activeRed,
          onPressed: _showDeleteClassConfirmationDialog,
        ),
        const SizedBox(width: MySizes.sm),
        _buildIconButton(
          icon: Icons.close,
          color: MyColors.activeRed,
          onPressed: () => controller.isEditMode(false),
        ),
      ],
    );
  }

  Widget _buildSectionsList() {
    final sections = controller.classModels.value?.sections ?? [];

    return Padding(
      padding: const EdgeInsets.only(
          top: MySizes.sm, left: MySizes.md, right: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sections', style: MyTextStyle.titleLarge),
              if (controller.isEditMode.value)
                TextButton.icon(
                  onPressed: () {
                    _showAddOrUpdateSectionDialog(Get.context!, null, null);
                  },
                  label: const Text('Add Section'),
                  icon: const Icon(Icons.add),
                ),
            ],
          ),
          const SizedBox(height: MySizes.sm),
          if (sections.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return SectionTile(
                  section: section,
                  onEdit: () {
                    _showAddOrUpdateSectionDialog(context, section, index);
                  },
                  onDelete: () {
                    controller.classModels.value?.sections.removeWhere(
                        (element) =>
                            element.sectionName == section.sectionName);
                    controller.classModels.value =
                        controller.classModels.value; // Trigger UI Update
                  },
                  isEdit: controller.isEditMode.value,
                );
              },
            )
          else
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/illustrations/empty_state_illustration/e_commerce_3.svg',
                    width: Get.width * 0.35,
                    height: Get.width * 0.35,
                  ),
                  const Text(
                    'No Section Found.',
                    style: MyTextStyle.bodyMedium,
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList() {
    final subjects = controller.classModels.value?.subjects ?? [];

    return Padding(
      padding: const EdgeInsets.only(
          top: MySizes.sm, left: MySizes.md, right: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subjects', style: MyTextStyle.titleLarge),
              if (controller.isEditMode.value)
                TextButton.icon(
                  onPressed: () {
                    _showAddOrUpdateSubjectDialog(Get.context!, null, null);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subject'),
                ),
            ],
          ),
          const SizedBox(height: MySizes.sm),
          if (subjects.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return SubjectTile(
                  subjectName: subject,
                  isEdit: controller.isEditMode.value,
                  onEdit: () {
                    _showAddOrUpdateSubjectDialog(context, subject, index);
                  },
                  onDelete: () {
                    controller.classModels.value!.subjects
                        .removeWhere((element) => element == subject);
                    controller.classModels.value = controller.classModels.value;
                  },
                );
              },
            )
          else
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/illustrations/empty_state_illustration/e_commerce_3.svg',
                    width: Get.width * 0.35,
                    height: Get.width * 0.35,
                  ),
                  const Text(
                    'No Subjects Found',
                    style: MyTextStyle.bodyMedium,
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showAddClassDialog() {
    Get.dialog(
      _buildClassDialog(
        title: 'Add New Class',
        onAdd: (className) {
          if (className.isNotEmpty) {
            controller.addClassToFirebase(className);
          }
          Navigator.of(Get.context!)
              .pop(); // Use Navigator instead of Get.back()
        },
      ),
    );
  }

  Widget _buildClassDialog({
    required String title,
    String initialClassName = '',
    required Function(String) onAdd,
    bool isUpdate = false,
  }) {
    final selectedClassName = RxString(initialClassName);

    return AlertDialog(
      title: Text(title, style: MyTextStyle.headlineSmall),
      content: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyDropdownField(
              labelText: 'Class Name',
              options: ClassNameExtension.displayNamesList
                  .where((name) =>
                      !controller.availableClassNames.contains(name) ||
                      name == initialClassName)
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  selectedClassName.value = value;
                }
              },
              selectedValue: selectedClassName,
            )
          ],
        ),
      ),
      actions: [
        _buildDialogActions(
          isUpdate: isUpdate,
          onAdd: () => onAdd(selectedClassName.value),
          onCancel: () => Navigator.of(Get.context!).pop(),
        ),
      ],
    );
  }

  Widget _buildDialogActions({
    required VoidCallback onAdd,
    required VoidCallback onCancel,
    bool isUpdate = false,
  }) {
    return Row(
      children: [
        FilledButton(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: MyColors.activeGreen,
            foregroundColor: Colors.white,
          ),
          child: Text(isUpdate ? 'Update' : 'Add'),
        ),
        const SizedBox(width: MySizes.md),
        FilledButton(
          onPressed: onCancel,
          style: FilledButton.styleFrom(
            backgroundColor: MyColors.activeRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _showDeleteClassConfirmationDialog() {
    if (controller.classModels.value != null) {
      MyConfirmationDialog.show(DialogAction.Delete, onConfirm: () {
        controller.deleteClassFromFirebase(controller.classModels.value!);
      });
    } else {
      MySnackBar.showAlertSnackBar('No class selected to delete.');
    }
  }

  Future<void> _showAddOrUpdateSectionDialog(
    BuildContext context,
    SectionModel? section,
    int? index,
  ) async {
    Get.dialog(
      barrierDismissible: false,
      AddSectionDialog(
        onSubmit: (SectionModel newSection) async {
          try {
            if (section != null) {
              controller.classModels.value?.updateSection(
                index!,
                controller.selectedClassName.value,
                newSection,
              );
            } else {
              controller.classModels.value?.addSection(
                newSection,
              );
            }
            controller.classModels.refresh();
            Get.back(); // Close the dialog after submission
          } catch (e) {
            MySnackBar.showErrorSnackBar('Failed to update section: $e');
          }
        },
        section: section,
        index: index,
      ),
    );
  }

  Future<void> _showAddOrUpdateSubjectDialog(
    BuildContext context,
    String? subject,
    int? index,
  ) async {
    Get.dialog(
      barrierDismissible: false,
      AddSubjectDialog(
        onSubmit: (String newSubject) async {
          try {
            if (subject != null) {
              controller.classModels.value?.updateSubject(
                index!,
                newSubject,
              );
            } else {
              controller.classModels.value?.addSubject(
                newSubject,
              );
            }
            controller.classModels.refresh();
            Get.back(); // Close the dialog after submission
          } catch (e) {
            MySnackBar.showErrorSnackBar('Failed to update subject: $e');
          }
        },
        subject: subject,
        index: index,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerClassSelectionHeader(),
            const SizedBox(height: MySizes.md),
            _buildShimmerDropdown(),
            SizedBox(height: Get.width * 0.1),
            Expanded(child: _buildShimmerClassDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerClassSelectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select a Class',
          style: MyTextStyle.headlineSmall.copyWith(color: Colors.white),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            'Add Class',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  Widget _buildShimmerDropdown() {
    return Wrap(
      spacing: MySizes.md,
      runSpacing: 8.0,
      children: List.generate(
        8,
        (index) => Container(
          width: Get.width * 0.12,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(MySizes.lg),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerClassDetails() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
            border: Border.all(color: MyColors.dividerColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerClassTitleAndActions(),
            _buildShimmerSectionsList(),
            const SizedBox(height: MySizes.md),
            _buildShimmerSubjectsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerClassTitleAndActions() {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'No Class',
            style: MyTextStyle.headlineSmall.copyWith(color: Colors.white),
          ),
          const Row(
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(
                width: MySizes.md,
              ),
              Icon(Icons.delete, color: Colors.white),
              SizedBox(
                width: MySizes.md,
              ),
              Icon(Icons.close, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSectionsList() {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sections:',
            style: MyTextStyle.headlineSmall.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          ...List.generate(
            2,
            (index) => Container(
              width: double.infinity,
              height: Get.width * 0.16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
              ),
              margin: const EdgeInsets.only(bottom: MySizes.sm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSubjectsList() {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subjects:',
            style: MyTextStyle.headlineSmall.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          ...List.generate(
            2,
            (index) => Container(
              width: double.infinity,
              height: Get.width * 0.16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
              ),
              margin: const EdgeInsets.only(bottom: MySizes.sm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
      ),
    );
  }
}
