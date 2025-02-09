import 'package:cambridge_school/modules/auth/register/screens/student/student_step0.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step1.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step2.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step3.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step4.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step5.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step6.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step7.dart';
import 'package:cambridge_school/modules/auth/register/screens/student/student_step8.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/button.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../widgets/stepper.dart';

class AddStudent extends StatelessWidget {
  const AddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController = Get.put(AddStudent0Controller());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: MySizes.defaultSpace,
                right: MySizes.defaultSpace,
                top: MySizes.defaultSpace),
            child: Column(
              children: [

                Obx(()=>  SchoolStepper(
                    activeStep: studentController.activeStep.value-1,
                    noOfSteps: 8),),

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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                studentController.activeStep.value = page;
              },
              controller: studentController.pageController,
              // physics: const NeverScrollableScrollPhysics(),
              children: const [
                StudentStep0Form(),
                StudentStep1Form(),
                StudentStep2Form(),
                StudentStep3Form(),
                StudentStep4Form(),
                StudentStep5Form(),
                StudentStep6Form(),
                StudentStep7Form(),
                StudentStep8Form(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: MySizes.defaultSpace,
              right: MySizes.defaultSpace,
              bottom: MySizes.defaultSpace,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                        () => MyButton(
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
                const SizedBox(width: MySizes.defaultSpace),
                Expanded(
                  child: Obx(
                        () => MyButton(
                      text: 'Next',
                      onPressed: () async {
                        await studentController.incrementStep();
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