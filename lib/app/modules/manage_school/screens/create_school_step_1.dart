import 'dart:io';

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/image_picker.dart';
import '../../../../core/widgets/selection_widget.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_1_controller.dart';

class CreateSchoolStep1GeneralInformation extends StatefulWidget {
  final CreateSchoolStep1GeneralInformationController controller;

  const CreateSchoolStep1GeneralInformation(
      {super.key, required this.controller});

  @override
  State<CreateSchoolStep1GeneralInformation> createState() => _CreateSchoolStep1GeneralInformationState();
}

class _CreateSchoolStep1GeneralInformationState extends State<CreateSchoolStep1GeneralInformation> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'School Name',
              keyboardType: TextInputType.text,
              controller: widget.controller.schoolNameController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.business),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School ID (Unique Identifier)',
              keyboardType: TextInputType.text,
              controller: widget.controller.schoolIdController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.badge),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Established Year',
              keyboardType: TextInputType.number,
              controller: widget.controller.establishedYearController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.calendar_month),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Motto/Slogan',
              keyboardType: TextInputType.text,
              controller: widget.controller.schoolMottoController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.auto_awesome),

            ),
            const SizedBox(height: MySizes.lg),
            MyImagePickerField(
              image: widget.controller.image.value,
              onImageSelected: (File value) {
                widget.controller.image.value = value;
              },
            ),
            const SizedBox(height: MySizes.lg),
            MySelectionWidget(
              itemPadding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: MyLists
                  .schoolTypeOptions, // Options for academic levels

              onSelectionChanged: (val) {
                widget.controller.selectedSchoolType.value = val!;
              },

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'School Type',
              tag: 'school Type',

            ),

            const SizedBox(height: MySizes.lg),
            MySelectionWidget(
              itemPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: widget.controller
                  .mediumOfInstruction, // Options for academic levels
              selectedItem:
              widget.controller.selectedAcademicLevel.isNotEmpty
                  ? widget.controller.selectedAcademicLevel.value
                  : null,
              onSelectionChanged: (val) {
                widget.controller.selectedAcademicLevel.value = val!;
              },
              tag: 'mediun of instruction',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Medium of Instruction',
            ),
            const SizedBox(height: MySizes.lg),

            MySelectionWidget(
              itemPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: MyLists
                  .gradingSystemOptions, // Options for academic levels

              onSelectionChanged: (val) {
                widget.controller.selectedGradingSystem.value = val!;
              },
              tag: 'grading system',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Grading System',
            ),
            const SizedBox(height: MySizes.lg),
            MySelectionWidget(
              itemPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: MyLists.examPatternOptions, // Options for academic levels

              onSelectionChanged: (val) {
                widget.controller.selectedExaminationPattern.value = val!;
              },
              tag: 'exam pattern',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Examination Pattern',
            ),
            const SizedBox(height: MySizes.lg),

            // SchoolDropdownFormField(
            //   labelText: 'Affiliation Board (e.g., CBSE, ICSE)',
            //   items: SchoolLists.schoolBoardList,
            //   selectedValue: widget.controller.selectedSchoolType.value,
            //   onSelected: (value) {
            //     controller.selectedSchoolType.value = value;
            //   },
            // ),
            // const SizedBox(height: SchoolSizes.lg),
            // SchoolDropdownFormField(
            //   items: widget.controller.schoolTypes,
            //   labelText: 'School Type',
            //   isValidate: true,
            //   selectedValue: widget.controller.selectedSchoolType.value,
            //   onSelected: (value) {
            //     widget.controller.selectedSchoolType.value = value;
            //   },
            // ),
            // const SizedBox(height: SchoolSizes.lg),
            // SchoolDropdownFormField(
            //   items: widget.controller.mediumOfInstruction,
            //   labelText: 'Medium of Instruction (e.g., English, Hindi)',
            //   isValidate: true,
            //   selectedValue: widget.controller.selectedSchoolType.value,
            //   onSelected: (value) {
            //     widget.controller.selectedSchoolType.value = value;
            //   },
            // ),
            const SizedBox(height: MySizes.lg),


            MySelectionWidget(
              itemPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: widget.controller
                  .academicLevels, // Options for academic levels
              selectedItem:
              widget.controller.selectedAcademicLevel.isNotEmpty
                  ? widget.controller.selectedAcademicLevel.value
                  : null,
              onSelectionChanged: (val) {
                widget.controller.selectedAcademicLevel.value = val!;
              },
              tag: 'academic level',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Academic Level',
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolCardSelectionWidget extends StatelessWidget {
  final String text; // Title of the card
  final String? selectedItem; // Currently selected item
  final List<String> items; // List of selectable items
  final Function(String?) onSelectionChanged; // Callback for selection changes

  const SchoolCardSelectionWidget({
    super.key,
    required this.text,
    required this.selectedItem,
    required this.items,
    required this.onSelectionChanged, // Ensure callback is passed as required
  });

  @override
  Widget build(BuildContext context) {
    return MyCard(
      width: double.infinity,
      hasShadow: false,
      border: Border.all(width: 1, color: MyColors.borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the card
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Selection widget
          MySelectionWidget(
            itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            spacing: MySizes.md - 4,
            items: items, // Options for academic levels
            selectedItem: selectedItem,
            onSelectionChanged: onSelectionChanged, // Pass the callback
            selectionWidgetType: SelectionWidgetType.chip,
            tag: 'academic level',

          ),
        ],
      ),
    );
  }
}
