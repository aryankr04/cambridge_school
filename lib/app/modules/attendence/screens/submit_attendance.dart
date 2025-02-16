// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_school_app/common/widgets/elevated_button.dart';
// import 'package:my_school_app/features/user/teacher/attendence/controller/submit_attendance_controller.dart';
// import 'package:my_school_app/utils/helpers/helper_functions.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../student/attendence/attendence.dart';
//
// class SubmitAttendance extends StatefulWidget {
//   final String sectionId;
//   final String name;
//   final String className;
//
//   const SubmitAttendance({
//     Key? key,
//     required this.sectionId,
//     required this.name,
//     required this.className,
//   }) : super(key: key);
//
//   @override
//   _SubmitAttendanceState createState() => _SubmitAttendanceState();
// }
//
// class _SubmitAttendanceState extends State<SubmitAttendance> {
//   final SubmitAttendanceController _controller =
//       Get.put(SubmitAttendanceController());
//
//   late String sectionId;
//   late String sectionName;
//   late String className;
//
//   void initState() {
//     super.initState();
//
//     // Access parameters from widget property
//     sectionId = widget.sectionId;
//     sectionName = widget.name;
//     className = widget.className;
//
//     DateTime currentDate = DateTime.now();
//
//     String formattedDate =
//         "${currentDate.year}-${currentDate.month}-${currentDate.day}";
//     _controller.fetchClassAttendance(
//         sectionId, formattedDate, sectionName, 'SCH0000000001', className);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Submit Attendance'),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_rounded),
//         ),
//       ),
//       body: Obx(() => SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(SchoolSizes.lg),
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Today's Attendance Status",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineSmall
//                           ?.copyWith(color: SchoolDynamicColors.headlineTextColor),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ),
//                   Obx(
//                     () => Container(
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 2,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                         color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//                         borderRadius:
//                             BorderRadius.circular(SchoolSizes.cardRadiusSm),
//                         border: Border.all(
//                             width: 0.5, color: SchoolDynamicColors.borderColor),
//                       ),
//                       padding: const EdgeInsets.all(SchoolSizes.md),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AttendanceStatus(
//                             color: SchoolDynamicColors.activeGreen,
//                             title: 'Present - ',
//                             days: _controller.presentStudentsCount.value,
//                             total: _controller.totalStudentsCount.value,
//                           ),
//                           Container(
//                             width: 2,
//                             height: 100,
//                             color: SchoolDynamicColors.borderColor,
//                           ),
//                           AttendanceStatus(
//                             color: SchoolDynamicColors.activeRed,
//                             title: 'Absent - ',
//                             days: _controller.absentStudentsCount.value,
//                             total: _controller.totalStudentsCount.value,
//                           ),
//                           Container(
//                             width: 2,
//                             height: 100,
//                             color: SchoolDynamicColors.borderColor,
//                           ),
//                           AttendanceStatus(
//                             color: SchoolDynamicColors.activeBlue,
//                             title: 'Total - ',
//                             days: _controller.totalStudentsCount.value,
//                             total: _controller.totalStudentsCount.value,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.lg,
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Class $className - $sectionName",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineSmall
//                           ?.copyWith(color: SchoolDynamicColors.headlineTextColor),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.md,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//                       border: Border.all(
//                           width: 0.5, color: SchoolDynamicColors.borderColor),
//                       borderRadius:
//                           BorderRadius.circular(SchoolSizes.cardRadiusSm),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: SchoolSizes.md,
//                               horizontal: SchoolSizes.sm + 4),
//                           decoration: BoxDecoration(
//                             color: SchoolDynamicColors.backgroundColorTintLightGrey,
//                             border: Border.all(
//                                 width: 0.5, color: SchoolDynamicColors.borderColor),
//                             borderRadius: const BorderRadius.only(
//                                 topRight:
//                                     Radius.circular(SchoolSizes.cardRadiusSm),
//                                 topLeft:
//                                     Radius.circular(SchoolSizes.cardRadiusSm)),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   const SizedBox(
//                                     width: 60,
//                                   ),
//                                   Text("Name",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                               color: SchoolDynamicColors.headlineTextColor,
//                                               fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text("Present",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                               color: SchoolDynamicColors.headlineTextColor,
//                                               fontWeight: FontWeight.w500)),
//                                   const SizedBox(
//                                     width: SchoolSizes.md,
//                                   ),
//                                   Text("Absent",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                               color: SchoolDynamicColors.headlineTextColor,
//                                               fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: SchoolSizes.sm,
//                               horizontal: SchoolSizes.sm),
//                           decoration: BoxDecoration(
//                             color:
//                                 SchoolHelperFunctions.isDarkMode(Get.context!)
//                                     ? SchoolDynamicColors.darkerGreyBackgroundColor
//                                     : SchoolDynamicColors.activeOrangeTint,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   const SizedBox(
//                                     width: 60,
//                                   ),
//                                   Text("Mark All",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                               color: SchoolDynamicColors.headlineTextColor,
//                                               fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                               Obx(
//                                 () => Row(
//                                   children: [
//                                     GestureDetector(
//                                       behavior: HitTestBehavior.translucent,
//                                       onTap: () {
//                                         _controller
//                                             .toggleAttendanceForAll(true);
//                                         _controller.isPresentAll.value =
//                                             true; // Mark all absent
//                                         _controller.countPresentStudents();
//                                         _controller.countAbsentStudents();
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.all(
//                                             SchoolSizes.sm),
//                                         decoration: BoxDecoration(
//                                           color: _controller
//                                                   .areAllStudentsPresent()
//                                               ? SchoolDynamicColors.activeGreenTint
//                                               : SchoolDynamicColors.white,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: _controller
//                                                 .areAllStudentsPresent()
//                                             ? Icon(
//                                                 Icons.check_circle_outline,
//                                                 size: 24,
//                                                 color: SchoolDynamicColors.activeGreen,
//                                               )
//                                             : const Icon(
//                                                 Icons.circle_outlined,
//                                                 size: 24,
//                                                 color: SchoolDynamicColors.black,
//                                               ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 30,
//                                     ),
//                                     GestureDetector(
//                                       behavior: HitTestBehavior.translucent,
//                                       onTap: () {
//                                         _controller
//                                             .toggleAttendanceForAll(false);
//                                         _controller.isPresentAll.value = false;
//                                         _controller.countPresentStudents();
//                                         _controller.countAbsentStudents();
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.all(
//                                             SchoolSizes.sm),
//                                         decoration: BoxDecoration(
//                                           color: !_controller
//                                                   .areAllStudentsAbsent()
//                                               ? SchoolDynamicColors.white
//                                               : SchoolDynamicColors.activeRedTint,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: !_controller
//                                                 .areAllStudentsAbsent()
//                                             ? const Icon(
//                                                 Icons.circle_outlined,
//                                                 size: 24,
//                                                 color: SchoolDynamicColors.black,
//                                               )
//                                             : Icon(
//                                                 Icons.cancel,
//                                                 size: 24,
//                                                 color: SchoolDynamicColors.activeRed,
//                                               ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         _controller.isLoadingAttendance.value
//                             ? _buildShimmerStudentsList()
//                             : _controller.studentAttendanceList.isNotEmpty
//                                 ? Obx(
//                                     () => ListView.builder(
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemCount: _controller
//                                           .studentAttendanceList.length,
//                                       itemBuilder: (context, index) {
//                                         var student = _controller
//                                             .studentAttendanceList[index];
//                                         return AttendanceCard(
//                                           name: student.name,
//                                           id: student.studentId,
//                                           roll: student.roll,
//                                           isPresent: student.isPresent,
//                                           onMarkPresent: () {
//                                             _controller
//                                                 .toggleAttendanceForStudent(
//                                                     student.studentId);
//                                             student.isPresent.value = true;
//                                             _controller.countPresentStudents();
//                                             _controller.countAbsentStudents();
//                                           },
//                                           onMarkAbsent: () {
//                                             _controller
//                                                 .toggleAttendanceForStudent(
//                                                     student.studentId);
//                                             student.isPresent.value = false;
//                                             _controller.countPresentStudents();
//                                             _controller.countAbsentStudents();
//                                           },
//                                         );
//                                       },
//                                     ),
//                                   )
//                                 : Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     child: const Text('No Student Found!'))
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: SchoolSizes.lg,
//                   ),
//                   Obx(
//                     () => _controller.studentAttendanceList.isNotEmpty
//                         ? ElevatedButton(
//                             child: Text("Submit"),
//                             onPressed: _controller.isChange.value
//                                 ? () async {
//                                     SchoolHelperFunctions.showLoadingOverlay();
//                                     await _controller
//                                         .updateAllStudentAttendance(sectionId);
//                                     Get.back();
//                                     Get.back();
//                                   }
//                                 : null,
//                             // style: ButtonStyle(
//                             //   backgroundColor:
//                             //       MaterialStateProperty.resolveWith<Color>(
//                             //           (states) {
//                             //     if (states.contains(MaterialState.disabled)) {
//                             //       return Colors
//                             //           .grey; // Change the color when disabled
//                             //     }
//                             //     return Theme.of(context)
//                             //         .colorScheme
//                             //         .primary; // Default color when enabled
//                             //   }),
//                             // ),
//                           )
//                         : SizedBox(),
//                   )
//
//                   //_buildShimmerStudentsList()
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
//
//   Widget _buildShimmerStudentsList() {
//     return Shimmer.fromColors(
//       baseColor: SchoolDynamicColors.backgroundColorGreyLightGrey!,
//       highlightColor: SchoolDynamicColors.backgroundColorWhiteDarkGrey!,
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 6, // Number of shimmering items
//         itemBuilder: (context, index) {
//           return Card(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 height: 35,
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// class AttendanceCard extends StatelessWidget {
//   final String name;
//   final String id;
//   final String roll;
//   final RxBool isPresent;
//   final VoidCallback onMarkPresent;
//   final VoidCallback onMarkAbsent;
//
//   AttendanceCard({
//     super.key,
//     required this.name,
//     required this.id,
//     required this.roll,
//     required this.isPresent,
//     required this.onMarkPresent,
//     required this.onMarkAbsent,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           () => Container(
//         alignment: Alignment.centerLeft,
//         padding: const EdgeInsets.symmetric(
//           vertical: 12.0, // Fixed padding value
//           horizontal: 12.0, // Fixed padding value
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: SchoolDynamicColors.activeBlueTint, // Fixed color value
//                   child: Icon(
//                     Icons.person,
//                     color: SchoolDynamicColors.activeBlue, // Fixed color value
//                   ),
//                 ),
//                 const SizedBox(width: 12.0), // Fixed spacing value
//                 SizedBox(
//                   width: 170,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '$roll. ',
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 name,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 id,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: Theme.of(context).textTheme.labelMedium,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: isPresent.value ? onMarkAbsent : onMarkPresent,
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: isPresent.value
//                           ? SchoolDynamicColors.activeGreenTint
//                           : Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       isPresent.value
//                           ? Icons.check_circle_outline
//                           : Icons.circle_outlined,
//                       size: 24,
//                       color: isPresent.value ? SchoolDynamicColors.activeGreen : Colors.black, // Fixed color values
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 30),
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: isPresent.value ? onMarkAbsent : onMarkPresent,
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0), // Fixed padding value
//                     decoration: BoxDecoration(
//                       color: isPresent.value
//                           ? Colors.white
//                           : SchoolDynamicColors.activeRedTint, // Fixed color value
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       isPresent.value ? Icons.circle_outlined : Icons.cancel,
//                       size: 24,
//                       color: isPresent.value ? Colors.black : SchoolDynamicColors.activeRed, // Fixed color values
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
