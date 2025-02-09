import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/modules/auth/register/controllers/student/add_student_step0_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step8_controller.dart';

class StudentStep8Form extends StatelessWidget {
  const StudentStep8Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep8FormController>();
    final controllerStep0 = Get.find<AddStudent0Controller>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step8FormKey,
          child: Column(
            children: <Widget>[
              MyTextField(
                labelText: 'Mobile No.',
                suffixIcon: const Icon(Icons.phone_android),
                keyboardType: TextInputType.phone,
                controller: controller.mobileNoController,
                validator:MultiValidator([
                  RequiredValidator(errorText: ''),
                  LengthRangeValidator(min: 10,max: 10,
                      errorText: 'Enter valid mobile no.'),
                ]).call ,
              ),
              const SizedBox(
                height: MySizes.defaultSpace,
              ),
              MyTextField(
                labelText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailAddressController,
                validator: MultiValidator([
                  RequiredValidator(errorText: ''),
                  EmailValidator(
                      errorText: 'Enter valid email address'),
                ]).call,
              ),
              const SizedBox(
                height: MySizes.defaultSpace,
              ),
              MyTextField(
                labelText: 'Username',
                keyboardType: TextInputType.name,
                controller: controller.usernameController,
                validator: RequiredValidator(errorText: '').call,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              Obx(
                    () => MyTextField(
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.passwordController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: ''),
                    MinLengthValidator(8, errorText: 'Minimum 8 characters required'),
                  ]).call,
                  obscureText: controller.isObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isObscure.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      controller.isObscure.value = !controller.isObscure.value;
                    },
                  ),
                ),
              ),
              const SizedBox(height: MySizes.lg,),
              MyButton(text: 'Register', onPressed: controllerStep0.registerStudent)
            ],
          ),
        ),
      ),
    );
  }
}