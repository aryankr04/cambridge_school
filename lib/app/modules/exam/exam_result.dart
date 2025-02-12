// import 'package:cambridge_school/core/utils/constants/colors.dart';
// import 'package:cambridge_school/core/utils/constants/lists.dart';
// import 'package:cambridge_school/core/utils/constants/sizes.dart';
// import 'package:cambridge_school/core/widgets/card_widget.dart';
// import 'package:cambridge_school/core/widgets/detail_card_widget.dart';
// import 'package:cambridge_school/core/widgets/divider.dart';
// import 'package:cambridge_school/core/widgets/dropdown_field.dart';
// import 'package:cambridge_school/core/widgets/label_chip.dart';
// import 'package:cambridge_school/core/widgets/text_field.dart';
// import 'package:flutter/material.dart';
//
// class CreateResultScreen extends StatefulWidget {
//   const CreateResultScreen({super.key});
//
//   @override
//   _CreateResultScreenState createState() => _CreateResultScreenState();
// }
//
// class _CreateResultScreenState extends State<CreateResultScreen> {
//   String selectedExam = '';
//   String selectedClass = '';
//   List<String> students = [
//     "John Doe",
//     "Jane Smith",
//     "Sam Wilson"
//   ]; // Example student list
//   List<SubjectInput> subjects = [
//     SubjectInput(
//         name: "Math",
//         categories: [
//           CategoryInput(name: "Theory", marks: 70),
//           CategoryInput(name: "Practical", marks: 30),
//         ],
//         totalMarks: 100),
//     SubjectInput(
//         name: "Science",
//         categories: [
//           CategoryInput(name: "Theory", marks: 80),
//           CategoryInput(name: "Lab", marks: 20),
//         ],
//         totalMarks: 100),
//   ];
//
//   void saveResults() {
//     // Save results to Firestore or other backend
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Exam Result"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SchoolDropdownFormField(
//               labelText: 'Exam',
//               items: SchoolLists.examList,
//               onSelected: (value) {
//                 setState(() {
//                   selectedClass = value;
//                 });
//               },
//             ),
//             const SizedBox(height: SchoolSizes.md),
//             SchoolDropdownFormField(
//               labelText: 'Class',
//               items: SchoolLists.classList,
//               onSelected: (value) {
//                 setState(() {
//                   selectedClass = value!;
//                 });
//               },
//             ),
//             const SizedBox(height: SchoolSizes.md),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: students.length,
//                 itemBuilder: (context, index) {
//                   return StudentResultCard(
//                     studentName: students[index],
//                     subjects: subjects,
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: saveResults,
//               child: const Text("Save Results"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class StudentResultCard extends StatefulWidget {
//   final String studentName;
//   final List<SubjectInput> subjects;
//
//   const StudentResultCard(
//       {super.key, required this.studentName, required this.subjects});
//
//   @override
//   _StudentResultCardState createState() => _StudentResultCardState();
// }
//
// class _StudentResultCardState extends State<StudentResultCard> {
//   Map<String, Map<String, int>> marks = {};
//   List<List<FocusNode>> focusNodes = [];
//
//   @override
//   void initState() {
//     super.initState();
//     for (var subject in widget.subjects) {
//       marks[subject.name] = {};
//       List<FocusNode> subjectFocusNodes = [];
//       for (var category in subject.categories) {
//         marks[subject.name]![category.name] = 0;
//         subjectFocusNodes.add(FocusNode()); // Add a FocusNode for each category
//       }
//       focusNodes.add(subjectFocusNodes); // Add focus nodes for each subject
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose of all the focus nodes to prevent memory leaks
//     for (var subjectFocusNodes in focusNodes) {
//       for (var focusNode in subjectFocusNodes) {
//         focusNode.dispose();
//       }
//     }
//     super.dispose();
//   }
//   List<String> feeCategories = [
//     // Recurring Fees
//     "Tuition", // (Monthly/Annually)
//     "Sports", // (Monthly/Annually)
//     "Laboratory", // (Monthly/Annually)
//     "Transport", // (distance-based)
//     "Hostel", // (Monthly/Annually)
//     "Maintenance/Development fees", // (Monthly/Annually)
//
//     // One-Time Fees
//     "Admission",
//     "Re-Admission",
//     "Registration",
//     "Security Deposit", // (Refundable)
//
//     // As-Needed Fees
//     "Excursion/Field Trip",
//     "ID Card", // (Lost or replacement)
//     "Late Fee",
//     "Books & Stationery",
//     "Meal Plan",
//     "Special Events", // (Annual Function, Sports Day)
//     "Uniform", // (for purchase)
//
//     // Facility-Based Fees
//     "Transport", // (varies by distance)
//     "Hostel", // (boarding students only)
//     "Library" // (optional for specific students)
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SchoolDetailCard(
//       color: SchoolColors.activeOrange,
//       action: const SchoolLabelChip(
//         text: 'Incomplete',
//         color: SchoolColors.activeRed,
//       ),
//       title: widget.studentName,
//       titleStyle: Theme.of(context).textTheme.titleLarge,
//       iconWidget: Text(
//         '1',
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge
//             ?.copyWith(color: SchoolColors.activeOrange, fontSize: 18),
//       ),
//       subtitle: 'Roll no: 1',
//       hasDivider: false,
//       widget: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: widget.subjects.map((subject) {
//                 int subjectIndex = widget.subjects.indexOf(subject);
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           subject.name,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(fontSize: 15),
//                         ),
//                         const Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                             child: SchoolDottedLine(
//                               dashLength: 4,
//                               dashGapLength: 4,
//                               lineThickness: 1,
//                               dashColor: Colors.grey,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '100 Marks',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(
//                                   fontSize: 13, fontWeight: FontWeight.w400),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: subject.categories.asMap().entries.map((entry) {
//                         int categoryIndex = entry.key;
//                         var category = entry.value;
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${category.name} (${category.marks})',
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                             SizedBox(
//                               width: 80,
//                               child: SchoolTextFormField(
//                                 height: 36,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 hintText: 'Marks',
//                                 textAlign: TextAlign.center,
//                                 keyboardType: TextInputType.number,
//                                 focusNode: focusNodes[subjectIndex]
//                                     [categoryIndex], // Assign correct FocusNode
//                                 textInputAction: TextInputAction.next,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     marks[subject.name]![category.name] =
//                                         int.tryParse(value) ?? 0;
//                                   });
//                                 },
//                                 onFieldSubmitted: (value) {
//                                   // Move focus to the next field
//                                   if (categoryIndex <
//                                       subject.categories.length - 1) {
//                                     FocusScope.of(context).requestFocus(
//                                         focusNodes[subjectIndex]
//                                             [categoryIndex + 1]);
//                                   } else if (subjectIndex <
//                                       widget.subjects.length - 1) {
//                                     // If this is the last category, move to the next subject
//                                     FocusScope.of(context).requestFocus(
//                                         focusNodes[subjectIndex + 1][0]);
//                                   }
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                     if (subjectIndex != widget.subjects.length - 1)
//                       const SizedBox(
//                         height: SchoolSizes.md,
//                       ),
//                   ],
//                 );
//               }).toList(),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: SchoolSizes.sm,),
//                 Row(
//                   children: [
//                     Text(
//                       'Overall',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge
//                           ?.copyWith(fontSize: 15),
//                     ),
//                     const Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8.0),
//                         child: SchoolDottedLine(
//                           dashLength: 4,
//                           dashGapLength: 4,
//                           lineThickness: 1,
//                           dashColor: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: SchoolSizes.sm,),
//
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: SchoolColors.activeBlue.withOpacity(0.1),
//                       child: const Icon(
//                         Icons.assignment_turned_in,
//                         color: SchoolColors.activeBlue,
//                         size: 18,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: SchoolSizes.md,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '314',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(height: 1),
//                         ),
//                         Text(
//                           'Total Marks Obtained',
//                           style: Theme.of(context)
//                               .textTheme
//                               .labelLarge
//                               ?.copyWith(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: SchoolColors.captionTextColor),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: SchoolSizes.md,
//                 ),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: SchoolColors.activeBlue.withOpacity(0.1),
//                       child: const Icon(
//                         Icons.percent_rounded,
//                         color: SchoolColors.activeBlue,
//                         size: 18,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: SchoolSizes.md,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '68.45%',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(height: 1),
//                         ),
//                         Text(
//                           'Overall Percentage',
//                           style: Theme.of(context)
//                               .textTheme
//                               .labelLarge
//                               ?.copyWith(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: SchoolColors.captionTextColor),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: SchoolSizes.md,
//                 ),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: SchoolColors.activeBlue.withOpacity(0.1),
//                       child: const Icon(
//                         Icons.grade_rounded,
//                         color: SchoolColors.activeBlue,
//                         size: 18,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: SchoolSizes.md,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'B+',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(height: 1),
//                         ),
//                         Text(
//                           'Grade',
//                           style: Theme.of(context)
//                               .textTheme
//                               .labelLarge
//                               ?.copyWith(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: SchoolColors.captionTextColor),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// class SubjectInput {
//   String name = '';
//   int totalMarks = 0;
//   List<CategoryInput> categories = [];
//
//   SubjectInput({this.name = '', this.totalMarks = 0, List<CategoryInput>? categories})
//       : categories = categories ?? [];
// }
//
// class CategoryInput {
//   String name = '';
//   int marks = 0;
//
//   CategoryInput({this.name = '', this.marks = 0});
// }
