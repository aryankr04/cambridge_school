import 'package:flutter/material.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/school_staff/add_school_staff_step5_controller.dart';

class EmployeeStep5Form extends StatelessWidget {
  final SchoolStaffStep5FormController controller;

  const EmployeeStep5Form({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step5FormKey,
          child: Column(
            children: <Widget>[

              MyTextField(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
                controller: controller.usernameController,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: const Icon(Icons.visibility_off),
                controller: controller.passwordController,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyButton(text: 'Register', onPressed: (){})
            ],
          ),
        ),
      ),
    );
  }
}
