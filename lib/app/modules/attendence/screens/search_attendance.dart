// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:get/get.dart';
//
// import '../../../../../common/widgets/dropdown_form_feild.dart';
// import '../../../../../common/widgets/elevated_button.dart';
// import '../../../../../common/widgets/text_form_feild.dart';
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/lists.dart';
// import '../../../../../utils/constants/sizes.dart';
//
// class SearchAttendance extends StatelessWidget {
//   const SearchAttendance({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Attendance'),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_rounded),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(SchoolSizes.lg),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Search Attendance',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineSmall
//                       ?.copyWith(color: SchoolDynamicColors.headlineTextColor),
//                 ),
//               ),
//               const SizedBox(
//                 height: SchoolSizes.defaultSpace,
//               ),
//               SchoolDropdownFormField(
//                 items: SchoolLists.classList,
//                 labelText: 'Class',
//                 isValidate: true,
//                 //selectedValue: controller.selectedClassController.value,
//                 onSelected: (value) {
//                   //controller.selectedClassController.value = value!;
//                 },
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolDropdownFormField(
//                 items: SchoolLists.classList,
//                 labelText: 'Section',
//                 isValidate:true,
//                 //selectedValue: controller.selectedClassController.value,
//                 onSelected: (value) {
//                   //controller.selectedClassController.value = value!;
//                 },
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolTextFormField(
//                 //controller: controller.nameController,
//                 labelText: 'Roll No',
//                 keyboardType: TextInputType.name,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolElevatedButton(text: 'Search Attendance', onPressed: () {})
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
