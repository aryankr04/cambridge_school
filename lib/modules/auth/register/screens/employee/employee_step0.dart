import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';

class EmployeeStep0Form extends StatelessWidget {
  final List<String> stepNamesForEmployee = [
    'Introduction to Teacher Registration',
    'Basic Information',
    'Employment Details',
    'Educational Qualifications',
    'Contact Information',
    'Authentication'
  ];

  EmployeeStep0Form({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Introduction to Student Registration',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome! This registration will guide you through 5 simple steps to create your teacher profile with essential information about your background and academics.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/illustration/sign_up_cuate.svg',
                  height: 150,
                  fit: BoxFit.fill,
                )
              ],
            ),
            Text(
              "Registration in 5 Easy Steps",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
            stepInfoRow(stepNamesForEmployee[1]),
            stepInfoRow(stepNamesForEmployee[2]),
            stepInfoRow(stepNamesForEmployee[3]),
            stepInfoRow(stepNamesForEmployee[4]),
            stepInfoRow(stepNamesForEmployee[5]),
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
            style: Theme.of(Get.context!)
                .textTheme
                .titleLarge
            ,
          ),
        ],
      ),
    );
  }
}
