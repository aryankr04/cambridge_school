// import 'package:cambridge_school/core/widgets/button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../core/utils/constants/sizes.dart';
// import '../../controllers/school_staff/add_school_staff0_controller.dart';
// import '../../widgets/stepper.dart';
// import 'employee_select_role_steps_1.dart';
// import 'employee_step0.dart';
// import 'employee_step1.dart';
// import 'employee_step2.dart';
// import 'employee_step3.dart';
// import 'employee_step4.dart';
// import 'employee_step5.dart';
//
// class AddEmployee extends StatefulWidget {
//   const AddEmployee({super.key});
//
//   @override
//   State<AddEmployee> createState() => _AddEmployeeState();
// }
//
// class _AddEmployeeState extends State<AddEmployee> {
//   final AddSchoolStaff0Controller teacherController =
//   Get.put(AddSchoolStaff0Controller());
//
//   // @override
//   // void dispose() {
//   //   // Clean up the controller when the widget is disposed
//   //   studentController.onClose();
//   //   super.dispose();
//   // }
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     // teacherController.pageController.jumpToPage(teacherController.activeStep.value);
//     teacherController.activeStep.value = 0;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Teacher'),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_rounded),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//                 left: SchoolSizes.defaultSpace,
//                 right: SchoolSizes.defaultSpace,
//                 top: SchoolSizes.defaultSpace),
//             child: Column(
//               children: [
//                 Obx(()=>  SchoolStepper(
//                     activeStep: teacherController.activeStep.value-1,
//                     noOfSteps: 5),),
//
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: Obx(
//                 //         () => TweenAnimationBuilder<double>(
//                 //           tween: Tween<double>(
//                 //             begin: 0.0,
//                 //             end: (teacherController.activeStep.value) / 6,
//                 //           ),
//                 //           duration: const Duration(milliseconds: 500),
//                 //           builder: (context, value, child) {
//                 //             return ClipRRect(
//                 //               borderRadius:
//                 //                   BorderRadius.circular(10), // Rounded corners
//                 //               child: LinearProgressIndicator(
//                 //                 value: value,
//                 //                 valueColor: const AlwaysStoppedAnimation<Color>(
//                 //                     SchoolColors.activeBlue),
//                 //                 backgroundColor: SchoolDynamicColors.grey,
//                 //                 minHeight: 8,
//                 //                 borderRadius:
//                 //                     BorderRadius.circular(SchoolSizes.md),
//                 //               ),
//                 //             );
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     const SizedBox(
//                 //       width: SchoolSizes.md,
//                 //     ),
//                 //     Obx(
//                 //       () => Text(
//                 //         '${teacherController.activeStep.value}/6',
//                 //         style: Theme.of(context).textTheme.titleLarge,
//                 //       ),
//                 //     )
//                 //   ],
//                 // ),
//                 const SizedBox(height: SchoolSizes.spaceBtwSections),
//
//                 Obx(
//                       () => Column(
//                     children: [
//                       if (teacherController.activeStep.value > 0)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             teacherController.getStepName(),
//                             style: Theme.of(context).textTheme.headlineSmall,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: PageView(
//               //physics: NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               onPageChanged: (int page) {
//                 teacherController.activeStep.value = page;
//               },
//               controller: teacherController.pageController,
//               children: [
//                 EmployeeStep0Form(),
//                 EmployeeSelectRoles(
//                     controller:
//                     teacherController.employeeSelectRolesController),
//                 EmployeeStep1Form(
//                   controller: teacherController.step1Controller,
//                 ),
//                 EmployeeStep2Form(
//                   controller: teacherController.step2Controller,
//                 ),
//                 EmployeeStep3Form(
//                   controller: teacherController.step3Controller,
//                 ),
//                 EmployeeStep4Form(
//                   controller: teacherController.step4Controller,
//                 ),
//                 EmployeeStep5Form(
//                   controller: teacherController.step5Controller,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: SchoolSizes.defaultSpace,
//               right: SchoolSizes.defaultSpace,
//               bottom: SchoolSizes.defaultSpace,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Obx(
//                         () => SchoolButton(
//                       text: 'Back',
//                       onPressed: () {
//                         if (teacherController.activeStep.value > 0) {
//                           teacherController.decrementStep();
//                         }
//                       },
//                       isDisabled: teacherController.activeStep.value == 0
//                           ? true
//                           : false,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: SchoolSizes.defaultSpace),
//                 Expanded(
//                   child: Obx(
//                         () => SchoolButton(
//                       text: 'Next',
//                       onPressed: () {
//                         if (teacherController.activeStep.value <= 5) {
//                           teacherController.incrementStep();
//                         }
//                       },
//                       isDisabled:
//                       teacherController.activeStep.value > 5 ? true : false,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
