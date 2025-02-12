import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_6_controller.dart';

class CreateSchoolStep6AdministrativeInformation extends StatelessWidget {
  final CreateSchoolStep6AdministrativeInformationController controller;

  const CreateSchoolStep6AdministrativeInformation(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Principal’s Name',
              keyboardType: TextInputType.text,
              controller: controller.principalNameController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Vice-Principal’s Name',
              keyboardType: TextInputType.text,
              controller: controller.vicePrincipalNameController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Head of Administration',
              keyboardType: TextInputType.text,
              controller: controller.headOfAdministrationController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: MySizes.lg),

            MyTextField(
              labelText: 'Affiliation/Registration Number',
              keyboardType: TextInputType.text,
              controller: controller.affiliationRegistrationNumberController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.group),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText:
                  'School Management Authority (e.g., Trust, Society, Individual)',
              keyboardType: TextInputType.text,
              controller: controller.schoolManagementAuthorityController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.admin_panel_settings),
            ),
          ],
        ),
      ),
    );
  }
}
