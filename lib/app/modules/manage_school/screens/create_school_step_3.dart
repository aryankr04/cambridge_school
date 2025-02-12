import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../core/widgets/text_field.dart';
import '../controllers/create_school_step_3_controller.dart';

class CreateSchoolStep3ContactInformation extends StatelessWidget {
  final CreateSchoolStep3ContactInformationController controller ;

  const CreateSchoolStep3ContactInformation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Primary Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.primaryPhoneNumberController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                PatternValidator(r'^\+?[0-9]{7,15}$',
                    errorText: 'Enter a valid phone number')
              ]).call,
              suffixIcon: const Icon(Icons.phone),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Secondary Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.secondaryPhoneNumberController,
              validator: PatternValidator(r'^\+?[0-9]{7,15}$',
                  errorText: 'Enter a valid phone number')
                  .call, // Optional field
              suffixIcon: const Icon(Icons.phone),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailAddressController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                EmailValidator(errorText: 'Enter a valid email address')
              ]).call,
              suffixIcon: const Icon(Icons.email),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Website',
              keyboardType: TextInputType.url,
              controller: controller.websiteController,
              validator: PatternValidator(
                r'^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$',
                errorText: 'Enter a valid website URL',
              ).call,
              suffixIcon: const Icon(Icons.web),

            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Fax Number (if applicable)',
              keyboardType: TextInputType.phone,
              controller: controller.faxNumberController,
              validator: null, // Optional field
              suffixIcon: const Icon(Icons.print),

            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }


}
