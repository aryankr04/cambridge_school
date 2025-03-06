//
// // Helper function to build average boxes
// Widget _buildAverageBox(String label, double value, Color color) {
//   return Expanded(
//     child: Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color, width: 1),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "$value%",
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//             height: MySizes.md -
//                 4), // Add space between the text container and progress bar
//         LinearProgressIndicator(
//           value: value / 100, // Use the parameter value
//           minHeight: MySizes.sm - 2,
//           backgroundColor: color.withOpacity(0.1),
//           valueColor: AlwaysStoppedAnimation<Color>(
//               color), // Use the same color for the progress bar
//           borderRadius:
//           const BorderRadius.all(Radius.circular(MySizes.md)),
//         ),
//       ],
//     ),
//   );
// }
//
// Container buildYourAverageVsClassAverage(BuildContext context) {
//   return Container(
//     padding: const EdgeInsets.all(MySizes.md),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           spreadRadius: 1,
//           blurRadius: 3,
//           offset: const Offset(0, 3),
//         ),
//       ],
//       color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//       border: Border.all(width: .5, color: MyDynamicColors.borderColor),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section 1: Average vs Class Average
//         const Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Your Average vs Class Average",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: MyColors.headlineTextColor,
//             ),
//           ),
//         ),
//         const SizedBox(height: MySizes.md),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildAverageBox(
//                 "Your Average",
//                 controller.getStudentAttendancePercentageForUI(),
//                 Colors.green),
//             Container(
//               margin: const EdgeInsets.only(bottom: MySizes.md),
//               padding: const EdgeInsets.symmetric(horizontal: 8.0 + 4),
//               child: CircleAvatar(
//                   backgroundColor: MyColors.activeRed.withOpacity(0.1),
//                   child: Text(
//                     'VS',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontSize: 16,
//                         color: Colors.red,
//                         fontWeight: FontWeight.w600),
//                   )),
//             ),
//             // const SizedBox(
//             //   width: MySizes.md,
//             // ),
//             _buildAverageBox("Class Average",
//                 controller.averageClassAttendance.value, Colors.blue),
//           ],
//         ),
//         const SizedBox(height: 20),
//
//         Row(
//           children: [
//             Icon(
//               controller.getStudentAttendancePercentageForUI() >=
//                   controller.averageClassAttendance.value
//                   ? Icons.trending_up
//                   : Icons.trending_down,
//               color:  controller.getStudentAttendancePercentageForUI() >=
//                   controller.averageClassAttendance.value
//                   ? Colors.green
//                   : Colors
//                   .red, // Green for positive, Red for negative
//             ),
//             const SizedBox(width: 8),
//             Text(
//               "Difference: ${ controller.getStudentAttendancePercentageForUI() >= controller.averageClassAttendance.value ? '+${ controller.getStudentAttendancePercentageForUI() - controller.averageClassAttendance.value}%' : '${ controller.getStudentAttendancePercentageForUI() - controller.averageClassAttendance.value}%'} vs Class",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color:  controller.getStudentAttendancePercentageForUI() >=
//                     controller.averageClassAttendance.value
//                     ? Colors.green
//                     : Colors
//                     .red, // Color matching the icon
//                 fontStyle: FontStyle.italic, // Added italics for emphasis
//               ),
//             ),
//           ],
//         ),
//
//         // Progress Bar (if needed for visualization)
//       ],
//     ),
//   );
// }
//
// Container buildRankOverview() {
//   return Container(
//     padding: const EdgeInsets.all(MySizes.md),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           spreadRadius: 1,
//           blurRadius: 10,
//           offset: const Offset(0, 5),
//         ),
//       ],
//       color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//       border: Border.all(width: 0.5, color: MyDynamicColors.borderColor),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section 2: Rank Header
//         const Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Rank Overview",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: MyColors.headlineTextColor,
//             ),
//           ),
//         ),
//         const SizedBox(height: MySizes.md),
//
//         // Row for student and top ranks with icons
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildRankBox(
//                 "Your Rank",
//                 controller.getStudentRank(),
//                 controller.getStudentAttendancePercentageForUI(),
//                 Colors.orangeAccent),
//             _buildRankBox("Top Rank", 1,controller.getTopStudentAttendancePercentage(), Colors.blueAccent),
//           ],
//         ),
//         const SizedBox(height: 20),
//
//         // Rank Breakdown with progress bars
//         const Text(
//           "Rank Breakdown",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 10),
//         ...buildRankDistributionRows(controller.studentRankings),
//       ],
//     ),
//   );
// }
//
// Widget _buildRankBox(String label, int rank, double percentage, Color color) {
//   return Container(
//     padding: const EdgeInsets.symmetric(
//         horizontal: MySizes.sm + 4, vertical: 12),
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//     ),
//     child: Row(
//       children: [
//         // Rank Icon
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           child: Icon(
//             rank == 1
//                 ? Icons.emoji_events
//                 : Icons.emoji_events_outlined
//                 : Icons.star_border,
//             key: ValueKey<int>(rank),
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//         const SizedBox(width: MySizes.sm),
//
//         // Rank and Percentage Information
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "$label: $rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : rank == 3 ? 'rd' : 'th'}",
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             Row(
//               children: [
//                 Text(
//                   "${percentage.toStringAsFixed(1)}%",
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// RxBool isExpanded = false.obs;
//
// Color _getRankColor(String rank) {
//   int rankInt = int.tryParse(rank) ?? 0;
//   if (rankInt == 1) {
//     return Colors.green; // Top rank
//   } else if (rankInt == 2) {
//     return Colors.blue; // Second rank
//   } else {
//     return Colors.red; // Lower ranks
//   }
// }
//
// // Function to build rank distribution rows
// List<Widget> buildRankDistributionRows(List<StudentRanking> rankingList) {
//   List<Widget> rankDistributionRows = [];
//
//   // Filter out students with rank 1 or 2 initially
//   List<StudentRanking> topRanks = rankingList.where((student) {
//     int rank = rankingList.indexOf(student) + 1;
//     return rank <= 2; // Only include students with rank 1 or 2
//   }).toList();
//
//   // Limit based on 'isExpanded' (show top 2 or all students with rank 2 or higher)
//   int limit = isExpanded.value ? rankingList.length : topRanks.length;
//
//   for (var i = 0; i < limit; i++) {
//     final student = rankingList[i];
//     String name = student.student.fullName ?? '';
//     String id = student.student.userId ?? '';
//     String rank = (rankingList.indexOf(student)+1).toString();
//     String percentage = student.percentage.toString();
//
//     // Set color based on rank
//     Color color = _getRankColor(rank);
//
//     // Add the row widget to the list
//     rankDistributionRows.add(
//       _buildRankDistributionRow(name, id, rank, percentage, color),
//     );
//   }
//
//   // Add the "See All" button if there are more than 2 items
//   if (rankingList.length > topRanks.length) {
//     rankDistributionRows.add(
//       Align(
//           alignment: Alignment.centerRight,
//           child: Obx(() => TextButton(
//             onPressed: () {
//               isExpanded.value =
//               !isExpanded.value; // Toggle the expanded state
//             },
//             child: Text(isExpanded.value ? 'See Less' : 'See All'),
//           ))),
//     );
//   }
//
//   return rankDistributionRows;
// }
//
// Widget _buildRankDistributionRow(
//     String name,
//     String id,
//     String rank,
//     String percentage,
//     Color color,
//     ) {
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//       color: controller.studentId.value == id
//           ? color.withOpacity(0.1)
//           : Colors.transparent,
//     ),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           // Profile Icon with Circle and Background Color
//           Container(
//               padding: const EdgeInsets.all(8 + 4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: color.withOpacity(0.2), // Light background for icon
//               ),
//               child: Text(
//                 rank == '1'
//                     ? "1st"
//                     : rank == '2'
//                     ? "2nd"
//                     : rank == '3'
//                     ? "3rd"
//                     : rank, // Handle other ranks
//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge
//                     ?.copyWith(color: color),
//               )),
//           const SizedBox(
//               width:
//               12), // Increased width for better spacing between the icon and text
//
//           // Text Column with name and ID
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   controller.studentId.value == id ? 'You' : name,
//                   style: const TextStyle(
//                     fontSize:
//                     14, // Increased font size for better readability
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 // SizedBox(height: 4), // Spacing between name and ID
//                 Text(
//                   id,
//                   style: Theme.of(context).textTheme.labelMedium,
//                 ),
//               ],
//             ),
//           ),
//
//           // Progress Percentage Display (assuming static 78.3% for now)
//           const SizedBox(width: 12),
//           Text(
//             '${percentage}%',
//             style: const TextStyle(
//               fontSize: 14, // Font size for percentage
//               fontWeight: FontWeight.w600,
//               color: MyColors
//                   .headlineTextColor, // Use the passed color for the percentage text
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
