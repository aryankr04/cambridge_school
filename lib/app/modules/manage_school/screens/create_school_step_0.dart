import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';

final List<String> stepNamesForCreateSchool = [
  'Introduction to Create a School',
  'General Information',
  'Location Details',
  'Contact Information',
  'Infrastructure Details',
  'Administrative Information',
  'Academic Details',
  'Accreditation and Achievements',
  'Extracurricular Details'
];

class CreateSchoolStep0 extends StatelessWidget {
  const CreateSchoolStep0({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
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
            const SizedBox(
              height: MySizes.lg,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome! This registration will guide you through 8 simple steps to set up your school profile with essential details about its identity, infrastructure, curriculum, academics. This process ensures that all critical information is recorded to create a comprehensive and effective profile for your institution.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400,color: MyColors.subtitleTextColor),
                  ),
                ),
                // SvgPicture.asset(
                //   'assets/images/illustration/sign_up_cuate.svg',
                //   height: 150,
                //   fit: BoxFit.fill,
                // )
              ],
            ),
            const SizedBox(
              height: MySizes.spaceBtwSections,
            ),
            Text(
              "Create School in 8 Easy Steps",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
            ),
            const SizedBox(
              height: MySizes.md-8
              ,
            ),
            stepInfoRow(stepNamesForCreateSchool[1]),
            stepInfoRow(stepNamesForCreateSchool[2]),
            stepInfoRow(stepNamesForCreateSchool[3]),
            stepInfoRow(stepNamesForCreateSchool[4]),
            stepInfoRow(stepNamesForCreateSchool[5]),
            stepInfoRow(stepNamesForCreateSchool[6]),
            stepInfoRow(stepNamesForCreateSchool[7]),
            stepInfoRow(stepNamesForCreateSchool[8]),
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
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
