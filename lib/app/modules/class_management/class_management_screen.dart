import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../class_management/class_model.dart';
import 'class_management_controller.dart';

class ClassManagementScreen extends GetView<ClassManagementController> {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Management')),
      body: Obx(() {
        return controller.isLoading.value
            ? _buildShimmerLoading()
            : Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClassSelectionHeader(),
                    const SizedBox(height: MySizes.sm),
                    MyBottomSheetDropdown(
                      optionsForChips: controller.classNames,
                      onSingleChanged: controller.fetchClassDetails,
                      dropdownWidgetType: DropdownWidgetType.choiceChip,
                      selectedValue: controller.selectedClassName,
                    ),
                    const SizedBox(height: MySizes.spaceBtwSections),
                    Expanded(child: _buildClassDetailsSection(context)),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildClassSelectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Select a Class", style: MyTextStyle.headlineSmall),
        FilledButton.icon(
          onPressed: _showAddClassDialog,
          icon: const Icon(Icons.add, color: Colors.white, size: 12),
          label: const Text('Add Class'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildClassDetailsSection(BuildContext context) {
    return Obx(() {
      final selectedClass = controller.selectedClass.value;
      if (selectedClass != null) {
        return SingleChildScrollView(
          // Added SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClassTitleAndActions(context),
              const SizedBox(height: MySizes.md),
              _buildSectionsList(context),
              const SizedBox(height: MySizes.md),
              _buildSubjectsList(context),
            ],
          ),
        );
      } else {
        return const Center(child: Text('No class selected'));
      }
    });
  }

  Widget _buildClassTitleAndActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.selectedClassName.value,
          style: MyTextStyle.headlineSmall,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: () {
                  //Todo: Implement Edit Action
                },
                icon: const Icon(Icons.edit, color: Colors.white, size: 12),
                label: const Text('Edit'),
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: MySizes.md),
              FilledButton.icon(
                onPressed: _showDeleteConfirmationDialog,
                icon: const Icon(Icons.delete, color: Colors.white, size: 12),
                label: const Text('Delete'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: MySizes.md),
              FilledButton.icon(
                onPressed: controller.updateClassToFirebase,
                icon: const Icon(Icons.save, color: Colors.white, size: 12),
                label: const Text('Update'),
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeOrange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sections:', style: MyTextStyle.titleLarge),
            TextButton.icon(
              onPressed: () => _showAddSectionDialog(context),
              label: const Text('Add Section'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Important to disable scrolling
          itemCount: controller.selectedClass.value!.sections.length,
          itemBuilder: (context, index) {
            final section = controller.selectedClass.value!.sections[index];
            return SectionTile(
              section: section,
              onEdit: () => _showEditSectionDialog(context, section),
              onDelete: () =>
                  controller.deleteSection(section.sectionName ?? ''),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subjects:',
              style: MyTextStyle.titleLarge,
            ),
            TextButton.icon(
              onPressed: () => _showAddSubjectDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Important to disable scrolling
          itemCount: controller.selectedClass.value!.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.selectedClass.value!.subjects[index];
            return Card(
              child: ListTile(
                title: Text(subject),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteSubject(subject);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddClassDialog() {
    String selectedClassName = ClassNameExtension.displayNamesList.first; // Default selection

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add New Class',
          style: MyTextStyle.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyDropdownField(
                  labelText: 'Class Name',
                  options: ClassNameExtension.displayNamesList,
                  onSelected: (value) {
                    if (value != null) {
                      selectedClassName = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  if (selectedClassName.isNotEmpty) {
                    controller.onAddClassButtonPressed(selectedClassName);
                  }
                  Get.back();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
              const SizedBox(width: MySizes.md),
              FilledButton(
                onPressed: () => Get.back(),
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (controller.selectedClass.value != null) {
      MyConfirmationDialog.show(DialogAction.Delete, onConfirm: () {
        controller.deleteClass(controller.selectedClass.value!.className.label);
      });
    } else {
      Get.snackbar('Warning', 'No class selected to delete.');
    }
  }

  void _showAddSectionDialog(BuildContext context) {
    final sectionNameController = TextEditingController();
    final classTeacherNameController = TextEditingController();
    final classTeacherIdController = TextEditingController();
    final roomNumberController = TextEditingController();
    final capacityController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add New Section',
          style: MyTextStyle.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  labelText: 'Section Name',
                  controller: sectionNameController,
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
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  if (sectionNameController.text.isNotEmpty) {
                    final newSection = SectionModel(
                      sectionName: sectionNameController.text,
                      classTeacherName: classTeacherNameController.text,
                      classTeacherId: classTeacherIdController.text,
                      roomNumber: roomNumberController.text,
                      capacity: int.tryParse(capacityController.text) ?? 0,
                    );
                    controller.addSection(newSection);
                    Get.back();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
              const SizedBox(
                width: MySizes.md,
              ),
              FilledButton(
                onPressed: () {
                  Get.back();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showEditSectionDialog(BuildContext context, SectionModel section) {
    final sectionNameController =
        TextEditingController(text: section.sectionName ?? '');
    final classTeacherNameController =
        TextEditingController(text: section.classTeacherName ?? '');
    final classTeacherIdController =
        TextEditingController(text: section.classTeacherId ?? '');
    final roomNumberController =
        TextEditingController(text: section.roomNumber ?? '');
    final capacityController =
        TextEditingController(text: (section.capacity ?? 0).toString());

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Edit Section',
          style: MyTextStyle.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  labelText: 'Section Name',
                  controller: sectionNameController,
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
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  final updatedSection = SectionModel(
                    sectionName: sectionNameController.text,
                    classTeacherName: classTeacherNameController.text,
                    classTeacherId: classTeacherIdController.text,
                    roomNumber: roomNumberController.text,
                    capacity: int.tryParse(capacityController.text) ?? 0,
                  );
                  controller.updateSection(updatedSection);
                  Get.back();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
              const SizedBox(
                width: MySizes.md,
              ),
              FilledButton(
                onPressed: () {
                  Get.back();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final subjectNameController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add New Subject',
          style: MyTextStyle.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  labelText: 'Subject Name',
                  controller: subjectNameController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  if (subjectNameController.text.isNotEmpty) {
                    controller.addSubject(subjectNameController.text);
                    Get.back();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
              const SizedBox(
                width: MySizes.md,
              ),
              FilledButton(
                onPressed: () {
                  Get.back();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.activeRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Shimmer Loading Widget
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
        Container(width: 150, height: 28, color: Colors.white),
        Container(width: 100, height: 28, color: Colors.white),
      ],
    );
  }

  Widget _buildShimmerDropdown() {
    return Wrap(
      spacing: MySizes.md, // Adds spacing between elements
      runSpacing: 8.0, // Adds spacing when items wrap to the next line
      children: List.generate(
        8,
        (index) => Container(
          width: Get.width * 0.12,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6), // Optional rounded corners
          ),
        ),
      ),
    );
  }
}

Widget _buildShimmerClassDetails() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerClassTitleAndActions(),
        const SizedBox(height: MySizes.spaceBtwSections),
        _buildShimmerSectionsList(),
        const SizedBox(height: MySizes.md),
        _buildShimmerSubjectsList(),
      ],
    ),
  );
}

Widget _buildShimmerClassTitleAndActions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(flex: 1, child: Container(height: 28, color: Colors.white)),
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  height: 28,
                  color: Colors.white,
                )),
            const SizedBox(width: MySizes.md),
            Expanded(
                flex: 1, child: Container(height: 28, color: Colors.white)),
            const SizedBox(width: MySizes.md),
            Expanded(
                flex: 1, child: Container(height: 28, color: Colors.white)),
          ],
        ),
      ),
    ],
  );
}

Widget _buildShimmerSectionsList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 100, height: 20, color: Colors.white),
          Container(width: 80, height: 20, color: Colors.white),
        ],
      ),
      const SizedBox(height: MySizes.md),
      ...List.generate(
        2,
        (index) => Container(
            width: Get.width,
            height: 80,
            margin: const EdgeInsets.only(bottom: MySizes.md),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm))),
      ),
    ],
  );
}

Widget _buildShimmerSubjectsList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 100, height: 20, color: Colors.white),
          Container(width: 80, height: 20, color: Colors.white),
        ],
      ),
      const SizedBox(height: MySizes.sm),
      ...List.generate(
        2,
        (index) => Container(
            width: Get.width,
            height: 80,
            margin: const EdgeInsets.only(bottom: MySizes.md),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm))),
      ),
    ],
  );
}

class SectionTile extends StatelessWidget {
  const SectionTile({
    super.key,
    required this.section,
    required this.onEdit,
    required this.onDelete,
  });

  final SectionModel section;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      child: Column(
        children: [
          _buildTitle(deviceWidth),
          const MyDottedLine(dashColor: MyColors.grey),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: ExpansionTile(
              minTileHeight: 24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                side: BorderSide.none,
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide.none,
              ),
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Students',
                style: MyTextStyle.bodyLarge,
              ),
              children: [
                ...section.students.map((student) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
                      child: _buildStudentInfoRow(
                          student.name ?? '', student.id ?? ''),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(double deviceWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: deviceWidth * 0.1,
            height: deviceWidth * 0.1,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                    Radius.circular(MySizes.cardRadiusXs)),
                color: MyColors.activeBlue.withOpacity(.1)),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: MyColors.activeBlue,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: MyColors.activeRed,
                ),
                onPressed: onDelete,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStudentInfoRow(String name, String id) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          color: MyColors.iconColor,
          size: 18,
        ),
        const SizedBox(width: MySizes.md),
        Expanded(
          child: Text(
            '$name ($id)',
            style: const TextStyle(
              fontSize: 12,
              color: MyColors.subtitleTextColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
