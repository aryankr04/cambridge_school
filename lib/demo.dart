import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo'),),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Center(
          child: Column(
            children: [
              MyButton(
                  text: 'Create User',
                  onPressed: () {
                    Get.toNamed(AppRoutes.createUser);
                  }),
              const SizedBox(
                height: MySizes.md,
              ),
              MyButton(
                  text: 'Onboarding Screen',
                  onPressed: () {
                    Get.toNamed(AppRoutes.onboarding);
                  }),
              const SizedBox(
                height: MySizes.md,
              ),
              MyButton(
                  text: 'Class Management',
                  onPressed: () {
                    Get.toNamed(AppRoutes.classManagement);
                  }),
              const SizedBox(
                height: MySizes.md,
              ),
              MyButton(
                  text: 'User Management',
                  onPressed: () {
                    Get.toNamed(AppRoutes.userManagement);
                  }),
              const SizedBox(
                height: MySizes.md,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
