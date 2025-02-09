// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../screens/employee/employee_select_role_steps_1.dart';
// import 'add_school_staff_step1_controller.dart';
// import 'add_school_staff_step2_controller.dart';
// import 'add_school_staff_step3_controller.dart';
// import 'add_school_staff_step4_controller.dart';
// import 'add_school_staff_step5_controller.dart';
//
// final List<String> stepNamesForEmployee = [
//   'Introduction to School Staff Registration',
//   'Select Roles',
//   'Basic Information',
//   'Employment Details',
//   'Educational Qualifications',
//   'Contact Information',
//   'Authentication'
// ];
//
// class AddSchoolStaff0Controller extends GetxController {
//   final EmployeeSelectRolesController employeeSelectRolesController=EmployeeSelectRolesController();
//   final SchoolStaffStep1FormController step1Controller =
//   SchoolStaffStep1FormController();
//   final SchoolStaffStep2FormController step2Controller =
//   SchoolStaffStep2FormController();
//   final SchoolStaffStep3FormController step3Controller =
//   SchoolStaffStep3FormController();
//   final SchoolStaffStep4FormController step4Controller =
//   SchoolStaffStep4FormController();
//   final SchoolStaffStep5FormController step5Controller =
//   SchoolStaffStep5FormController();
//
//   RxInt activeStep = 0.obs;
//   late final PageController pageController =
//   PageController(initialPage: activeStep.value);
//
//   String getStepName() => stepNamesForEmployee[activeStep.value];
//
//   void incrementStep() async {
//     if (activeStep.value < stepNamesForEmployee.length - 1) {
//       bool isValid = [
//         true,
//         employeeSelectRolesController.selectedRoles.isNotEmpty?true:false,
//         step1Controller.isFormValid(),
//         step2Controller.isFormValid(),
//         step3Controller.isFormValid(),
//         step4Controller.isFormValid(),
//         step5Controller.isFormValid(),
//       ][activeStep.value];
//
//       if (isValid) {
//         activeStep.value++;
//         pageController.jumpToPage(activeStep.value);
//       } else {
//         print('Form is not valid for step $activeStep');
//       }
//     } else {
//       // await addStudentToFirebase();
//     }
//   }
//
//   void decrementStep() {
//     if (activeStep.value > 0) {
//       activeStep.value--;
//       pageController.jumpToPage(activeStep.value);
//     }
//   }
//
//   // Future<void> addStudentToFirebase() async {
//   //   try {
//   //     SchoolHelperFunctions.showLoadingOverlay();
//   //     String? selectedSchool = step2Controller.selectedSchoolController.text;
//   //     if (selectedSchool == null) return;
//   //
//   //     String? studentId =
//   //     await firebaseFunction.generateNewIdWithPrefix('STU', 'students');
//   //     if (studentId == null) return;
//   //
//   //     // final profileImageUrl = await FirebaseHelperFunction.uploadImage(
//   //     //   imageFile: step7Controller.profileImage.value!,
//   //     //   imageName: studentId,
//   //     //   folder: 'student_profile_images',
//   //     // );
//   //
//   //
//   //
//   //     await FirebaseFirestore.instance
//   //         .collection('students')
//   //         .doc(studentId)
//   //         .set(student.toJson());
//   //     SchoolHelperFunctions.showSuccessSnackBar('Student added successfully!');
//   //   } catch (e) {
//   //     print('Error adding student: $e');
//   //     SchoolHelperFunctions.showErrorSnackBar(
//   //         'Error adding student. Please try again.');
//   //   } finally {
//   //     Get.back();
//   //   }
//   // }
//
//   @override
//   void onClose() {
//     step1Controller.onClose();
//     step2Controller.onClose();
//     step3Controller.onClose();
//     step4Controller.onClose();
//     step5Controller.onClose();
//
//     super.onClose();
//   }
//
//   double ftToCm(int ft, double inch) => ((ft * 12) + inch) * 2.54;
// }
