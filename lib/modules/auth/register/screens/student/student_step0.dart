import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../controllers/student/add_student0_controller.dart';

class StudentStep0Form extends StatelessWidget {
  const StudentStep0Form({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> stepNamesForStudent = [
      'Introduction to Student Registration',
      'Basic Information',
      'Academic Information',
      'Address Information',
      'Parental/Guardian Information',
      'Physical and Health Information',
      'Favorites and Personal Interests',
      'Document Uploads',
      'Authentication'
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Registration in 8 Easy Steps",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
            stepInfoRow(stepNamesForStudent[1]),
            stepInfoRow(stepNamesForStudent[2]),
            stepInfoRow(stepNamesForStudent[3]),
            stepInfoRow(stepNamesForStudent[4]),
            stepInfoRow(stepNamesForStudent[5]),
            stepInfoRow(stepNamesForStudent[6]),
            stepInfoRow(stepNamesForStudent[7]),
            stepInfoRow(stepNamesForStudent[8]),
          ],
        ),
      ),
    );
  }

  Widget stepInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: MyDynamicColors.activeBlue,
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          Text(
            text,
            style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(),
          ),
        ],
      ),
    );
  }
}
