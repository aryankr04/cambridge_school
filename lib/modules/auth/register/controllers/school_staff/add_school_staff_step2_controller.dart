// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../core/utils/constants/dynamic_colors.dart';
// import '../../../../../core/utils/constants/lists.dart';
// import '../../../../../core/utils/constants/sizes.dart';
// import '../../../../../core/widgets/selection_widget.dart';
//
// class SchoolStaffStep2FormController extends GetxController {
//   final step2FormKey = GlobalKey<FormState>();
//
//   TextEditingController dateOfJoiningController = TextEditingController();
//
//
//   TextEditingController rolesController = TextEditingController();
//   RxList<String> selectedRoles = <String>[].obs;
//
//   RxList<String> selectedDesignations = <String>[].obs;
//   TextEditingController designationsController = TextEditingController();
//
//   RxList<String> selectedSkills = <String>[].obs;
//   TextEditingController skillsController = TextEditingController();
//
//   RxList<String> selectedLanguages = <String>[].obs;
//   TextEditingController languagesController = TextEditingController();
//
//   RxList<String> selectedSubjectTaught = <String>[].obs;
//   TextEditingController subjectTaughtController = TextEditingController();
//
//   Future<void> showLanguagesSelectionDialog() async {
//     await showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           backgroundColor: Colors.white,
//           title: const Text('Select Languages'),
//           content: Container(
//             width: Get.width,
//             color: Colors.white,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SchoolSelectionWidget(
//                     items: SchoolLists.languagesSpoken,
//                     isMultiSelect: true,
//                     selectedItem: selectedLanguages.isNotEmpty
//                         ? selectedLanguages.first
//                         : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedLanguages.assignAll(selectedItems);
//                     },
//                     displayTextBuilder: (item) =>
//                         item, // Simple display text builder
//                     selectedColor: Colors.green,
//                     // unselectedColor: Colors.grey[300],
//                   ),
//                   // MultiSelectionWidget(
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.languagesSpoken,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedLanguages.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedLanguages,
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   // Make the button take up the available width
//                   child: InkWell(
//                     onTap: () {
//                       languagesController.text = selectedLanguages.join(', ');
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       padding:
//                           const EdgeInsets.symmetric(vertical: SchoolSizes.md),
//                       decoration: BoxDecoration(
//                         color: SchoolDynamicColors.activeBlue,
//                         borderRadius:
//                             BorderRadius.circular(SchoolSizes.cardRadiusXs),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'OK',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge
//                             ?.copyWith(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> showSkillsSelectionDialog() async {
//     await showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           backgroundColor: Colors.white,
//           title: const Text('Select Languages'),
//           content: Container(
//             width: Get.width,
//             color: Colors.white,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SchoolSelectionWidget(
//                     items: SchoolLists.languagesSpoken,
//                     isMultiSelect: true,
//                     selectedItem: selectedLanguages.isNotEmpty
//                         ? selectedLanguages.first
//                         : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedLanguages.assignAll(selectedItems);
//                     },
//                     displayTextBuilder: (item) =>
//                         item, // Simple display text builder
//                     selectedColor: Colors.green,
//                     // unselectedColor: Colors.grey[300],
//                   ),
//                   // MultiSelectionWidget(
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.languagesSpoken,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedLanguages.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedLanguages,
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   // Make the button take up the available width
//                   child: InkWell(
//                     onTap: () {
//                       languagesController.text = selectedLanguages.join(', ');
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       padding:
//                           const EdgeInsets.symmetric(vertical: SchoolSizes.md),
//                       decoration: BoxDecoration(
//                         color: SchoolDynamicColors.activeBlue,
//                         borderRadius:
//                             BorderRadius.circular(SchoolSizes.cardRadiusXs),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'OK',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge
//                             ?.copyWith(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> showRolesSelectionDialog() async {
//     await showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           backgroundColor: Colors.white,
//           title: const Text('Select Languages'),
//           content: Container(
//             width: Get.width,
//             color: Colors.white,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Leadership and Administration',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ),
//                   SchoolSelectionWidget(
//                     items: SchoolLists.leadershipAndAdministration,
//                     isMultiSelect: true,
//                     selectedItem:
//                         selectedRoles.isNotEmpty ? selectedRoles.first : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedRoles.assignAll(selectedItems);
//                     },
//                   ),
//                   // MultiSelectionWidget(
//                   //
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.leadershipAndAdministration,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedRoles.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedRoles,
//                   // ),
//                   const SizedBox(
//                     height: SchoolSizes.lg,
//                   ),
//                   Text(
//                     'Academic and Teaching Staff',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ), SchoolSelectionWidget(
//                     items: SchoolLists.academicAndTeachingStaff,
//                     isMultiSelect: true,
//                     selectedItem:
//                     selectedRoles.isNotEmpty ? selectedRoles.first : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedRoles.assignAll(selectedItems);
//                     },
//                   ),
//                   // MultiSelectionWidget(
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.academicAndTeachingStaff,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedRoles.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedRoles,
//                   // ),
//                   const SizedBox(
//                     height: SchoolSizes.lg,
//                   ),
//                   Text(
//                     'Student Support Services',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ),
//                   SchoolSelectionWidget(
//                     items: SchoolLists.studentSupportServices,
//                     isMultiSelect: true,
//                     selectedItem:
//                     selectedRoles.isNotEmpty ? selectedRoles.first : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedRoles.assignAll(selectedItems);
//                     },
//                   ),
//                   // MultiSelectionWidget(
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.studentSupportServices,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedRoles.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedRoles,
//                   // ),
//                   const SizedBox(
//                     height: SchoolSizes.lg,
//                   ),
//                   Text(
//                     ' Operations and Technical Support',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ),
//                   SchoolSelectionWidget(
//                     items: SchoolLists.operationsAndTechnicalSupport,
//                     isMultiSelect: true,
//                     selectedItem:
//                     selectedRoles.isNotEmpty ? selectedRoles.first : null,
//                     onMultiSelectChanged: (List<String> selectedItems) {
//                       selectedRoles.assignAll(selectedItems);
//                     },
//                   ),
//                   // MultiSelectionWidget(
//                   //   showSelectAll: false,
//                   //   options: SchoolLists.operationsAndTechnicalSupport,
//                   //   onSelectionChanged: (selectedItems) {
//                   //     selectedRoles.assignAll(selectedItems);
//                   //   },
//                   //   selectedItems: selectedRoles,
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   // Make the button take up the available width
//                   child: InkWell(
//                     onTap: () {
//                       rolesController.text = selectedRoles.join(', ');
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       padding:
//                           const EdgeInsets.symmetric(vertical: SchoolSizes.md),
//                       decoration: BoxDecoration(
//                         color: SchoolDynamicColors.activeBlue,
//                         borderRadius:
//                             BorderRadius.circular(SchoolSizes.cardRadiusXs),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'OK',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge
//                             ?.copyWith(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   void updateFormValidity() {}
//
//   bool isFormValid() {
//     return step2FormKey.currentState?.validate() ?? false;
//   }
// }
