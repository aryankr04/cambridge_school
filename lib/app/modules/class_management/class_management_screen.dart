// Filename: management/admin/class_management/class_management_screen.dart
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:cambridge_school/core/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'class_management_controller.dart';
import 'class_management_widgets.dart';
import 'class_model.dart';

class ClassManagementScreen extends GetView<ClassManagementController> {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.showAddClassNameDialog,
        tooltip: 'Add Class',
        child: const Icon(Icons.add),
      ),
      body: Obx(() => controller.isLoadingClassNames.value
          ? _buildShimmerScreen()
          : _buildMainContent(context)),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(MySizes.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClassSelectionRow(context),
                const SizedBox(height: MySizes.spaceBtwSections),
                _buildClassDetailsCard(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassSelectionRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text('Select Class',
                    style: Theme.of(context).textTheme.headlineSmall)),
            SizedBox(
              child: TextButton.icon(
                onPressed: controller.showAddClassNameDialog,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Class'),
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: SchoolDynamicColors.primaryColor,
                //   foregroundColor: Colors.white,
                // ),
              ),
            ),
          ],
        ),
        const SizedBox(height: MySizes.spaceBtwItems),
        Obx(
          () => controller.isLoadingClassNames.value
              ? _buildShimmerClassList()
              : MySelectionWidget(
                  selectedItem: controller.selectedClassName.value,
                  items: controller.availableClassNames,
                  onSelectionChanged: (className) {
                    if (className != null) {
                      controller.selectedClassName.value = className;
                      controller.loadClassDetails(className);
                    }
                  },
            tag: 'class',

          ),
        ),
      ],
    );
  }

  Widget _buildClassDetailsCard(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingClassDetails.value) {
        return _buildShimmerSectionList(); // Or a more appropriate loading indicator
      } else if (controller.selectedClass.value == null) {
        return const Center(child: Text('No Class Selected')); //Or empty state
      } else {
        return _buildClassContent(context, controller.selectedClass.value!);
      }
    });
  }

  Widget _buildClassContent(
      BuildContext context, SchoolClassModel selectedClass) {
    return MyCard(
      border: Border.all(width: 1, color: MyColors.borderColor),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSelectedClassHeader(context),
          MyCard(
            child: Column(
              children: [
                _buildSectionList(context, selectedClass),
                const SizedBox(height: MySizes.lg),
                _buildSubjectList(context, selectedClass),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedClassHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm - 8, horizontal: MySizes.md),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        color: MyColors.activeBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => Text(
                controller.selectedClassName.isNotEmpty
                    ? "Class - ${controller.selectedClassName.value}"
                    : 'Select a Class',
                style: MyTextStyles.headlineSmall
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          if (controller.selectedClassName.isNotEmpty)
            IconButton(
              onPressed: () async {
                MyConfirmationDialog.show(DialogAction.Delete,
                    onConfirm: () async {
                  await controller.deleteClassesAndClassName(
                      ClassManagementController.schoolId,
                      controller.selectedClassName.value);
                  controller.selectedClassName.value = '';
                });
              },
              icon: Icon(Icons.delete_rounded,
                  color: MyDynamicColors.activeRed),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionList(
      BuildContext context, SchoolClassModel selectedClass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, selectedClass),
        const SizedBox(height: MySizes.sm),
        Wrap(
          runSpacing: MySizes.spaceBtwItems,
          spacing: MySizes.spaceBtwItems,
          children: selectedClass.sections?.map((section) {
                return SectionCard(
                  schoolClass: section,
                  onEdit: () => controller.showAddSectionDialogForEdit(
                      selectedClass, section),
                  onDelete: () {
                    MyConfirmationDialog.show(DialogAction.Delete,
                        onConfirm: () async {
                      await controller.deleteSection(selectedClass, section);
                    });
                  },
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, SchoolClassModel selectedClass) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Sections', style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: () => controller.showAddSectionDialog(selectedClass),
          child: Text(
            'Add Section +',
            style: TextStyle(
              color: MyDynamicColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectList(
      BuildContext context, SchoolClassModel selectedClass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubjectHeader(context, selectedClass),
        const SizedBox(height: MySizes.sm),
        Wrap(
          runSpacing: MySizes.spaceBtwItems,
          spacing: MySizes.spaceBtwItems,
          children: selectedClass.subjects?.map((subject) {
                return SubjectCard(
                  subject: subject,
                  onDelete: () {
                    MyConfirmationDialog.show(DialogAction.Delete,
                        onConfirm: () async {
                      await controller.deleteSubject(subject);
                    });
                  },
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }

  Widget _buildSubjectHeader(
      BuildContext context, SchoolClassModel selectedClass) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Subjects', style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: () => controller.showAddSubjectDialog(selectedClass, null),
          child: Text(
            'Add Subject +',
            style: TextStyle(color: MyDynamicColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerClassList() {
    return Shimmer.fromColors(
      baseColor: MyDynamicColors.backgroundColorGreyLightGrey,
      highlightColor: MyDynamicColors.backgroundColorWhiteDarkGrey,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => Card(
            child: Container(
              width: 80,
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerSectionList() {
    return Shimmer.fromColors(
      baseColor: MyDynamicColors.backgroundColorGreyLightGrey,
      highlightColor: MyDynamicColors.backgroundColorWhiteDarkGrey,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => Card(
          child: Container(
            height: 70,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerScreen() {
    return Shimmer.fromColors(
      baseColor: MyDynamicColors.backgroundColorGreyLightGrey,
      highlightColor: MyDynamicColors.backgroundColorWhiteDarkGrey,
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 40, width: 200, color: Colors.white),
            const SizedBox(height: MySizes.spaceBtwItems),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Card(
                  child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwSections),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 30, width: 150, color: Colors.white),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) => Card(
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
