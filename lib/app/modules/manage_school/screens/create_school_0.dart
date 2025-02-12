
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/button.dart';
import '../controllers/create_school_0_controller.dart';
import '../widgets/stepper.dart';
import 'create_school_step_0.dart';
import 'create_school_step_1.dart';
import 'create_school_step_2.dart';
import 'create_school_step_3.dart';
import 'create_school_step_4.dart';
import 'create_school_step_5.dart';
import 'create_school_step_6.dart';
import 'create_school_step_7.dart';
import 'create_school_step_8.dart';

class CreateSchool0 extends StatefulWidget {
   const CreateSchool0({super.key});

  @override
  State<CreateSchool0> createState() => _CreateSchool0State();
}

class _CreateSchool0State extends State<CreateSchool0> {
  final CreateSchool0Controller studentController =
      Get.put(CreateSchool0Controller());

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create School'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.only(
                left: MySizes.lg,
                right: MySizes.lg,
                top: MySizes.lg),
            child: Column(
              children: [
                // Obx(() => SchoolStepper(
                //     activeStep: studentController.activeStep.value,
                //     noOfSteps: 5)),
                // const SizedBox(height: SchoolSizes.defaultSpace),
                Obx(
                  () => MyStepper(
                      activeStep: studentController.activeStep.value - 1,
                      noOfSteps: 8)
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Obx(
                //         () => TweenAnimationBuilder<double>(
                //           tween: Tween<double>(
                //             begin: 0.0,
                //             end: (studentController.activeStep.value) / 8,
                //           ),
                //           duration: const Duration(milliseconds: 500),
                //           builder: (context, value, child) {
                //             return ClipRRect(
                //               borderRadius:
                //                   BorderRadius.circular(10), // Rounded corners
                //               child: LinearProgressIndicator(
                //                 value: value,
                //                 valueColor: const AlwaysStoppedAnimation<Color>(
                //                     SchoolColors.activeBlue),
                //                 backgroundColor: SchoolDynamicColors.softGrey,
                //                 minHeight: 8,
                //                 borderRadius:
                //                     BorderRadius.circular(SchoolSizes.md),
                //               ),
                //             );
                //           },
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: SchoolSizes.md,
                //     ),
                //     Obx(
                //       () => Text(
                //         '${studentController.activeStep.value}/8',
                //         style: Theme.of(context).textTheme.titleLarge,
                //       ),
                //     )
                //   ],
                // ),
                 const SizedBox(height: MySizes.spaceBtwSections),

                Obx(
                  () => Column(
                    children: [
                      if (studentController.activeStep > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            studentController.getStepName(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      // const SizedBox(height: SchoolSizes.lg,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              //physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                studentController.activeStep.value = page;
              },
              controller: studentController.pageController,
              children: [
                const CreateSchoolStep0(),
                CreateSchoolStep1GeneralInformation(
                  controller: studentController.step1Controller,
                ),
                CreateSchoolStep2LocationDetails(
                  controller: studentController.step2Controller,
                ),
                CreateSchoolStep3ContactInformation(
                  controller: studentController.step3Controller,
                ),
                CreateSchoolStep4InfrastructureDetails(
                  controller: studentController.step4Controller,
                ),
                CreateSchoolStep5AcademicDetails(
                  //5-2
                  controller: studentController.step5Controller,
                ),
                CreateSchoolStep6AdministrativeInformation(
                  controller: studentController.step6Controller,
                ),
                CreateSchoolStep4AccreditationAndAchievements(
                  controller: studentController.step7Controller,
                ),
                const CreateSchoolStep8ExtracurricularDetails(
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: MySizes.lg,
              right: MySizes.lg,
              bottom: MySizes.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () => MyButton(
                      isOutlined: true,
                      text: 'Back',
                      onPressed: () {
                        if (studentController.activeStep.value > 0) {
                          studentController.decrementStep();
                        }
                      },
                      isDisabled: studentController.activeStep.value == 0
                          ? true
                          : false,
                    ),
                  ),
                ),
                const SizedBox(width: MySizes.lg),
                Expanded(
                  child: Obx(
                    () => MyButton(
                      text: 'Next',
                      onPressed: () {
                        if (studentController.activeStep.value <= 7) {
                          studentController.incrementStep();
                        }
                      },
                      isDisabled:
                          studentController.activeStep.value > 7 ? true : false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
