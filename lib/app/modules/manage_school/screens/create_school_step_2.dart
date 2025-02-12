import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_2_controller.dart';

class CreateSchoolStep2LocationDetails extends StatelessWidget {
  final CreateSchoolStep2LocationDetailsController controller;

  const CreateSchoolStep2LocationDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Address',
              keyboardType: TextInputType.text,
              controller: controller.addressController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.location_on),

            ),

            const SizedBox(height: MySizes.lg),

            MyTextField(
              labelText: 'Country',
              keyboardType: TextInputType.text,
              controller: controller.countryController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.public),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'State',
              keyboardType: TextInputType.text,
              controller: controller.stateController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.map),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'District',
              keyboardType: TextInputType.text,
              controller: controller.districtController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.map),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'City',
              keyboardType: TextInputType.text,
              controller: controller.cityController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.location_city),

            ),
            const SizedBox(height: MySizes.lg),

            MyTextField(
              labelText: 'ZIP Code',
              keyboardType: TextInputType.number,
              controller: controller.zipCodeController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.numbers),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Street',
              keyboardType: TextInputType.text,
              controller: controller.streetController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.add_road),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Nearby Landmarks',
              keyboardType: TextInputType.text,
              controller: controller.landmarksNearbyController,
              validator: null, // Optional field
              suffixIcon: const Icon(Icons.temple_hindu),
            ),


          ],
        ),
      ),
    );
  }
}
