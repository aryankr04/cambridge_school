import 'package:cambridge_school/app/modules/subject_management/subject_model.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/search_field.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
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
                FilledButton(
                    onPressed: () {
                      controller.generateAndUploadDummyClasses();
                    },
                    child: const Text('Create Dummy Classes')),
                _buildClassSelectionHeader(),
                const SizedBox(height: MySizes.sm),
                MyBottomSheetDropdown(
                  optionsForChips: controller.availableClassNames,
                  onSingleChanged: controller.fetchClassDetails,
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
      final selectedClass = controller.selectedClass.value;
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
          Row(
            children: [
              Obx(() => Text(
                    controller.selectedClassName.value,
                    style: MyTextStyle.headlineSmall,
                  )),
              if (controller.isEditing.value)
                IconButton(
                    onPressed: _showEditClassNameDialog,
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                    ))
            ],
          ),
          controller.isEditing.value
              ? _buildEditingActions()
              : TextButton.icon(
                  onPressed: () => controller.isEditing(true),
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
          onPressed: _showDeleteConfirmationDialog,
        ),
        const SizedBox(width: MySizes.sm),
        _buildIconButton(
          icon: Icons.close,
          color: MyColors.activeRed,
          onPressed: () => controller.isEditing(false),
        ),
      ],
    );
  }

  Widget _buildSectionsList() {
    final sections = controller.selectedClass.value?.sections ?? [];

    if (sections.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sections', style: MyTextStyle.titleLarge),
                if (controller.isEditing.value)
                  TextButton.icon(
                    onPressed: _showAddSectionDialog,
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
                    onEdit: () => _showEditSectionDialog(index, section),
                    onDelete: () =>
                        controller.deleteSection(section.sectionName ?? ''),
                    isEdit: controller.isEditing.value,
                  );
                },
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sections', style: MyTextStyle.titleLarge)),
              SvgPicture.asset(
                'assets/images/illustrations/empty_state_illustration/e_commerce_5.svg',
                width: Get.width * 0.25,
                height: Get.width * 0.25,
              ),
              const Text(
                'No subjects found',
                style: MyTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSubjectsList() {
    if (controller.selectedClass.value?.sections.isNotEmpty ?? false) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subjects', style: MyTextStyle.titleLarge),
                if (controller.isEditing.value)
                  TextButton.icon(
                    onPressed: _showAddSubjectDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Subject'),
                  ),
              ],
            ),
            const SizedBox(height: MySizes.sm),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.selectedClass.value?.subjects.length ?? 0,
              itemBuilder: (context, index) {
                final subject = controller.selectedClass.value!.subjects[index];
                return SubjectTile(
                  subjectName: subject,
                  isEdit: controller.isEditing.value,
                  onEdit: () => _showEditSubjectDialog(subject),
                  onDelete: () => controller.deleteSubject(subject),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Subjects', style: MyTextStyle.titleLarge)),
              SvgPicture.asset(
                'assets/images/illustrations/empty_state_illustration/e_commerce_5.svg',
                width: Get.width * 0.25,
                height: Get.width * 0.25,
              ),
              const Text(
                'No subjects found',
                style: MyTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showAddClassDialog() {
    Get.dialog(
      _buildClassDialog(
        title: 'Add New Class',
        onAdd: (className) {
          if (className.isNotEmpty) {
            controller.onAddClassButtonPressed(className);
          }
          Navigator.of(Get.context!)
              .pop(); // Use Navigator instead of Get.back()
        },
      ),
    );
  }

  void _showEditClassNameDialog() {
    Get.dialog(
      _buildClassDialog(
        title: 'Edit Class Name',
        initialClassName: controller.selectedClassName.value,
        isUpdate: true,
        onAdd: (className) {
          if (className.isNotEmpty) {
            controller.updateClassName(className);
          }
          Navigator.of(Get.context!).pop();
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

  void _showDeleteConfirmationDialog() {
    if (controller.selectedClass.value != null) {
      MyConfirmationDialog.show(DialogAction.Delete, onConfirm: () {
        controller.deleteClassFromFirebase(controller.selectedClass.value!);
      });
    } else {
      MySnackBar.showAlertSnackBar('No class selected to delete.');
    }
  }

  void _showAddSectionDialog() {
    Get.dialog(_buildSectionDialog(
        title: 'Add New Section', onSave: controller.addSection));
  }

  void _showEditSectionDialog(int index, SectionModel section) {
    Get.dialog(
      _buildSectionDialog(
        title: 'Edit Section',
        section: section,
        onSave: (updatedSection) {
          controller.updateSectionAtIndex(index, updatedSection);
        },
        isUpdate: true,
      ),
    );
  }

  Widget _buildSectionDialog({
    required String title,
    SectionModel? section,
    required Function(SectionModel) onSave,
    bool isUpdate = false,
  }) {
    final selectedSectionName = RxString(section?.sectionName ?? '');
    final classTeacherNameController =
        TextEditingController(text: section?.classTeacherName ?? '');
    final classTeacherIdController =
        TextEditingController(text: section?.classTeacherId ?? '');
    final roomNumberController =
        TextEditingController(text: section?.roomNumber ?? '');
    final capacityController =
        TextEditingController(text: (section?.capacity ?? '').toString());

    return AlertDialog(
      title: Text(title, style: MyTextStyle.headlineSmall),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyDropdownField(
                labelText: 'Section Name',
                options: List.generate(
                    26, (index) => String.fromCharCode(65 + index)),
                onSelected: (value) {
                  if (value != null) {
                    selectedSectionName.value = value;
                  }
                },
                selectedValue: selectedSectionName,
              ),
              MyTextField(
                labelText: 'Class Teacher Name',
                controller: classTeacherNameController,
              ),
              MyTextField(
                labelText: 'Class Teacher ID',
                controller: classTeacherIdController,
              ),
              MyTextField(
                labelText: 'Room Number',
                controller: roomNumberController,
              ),
              MyTextField(
                labelText: 'Capacity',
                controller: capacityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        _buildDialogActions(
          isUpdate: isUpdate,
          onAdd: () {
            final newSection = SectionModel(
              sectionName: selectedSectionName.value,
              classTeacherName: classTeacherNameController.text,
              classTeacherId: classTeacherIdController.text,
              roomNumber: roomNumberController.text,
              capacity: int.tryParse(capacityController.text) ?? 0,
              students: section?.students ?? [],
            );
            onSave(newSection);
            Navigator.of(Get.context!).pop();
          },
          onCancel: () => Navigator.of(Get.context!).pop(),
        ),
      ],
    );
  }

  void _showAddSubjectDialog() {
    Get.dialog(_buildSubjectDialog(onSave: controller.addSubject));
  }

  void _showEditSubjectDialog(String subject) {
    Get.dialog(
      _buildSubjectDialog(
        initialSubject: subject,
        onSave: (newSubject) {
          controller.updateSubject(subject, newSubject);
        },
        isUpdate: true,
      ),
    );
  }

  Widget _buildSubjectDialog({
    String initialSubject = '',
    required Function(String) onSave,
    bool isUpdate = false,
  }) {
    final subjectNameController = TextEditingController(text: initialSubject);

    return AlertDialog(
      title: Text(
        '${isUpdate ? 'Edit' : 'Add New'} Subject',
        style: MyTextStyle.headlineSmall,
      ),
      content: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MySearchField(
              onSelected: (val) {
                subjectNameController.text = val;
              },
              controller: subjectNameController,
              options: SchoolSubjects.getSubjects(),
              labelText: 'Subject',
              showClearIcon: true,
            )
          ],
        ),
      ),
      actions: [
        _buildDialogActions(
          isUpdate: isUpdate,
          onAdd: () {
            if (subjectNameController.text.isNotEmpty) {
              onSave(subjectNameController.text);
              Navigator.of(Get.context!).pop();
            }
          },
          onCancel: () => Navigator.of(Get.context!).pop(),
        ),
      ],
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

class SectionTile extends StatelessWidget {
  const SectionTile({
    super.key,
    required this.section,
    required this.isEdit,
    required this.onEdit,
    required this.onDelete,
  });

  final SectionModel section;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      decoration: BoxDecoration(
        color: MyColors.activeBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: MySizes.sm, horizontal: MySizes.md),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: deviceWidth * 0.1,
              height: deviceWidth * 0.1,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
                color: MyColors.white,
              ),
              child: Text(
                section.sectionName ?? '',
                style: MyTextStyle.headlineMedium
                    .copyWith(color: MyColors.activeBlue),
              ),
            ),
            const SizedBox(width: MySizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.classTeacherName ?? '',
                    style: MyTextStyle.bodyLarge.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    section.classTeacherId ?? '',
                    style: MyTextStyle.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: MySizes.sm),
            if (isEdit)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconButton(
                    icon: Icons.edit,
                    color: MyColors.activeBlue,
                    onPressed: onEdit,
                  ),
                  _buildIconButton(
                    icon: Icons.delete,
                    color: MyColors.activeRed,
                    onPressed: () {
                      MyConfirmationDialog.show(DialogAction.Delete,
                          onConfirm: onDelete);
                    },
                  ),
                ],
              )
          ],
        ),
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
        size: 20,
      ),
      color: color,
    );
  }
}

class SubjectTile extends StatelessWidget {
  const SubjectTile({
    super.key,
    required this.subjectName,
    required this.isEdit,
    required this.onEdit,
    required this.onDelete,
  });

  final String subjectName;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      decoration: BoxDecoration(
        color: MyColors.activeBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: MySizes.sm, horizontal: MySizes.md),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: deviceWidth * 0.1,
              height: deviceWidth * 0.1,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
                color: MyColors.white,
              ),
              child: Text(
                SchoolSubjects.getEmoji(subjectName),
                style: MyTextStyle.headlineMedium
                    .copyWith(color: MyColors.activeBlue),
              ),
            ),
            const SizedBox(width: MySizes.md),
            Expanded(
              child: Text(
                subjectName,
                style: MyTextStyle.bodyLarge.copyWith(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: MySizes.sm),
            if (isEdit)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconButton(
                    icon: Icons.edit,
                    color: MyColors.activeBlue,
                    onPressed: onEdit,
                  ),
                  _buildIconButton(
                    icon: Icons.delete,
                    color: MyColors.activeRed,
                    onPressed: () {
                      MyConfirmationDialog.show(DialogAction.Delete,
                          onConfirm: onDelete);
                    },
                  ),
                ],
              )
          ],
        ),
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
        size: 20,
      ),
      color: color,
    );
  }
}
