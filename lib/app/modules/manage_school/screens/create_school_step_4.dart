import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/selection_widget.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_4_controller.dart';

class CreateSchoolStep4InfrastructureDetails extends StatelessWidget {
  final CreateSchoolStep4InfrastructureDetailsController controller ;

  const CreateSchoolStep4InfrastructureDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            MyTextField(
              labelText: 'Campus Size (in acres/sq ft)',
              keyboardType: TextInputType.number,
              controller: controller.campusSizeController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.crop_free),

            ),
            const SizedBox(height: MySizes.lg),

            MyTextField(
              labelText: 'Number of Buildings',
              keyboardType: TextInputType.number,
              controller: controller.numberOfBuildingsController,
              validator: null, // Optional for now
              suffixIcon: const Icon(Icons.apartment),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Number of Floors',
              keyboardType: TextInputType.number,
              controller: controller.numberOfFloorsController,
              validator: null, // Optional for now
              suffixIcon: const Icon(Icons.layers),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Total Number of Classrooms',
              keyboardType: TextInputType.number,
              controller: controller.totalClassroomsController,
              validator: null, // Optional for now
              suffixIcon: const Icon(Icons.meeting_room),

            ),
            const SizedBox(height: MySizes.lg),

            MySelectionWidget(
              itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: controller.availableFacilities, // Options for sports facilities
              isMultiSelect: true,
              onMultiSelectChanged: (List<String> val) {
                // Ensure the selected values are updated correctly
                controller.selectedAvailableFacilities.assignAll(val);
              },                      tag: 'available facilities',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Facilities Available',
            ),



            const SizedBox(height: MySizes.lg),
            MySelectionWidget(
              itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: controller.availableLaboratories, // Options for sports facilities
              isMultiSelect: true,
              onMultiSelectChanged: (List<String> val) {
                // Ensure the selected values are updated correctly
                controller.selectedLaboratories.assignAll(val);
              },                      tag: 'laboratories available',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Laboratories Available',
            ),

            const SizedBox(height: MySizes.lg),
            MySelectionWidget(
              itemPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              spacing: MySizes.md - 4,
              items: controller.availableSportsFacilities, // Options for sports facilities
              isMultiSelect: true,
              onMultiSelectChanged: (List<String> val) {
                // Ensure the selected values are updated correctly
                controller.selectedSportsFacilities.assignAll(val);
              },                      tag: 'sports facilities available',

              selectionWidgetType: SelectionWidgetType.chip,
              title: 'Sports Facilities Available',
            ),


          ],
        ),
      ),
    );
  }


}
