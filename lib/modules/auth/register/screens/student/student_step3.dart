import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';

import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step3_controller.dart';

class StudentStep3Form extends StatelessWidget {

  const StudentStep3Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep3FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step3FormKey,
          child: Column(
            children: <Widget>[



              MyTextField(
                labelText: 'House Address',
                validator: RequiredValidator(errorText: '').call,
                controller: controller.houseAddressController,
              ),
              const SizedBox(
                height: MySizes.defaultSpace,
              ),
              MyTextField(
                labelText: 'Pin Code',
                validator: RequiredValidator(errorText: '').call,
                controller: controller.pinCodeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: MySizes.defaultSpace,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.errorMessage.value}'));
                }else{
                  return   MyDropdownField(
                    options: controller.countries,
                    labelText: 'Country',
                    isValidate: true,
                    onSelected: (value) => controller.onCountrySelected(value!),
                    selectedValue: controller.selectedCountry,

                  );
                }
              }),
              const SizedBox(height: MySizes.defaultSpace),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.errorMessage.value}'));
                }else{
                  return MyDropdownField(
                    options: controller.states,
                    labelText: 'State',
                    isValidate: true,
                    onSelected: (value) => controller.onStateSelected(value!),
                    selectedValue: controller.selectedState,
                  );
                }
              }),
              const SizedBox(height: MySizes.defaultSpace),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.errorMessage.value}'));
                }else{
                  return MyDropdownField(
                    options: controller.cities,
                    labelText: 'City',
                    isValidate: true,
                    selectedValue: controller.selectedCity,
                    onSelected: (val){},
                  );
                }
              }),
              const SizedBox(height: MySizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
