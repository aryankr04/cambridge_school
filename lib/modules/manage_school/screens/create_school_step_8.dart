import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/modules/manage_school/controllers/create_school_0_controller.dart';
import 'package:cambridge_school/modules/manage_school/screens/create_school_step_0.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/text_field.dart';

class CreateSchoolStep8ExtracurricularDetails extends StatelessWidget {
  const CreateSchoolStep8ExtracurricularDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateSchool0Controller>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Form(
          // key: controller.step8FormKey, // Add the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyButton(text: 'Create New School', onPressed: controller.addSchoolToFirebase),
              const SizedBox(height: MySizes.lg,),
              // SchoolTextFormField(
              //   labelText: 'Clubs and Societies',
              //   keyboardType: TextInputType.text,
              //   controller: controller.step8ClubsController, // access through `controller`
              //   validator:
              //   RequiredValidator(errorText: 'This field is required').call,
              //   suffixIcon: const Icon(Icons.diversity_3),
              //
              // ),
              // const SizedBox(height: SchoolSizes.lg,),
              //
              // SchoolTextFormField(
              //   labelText: 'Sports Teams',
              //   keyboardType: TextInputType.text,
              //   controller: controller.step8SportsTeamsController, // access through `controller`
              //   validator:
              //   RequiredValidator(errorText: 'This field is required').call,
              //   suffixIcon: const Icon(Icons.sports_baseball),
              //
              // ),
              // const SizedBox(height: SchoolSizes.lg,),
              //
              // SchoolTextFormField(
              //   labelText: 'Annual Events (e.g., Annual Day, Sports Day)',
              //   keyboardType: TextInputType.text,
              //   controller: controller.step8AnnualEventsController, // access through `controller`
              //   validator:
              //   RequiredValidator(errorText: 'This field is required').call,
              //   suffixIcon: const Icon(Icons.celebration),
              //
              // ),
              // const SizedBox(height: SchoolSizes.lg,),
              // SchoolTextFormField(
              //   labelText: 'Community Service Initiatives',
              //   keyboardType: TextInputType.text,
              //   controller: controller.step8CommunityServiceController, // access through `controller`
              //   validator:
              //   RequiredValidator(errorText: 'This field is required').call,
              //   suffixIcon: const Icon(Icons.volunteer_activism),
              //
              // ),
              // const SizedBox(height: SchoolSizes.lg,),
              //
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 8.0),
              //   child: Text(
              //     'Examples for Reference:',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: SchoolSizes.lg),
              //   ),
              // ),
              // const Text('- Clubs: Science Club, Debate Club, Eco Club'),
              // const Text(
              //     '- Annual Events: Annual Day, Sports Day, Science Fair'),
              // const Text(
              //     '- Community Service: Cleanliness Drives, Tree Plantation'),
            ],
          ),
        ),
      ),
    );
  }
}