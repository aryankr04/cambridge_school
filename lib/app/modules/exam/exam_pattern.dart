// import 'package:cambridge_school/core/utils/constants/colors.dart';
// import 'package:cambridge_school/core/utils/constants/sizes.dart';
// import 'package:cambridge_school/core/widgets/detail_card_widget.dart';
// import 'package:cambridge_school/core/widgets/dialog.dart';
// import 'package:cambridge_school/core/widgets/dropdown_field.dart';
// import 'package:cambridge_school/core/widgets/text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/widgets/button.dart';
// import 'controllers/exam_pattern_controller.dart';
// import 'models/exam_pattern_model.dart';
//
// class AddExamScreen extends StatelessWidget {
//   final AddExamController controller = Get.put(AddExamController());
//
//   AddExamScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Exam'),
//       ),
//       body: Obx(
//         () => SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SchoolTextFormField(
//                 labelText: 'Exam Name',
//                 initialValue: controller.examPattern.value.examName.value,
//                 onChanged: (value) =>
//                     controller.examPattern.value.examName.value = value,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: SchoolDropdownFormField(
//                       labelText: 'Class',
//                       initialValue: controller.examPattern.value.classId.value,
//                       onSelected: (value) =>
//                           controller.examPattern.value.classId.value = value,
//                       items: const [
//                         'Class 1',
//                         'Class 2',
//                         'Class 3',
//                       ], // Replace with your dynamic list of classes
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: SchoolDropdownFormField(
//                       labelText: 'Section',
//                       initialValue: controller.examPattern.value.section.value,
//                       onSelected: (value) =>
//                           controller.examPattern.value.section.value = value,
//                       items: const [
//                         'A',
//                         'B',
//                         'C',
//                       ], // Replace with your dynamic list of sections
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Text('Subjects'),
//               const SizedBox(height: 8),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: controller.examPattern.value.subjects.length,
//                 itemBuilder: (context, index) {
//                   final subject = controller.examPattern.value.subjects[index];
//                   return SchoolDetailCard(
//                     title: subject.name.value,
//                     subtitle: 'Total Marks: ${subject.totalMarks.value}',
//                     hasExpandedIcon: false,
//                     action: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit,color: SchoolColors.activeBlue,),
//                           onPressed: () =>
//                               _showAddSubjectDialog(context, isEditing: true, subject: subject,index: index),
//                         ),
//                         const SizedBox(width: SchoolSizes.sm),
//                         IconButton(
//                           icon: const Icon(Icons.delete,color: SchoolColors.activeRed,),
//                           onPressed: () => controller.removeSubject(index),
//                         ),
//                       ],
//                     ),
//                     widget: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Wrap(
//                         spacing: 8.0, // Horizontal spacing between children
//                         runSpacing: 4.0, // Vertical spacing between rows
//                         children: subject.categories.map((category) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     category.name,
//                                     style: Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                                 Text(
//                                   category.marksController.text,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//
//                                         color: SchoolColors.headlineTextColor,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextButton.icon(
//                 onPressed: () => _showAddSubjectDialog(context),
//                 label: const Text('Add Subject'),
//                 icon: Icon(Icons.add,),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showAddSubjectDialog(BuildContext context,
//       {bool isEditing = false, int? index, Subject? subject}) {
//     final nameController = TextEditingController();
//     final marksController = TextEditingController();
//     final categories = <Category>[].obs;
//
//     // Initialize data for editing
//     if (isEditing && subject != null) {
//       nameController.text = subject.name.value;
//       marksController.text = subject.totalMarks.toString();
//       categories.assignAll(subject.categories);
//     }
//
//     SchoolDialog.show(
//       'Add Subject',
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SchoolTextFormField(
//             controller: nameController,
//             labelText: 'Subject Name',
//           ),
//           const SizedBox(height: 8),
//           SchoolTextFormField(
//             controller: marksController,
//             labelText: 'Total Marks',
//             keyboardType: TextInputType.number,
//           ),
//           Obx(() => Column(
//                 children: categories
//                     .asMap()
//                     .entries
//                     .map(
//                       (entry) => Row(
//                         children: [
//                           Expanded(
//                             child: SchoolDropdownFormField(
//                               labelText: "Category",
//                               items: const [
//                                 'Theory',
//                                 'Practical',
//                                 'Assignment',
//                                 'Viva'
//                               ],
//                               onSelected: (value) =>
//                                   categories[entry.key] = Category(
//                                 name: value,
//                                 marksController:
//                                     categories[entry.key].marksController,
//                               ),
//                               initialValue: entry.value.name,
//                             ),
//                           ),
//                           const SizedBox(width: SchoolSizes.md),
//                           Expanded(
//                             child: SchoolTextFormField(
//                               controller: entry.value.marksController,
//                               labelText: "Marks",
//                               keyboardType: TextInputType.number,
//                               onChanged: (value) =>
//                                   entry.value.marksController.text = value,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete,
//                                 color: SchoolColors.activeRed),
//                             onPressed: () => categories.removeAt(entry.key),
//                           ),
//                         ],
//                       ),
//                     )
//                     .toList(),
//               )),
//           Align(
//             alignment: Alignment.centerRight,
//             child: TextButton.icon(
//               icon: const Icon(Icons.add),
//               label: const Text("Add Category"),
//               onPressed: () {
//                 categories.add(Category(
//                   name: '',
//                   marksController: TextEditingController(),
//                 ));
//               },
//             ),
//           ),
//           const SizedBox(height: SchoolSizes.md),
//           Row(
//             children: [
//               Expanded(
//                 child: SchoolButton(
//                   onPressed: () => Get.back(),
//                   text: 'Cancel',
//                   isOutlined: true,
//                 ),
//               ),
//               const SizedBox(width: SchoolSizes.md),
//               Expanded(
//                 child: SchoolButton(
//                   onPressed: () {
//                     final subjectName = nameController.text.trim();
//                     final totalMarks = marksController.text.trim();
//
//                     if (subjectName.isEmpty ||
//                         totalMarks.isEmpty ||
//                         categories.isEmpty) {
//                       // You can add your error handling logic here
//                       return;
//                     }
//
//                     final subjectController = Subject(
//                       name: subjectName,
//                       totalMarks: totalMarks,
//                       categories: categories
//                           .map((category) => Category(
//                                 name: category.name,
//                                 marksController: category.marksController,
//                               ))
//                           .toList(),
//                     );
//
//                     if (isEditing) {
//                       controller.updateSubject(index!, subjectController);
//                     } else {
//                       controller.addSubject(subjectController);
//                     }
//                     Get.back();
//                   },
//                   text: 'Save',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//
//     // Ensure controllers are disposed when dialog is closed
//     // Get.backCallback = () {
//     //   nameController.dispose();
//     //   marksController.dispose();
//     //   categories.forEach((category) {
//     //     category.marksController.dispose();
//     //   });
//     // };
//   }
//
// }
