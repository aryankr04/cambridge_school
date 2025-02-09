// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import '../../../../../core/utils/constants/sizes.dart';
// import '../../../../../core/widgets/date_picker_field.dart';
// import '../../../../../core/widgets/text_field.dart';
// import '../../controllers/school_staff/add_school_staff_step2_controller.dart';
//
// class EmployeeStep2Form extends StatelessWidget {
//   final SchoolStaffStep2FormController controller;
//
//   const EmployeeStep2Form({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(SchoolSizes.defaultSpace),
//         child: Form(
//           key: controller.step2FormKey,
//           child: Column(
//             children: <Widget>[
//               DatePickerField(
//                 firstDate: DateTime(2000),
//                 labelText: 'Date of Joining',
//                 lastDate: DateTime.now(), controller: controller.dateOfJoiningController,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//
//               SchoolTextFormField(
//                 onTap: controller.showRolesSelectionDialog,
//                 readOnly: true,
//                 labelText: "Roles",
//                 hintText: "Select Roles",
//                 controller: controller.rolesController,
//                 validator: RequiredValidator(errorText: '').call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//
//
//
//               SchoolTextFormField(
//                 // onTap: controller.showLanguagesSelectionDialog,
//                 readOnly: true,
//                 labelText: "Skills",
//                 keyboardType: TextInputType.name,
//                 controller: controller.skillsController,
//                 validator: RequiredValidator(errorText: '').call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//
//               SchoolTextFormField(
//                 onTap: controller.showLanguagesSelectionDialog,
//                 readOnly: true,
//                 labelText: "Language Spoken",
//                 hintText: "Select Languages",
//                 controller: controller.languagesController,
//                 validator: RequiredValidator(errorText: '').call,
//               ),
//
//               //const SizedBox(height: SchoolSizes.defaultSpace),
//               // SchoolTextFormField(
//               //   // onTap: controller.showLanguagesSelectionDialog,
//               //   readOnly: true,
//               //   labelText: "Subject Taught",
//               //   hintText: "Select Subjects",
//               //   keyboardType: TextInputType.name,
//               //   controller: controller.subjectTaughtController,
//               //   validator: RequiredValidator(errorText: ''),
//               // ),
//               // const SizedBox(height: SchoolSizes.defaultSpace),
//
//               // SchoolTextFormField(
//               //   // onTap: controller.showLanguagesSelectionDialog,
//               //   readOnly: true,
//               //   labelText: "Extra Curricular Roles",
//               //   hintText: "Select Languages",
//               //   keyboardType: TextInputType.name,
//               //   controller: controller.extraCurricularRolesController,
//               //   validator: RequiredValidator(errorText: ''),
//               // ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
