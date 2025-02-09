import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/date_picker_field.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step1_controller.dart';

class StudentStep1Form extends StatefulWidget {
  const StudentStep1Form({
    super.key,
  });

  @override
  State<StudentStep1Form> createState() => _StudentStep1FormState();
}

class _StudentStep1FormState extends State<StudentStep1Form> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep1FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Form(
          key: controller.step1FormKey,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      labelText: 'First Name',
                      keyboardType: TextInputType.name,
                      controller: controller.firstNameController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                  ),
                  const SizedBox(
                    width: MySizes.lg,
                  ),
                  Expanded(
                    child: MyTextField(
                      labelText: 'Last Name',
                      keyboardType: TextInputType.name,
                      controller: controller.lastNameController,
                      validator: RequiredValidator(errorText: '').call,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MySizes.lg),

              const SizedBox(height: MySizes.lg),
              MyDropdownField(
                options: MyLists.genderOptions,
                labelText: 'Gender',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedGender.value = value!;
                },
                selectedValue: controller.selectedGender,
              ),
              const SizedBox(height: MySizes.lg),
              MyDropdownField(
                options: MyLists.nationalityOptions,
                labelText: 'Nationality',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedNationality.value = value!;
                },
                selectedValue: controller.selectedNationality,
              ),
              const SizedBox(height: MySizes.lg),
              MyDropdownField(
                options: MyLists.religionOptions,
                labelText: 'Religion',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedReligion.value = value!;
                },
                selectedValue: controller.selectedReligion,
              ),
              const SizedBox(height: MySizes.lg),
              MyDropdownField(
                options: MyLists.categoryOptions,
                labelText: 'Category',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedCategory.value = value!;
                },
                selectedValue: controller.selectedCategory,
              ),
              const SizedBox(height: MySizes.lg),
              MyTextField(
                onTap: controller.showLanguagesSelectionDialog,
                readOnly: true,
                labelText: "Language Spoken",
                hintText: "Select Languages",
                keyboardType: TextInputType.name,
                controller: controller.languagesController,
                validator: RequiredValidator(errorText: '').call,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
