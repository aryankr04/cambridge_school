//
// import 'package:flutter/material.dart';
//
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
//
// class SubjectCard extends StatelessWidget {
//   final String subject;
//   final IconData iconData; // Add this line
//   final VoidCallback? onDelete;
//
//   SubjectCard({
//     required this.subject,
//     required this.iconData, // Add this line
//     this.onDelete,
//   }) : super();
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
//                 child: Icon(
//                   iconData,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: SchoolSizes.spaceBtwItems),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     subject,
//                     style: Theme.of(context).textTheme.titleMedium,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.edit),
//                 color: SchoolDynamicColors.primaryColor,
//               ),
//               IconButton(
//                 onPressed: onDelete,
//                 icon: const Icon(Icons.delete_rounded),
//                 color: SchoolDynamicColors.activeRed,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
