// import 'package:flutter/material.dart';
//
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
//
// class SectionCard extends StatelessWidget {
//   String section;
//   String classTeacherName;
//   int numberOfStudents;
//   final VoidCallback? onDelete;
//   final VoidCallback? onEdit;
//
//   SectionCard({
//     Key? key,
//     required this.section,
//     required this.classTeacherName,
//     required this.numberOfStudents,
//     this.onDelete, this.onEdit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(SchoolSizes.sm),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: SchoolDynamicColors.primaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusSm),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: SchoolDynamicColors.primaryColor,
//                   borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusSm),
//                 ),
//                 child: Text(
//                   section,
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: SchoolSizes.spaceBtwItems),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     classTeacherName,
//                     style: Theme.of(context).textTheme.titleMedium,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                   Text(
//                     '$numberOfStudents Students',
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelLarge
//                         ?.copyWith(color: SchoolDynamicColors.subtitleTextColor),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: onEdit,
//                 icon: const Icon(Icons.edit),
//                 color: SchoolDynamicColors.primaryColor,
//               ),
//               IconButton(
//                 onPressed: onDelete,
//                 icon: const Icon(Icons.delete_rounded),
//                 color: SchoolDynamicColors.activeRed,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
