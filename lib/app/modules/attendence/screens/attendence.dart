// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_school_app/common/widgets/color_chips.dart';
// import 'package:my_school_app/features/user/teacher/attendence/screens/search_attendance.dart';
// import 'package:my_school_app/features/user/teacher/attendence/screens/submit_attendance.dart';
// import 'package:my_school_app/utils/helpers/helper_functions.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import 'my_submit_attendance.dart';
//
// class SectionInfo {
//   final String sectionId;
//   final String sectionName;
//   final String className;
//   final bool isClassAttendanceSubmitted;
//   final int totalPresentStudents;
//   final int totalAbsentStudents;
//   final String teacherName;
//   final String teacherId;
//
//   SectionInfo({
//     required this.sectionId,
//     required this.sectionName,
//     required this.className,
//     required this.isClassAttendanceSubmitted,
//     required this.totalPresentStudents,
//     required this.totalAbsentStudents,
//     required this.teacherName,
//     required this.teacherId,
//   });
// }
//
// class TAttendanceController extends GetxController {
//   final RxList<SectionInfo> sectionsData = <SectionInfo>[].obs;
//   final RxBool isLoadingAttendance = false.obs;
//
//   void fetchSectionsInfo(String schoolId) async {
//     try {
//       isLoadingAttendance(true);
//       DateTime currentDate = DateTime.now();
//       String formattedDate =
//           "${currentDate.year}-${currentDate.month}-${currentDate.day}";
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('sections')
//           .where('schoolId', isEqualTo: schoolId)
//           .get();
//
//       List<SectionInfo> sectionsInfo = [];
//
//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         final sectionId = doc.id;
//         final sectionName = doc.get('sectionName') as String? ?? '';
//         final className = doc.get('className') as String? ?? '';
//
//         DocumentSnapshot attendanceSnapshot = await FirebaseFirestore.instance
//             .collection('attendance')
//             .doc(sectionId)
//             .collection('dates')
//             .doc(formattedDate)
//             .get();
//
//         if (attendanceSnapshot.exists) {
//           final totalPresentStudents =
//               attendanceSnapshot.get('totalPresentStudents') as int? ?? 0;
//           final totalAbsentStudents =
//               attendanceSnapshot.get('totalAbsentStudents') as int? ?? 0;
//           final isClassAttendanceSubmitted =
//               attendanceSnapshot.get('isClassAttendanceSubmitted') as bool? ??
//                   false;
//           final teacherName =
//               attendanceSnapshot.get('teacherName') as String? ?? '';
//           final teacherId =
//               attendanceSnapshot.get('teacherId') as String? ?? '';
//
//           sectionsInfo.add(SectionInfo(
//             sectionId: sectionId,
//             sectionName: sectionName,
//             className: className,
//             isClassAttendanceSubmitted: isClassAttendanceSubmitted,
//             totalPresentStudents: totalPresentStudents,
//             totalAbsentStudents: totalAbsentStudents,
//             teacherName: teacherName,
//             teacherId: teacherId,
//           ));
//         } else {
//           sectionsInfo.add(SectionInfo(
//             sectionId: sectionId,
//             sectionName: sectionName,
//             className: className,
//             isClassAttendanceSubmitted: false,
//             totalPresentStudents: 0,
//             totalAbsentStudents: 0,
//             teacherName: '',
//             teacherId: '',
//           ));
//         }
//       }
//
//       sectionsData.assignAll(sectionsInfo);
//       final Map<String, int> classNameOrder = {
//         'Pre Nursery': 0,
//         'Nursery': 1,
//         'LKG': 2,
//         'UKG': 3,
//         '1': 4,
//         '2': 5,
//         '3': 6,
//         '4': 7,
//         '5': 8,
//         '6': 9,
//         '7': 10,
//         '8': 11,
//         '9': 12,
//         '10': 13,
//         '11': 14,
//         '12': 15,
//       };
//
// // Sort the sectionsData list based on the custom order of class names
//       sectionsData.sort((a, b) {
//         int classOrderA = classNameOrder[a.className] ?? -1;
//         int classOrderB = classNameOrder[b.className] ?? -1;
//
//         // Compare by the custom order of class names
//         if (classOrderA != classOrderB) {
//           return classOrderA.compareTo(classOrderB);
//         } else {
//           // If class names are the same, compare by sectionName
//           return a.sectionName.compareTo(b.sectionName);
//         }
//       });
//
//       isLoadingAttendance(false);
//     } catch (e) {
//       print('Error fetching sections: $e');
//       sectionsData.clear();
//       isLoadingAttendance(false);
//     }
//   }
//
//   void onSubmitPressed(String sectionId, String name, String className) {
//     Get.to(
//       MySubmitAttendance(
//
//       ),
//     );
//   }
// }
//
// class TAttendance extends StatefulWidget {
//   const TAttendance({Key? key}) : super(key: key);
//
//   @override
//   State<TAttendance> createState() => _TAttendanceState();
// }
//
// class _TAttendanceState extends State<TAttendance> {
//   final TAttendanceController controller = Get.put(TAttendanceController());
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//   GlobalKey<RefreshIndicatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchSectionsInfo('SCH0000000001');
//   }
//
//   Future<void> _refreshData() async {
//      controller.fetchSectionsInfo('SCH0000000001');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance'),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_rounded),
//         ),
//       ),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: _refreshData,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(), // Ensure scrolling is enabled
//
//           child: Padding(
//             padding: const EdgeInsets.all(SchoolSizes.lg),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     SchoolHelperFunctions.navigateToScreen(
//                         context, const SearchAttendance());
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(SchoolSizes.md),
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                       color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//                       border: Border.all(
//                           width: 0.5, color: SchoolDynamicColors.borderColor),
//                       borderRadius:
//                       BorderRadius.circular(SchoolSizes.cardRadiusSm),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(SchoolSizes.sm),
//                           decoration: BoxDecoration(
//                             color: SchoolDynamicColors.primaryTintColor,
//                             border: Border.all(
//                                 width: 0.5, color: SchoolDynamicColors.borderColor),
//                             borderRadius:
//                             BorderRadius.circular(SchoolSizes.cardRadiusSm),
//                           ),
//                           child:  Icon(
//                             Icons.search_rounded,
//                             color: SchoolDynamicColors.primaryColor,
//                             size: 36,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: SchoolSizes.md,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Search Attendance",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge
//                                     ?.copyWith(
//                                     color: SchoolDynamicColors.headlineTextColor),
//                               ),
//                               Text(
//                                   "Search Homeworks according to the class and date",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                   style:
//                                   Theme.of(context).textTheme.labelSmall)
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           width: SchoolSizes.md,
//                         ),
//                          Icon(
//                           Icons.arrow_forward_ios,
//                           color: SchoolDynamicColors.primaryColor,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: SchoolSizes.lg,
//                 ),
//                 Obx(
//                       () => controller.isLoadingAttendance.value
//                       ? _buildShimmerSectionList()
//                       : ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.sectionsData.length,
//                     itemBuilder: (context, index) {
//                       final section =
//                       controller.sectionsData[index];
//                       final sectionId = section.sectionId;
//                       final className = section.className;
//                       final sec = section.sectionName;
//                       final isSubmitted =
//                           section.isClassAttendanceSubmitted;
//                       final totalPresentStudents =
//                           section.totalPresentStudents;
//                       final totalAbsentStudents =
//                           section.totalAbsentStudents;
//                       final teacherName = section.teacherName;
//
//                       final isDifferentClass = index == 0 ||
//                           section.className !=
//                               controller.sectionsData[index - 1]
//                                   .className;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (isDifferentClass)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0),
//                               child: Text(
//                                 'Class - $className',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                     color: SchoolDynamicColors.subtitleTextColor
//                                 ),
//                               ),
//                             ),
//                           ClassAttendance(
//                             sectionId,
//                             className,
//                             sec,
//                             isSubmitted,
//                             totalPresentStudents,
//                             totalAbsentStudents,
//                             teacherName,
//                           ),
//                           const SizedBox(
//                             height: SchoolSizes.lg,
//                           )
//                         ],
//                       );
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ClassAttendance extends StatelessWidget {
//   final String sectionId;
//   final String className;
//   final String sec;
//   final bool isSubmitted;
//   final int totalPresentStudents;
//   final int totalAbsentStudents;
//   final String teacherName;
//
//   ClassAttendance(
//     this.sectionId,
//     this.className,
//     this.sec,
//     this.isSubmitted,
//     this.totalPresentStudents,
//     this.totalAbsentStudents,
//     this.teacherName,
//   );
//
//   final TAttendanceController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           vertical: SchoolSizes.sm, horizontal: SchoolSizes.sm),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//         border: Border.all(width: 0.5, color: SchoolDynamicColors.borderColor),
//         borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusSm),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: SchoolDynamicColors.backgroundColorTintLightGrey,
//               //border: Border.all(width: 0.5, color: SchoolColors.borderColor),
//               borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusXs),
//             ),
//             child: Center(
//               child: Text(
//                 sec,
//                 style: Theme.of(Get.context!)
//                     .textTheme
//                     .headlineMedium
//                     ?.copyWith(color: SchoolDynamicColors.primaryTextColor),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: SchoolSizes.md,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$className - $sec',
//                   style: Theme.of(Get.context!)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(color: SchoolDynamicColors.headlineTextColor),
//                 ),
//                 isSubmitted
//                     ? Text(
//                         'By - $teacherName',
//                         style: Theme.of(Get.context!)
//                             .textTheme
//                             .labelMedium
//                             ?.copyWith(color: SchoolDynamicColors.subtitleTextColor),
//                       )
//                     : const SizedBox(
//                         height: SchoolSizes.xs,
//                       ),
//                 const SizedBox(
//                   height: SchoolSizes.xs,
//                 ),
//                 isSubmitted
//                     ? Row(
//                         children: [
//                           ColorChips(
//                             text: 'Present $totalPresentStudents',
//                             color: SchoolDynamicColors.activeGreen,
//                             textSize: 10,
//                             padding: 6,
//                           ),
//                           SizedBox(
//                             width: SchoolSizes.md,
//                           ),
//                           ColorChips(
//                             text: 'Absent $totalAbsentStudents',
//                             color: SchoolDynamicColors.activeOrange,
//                             textSize: 10,
//                             padding: 6,
//                           )
//                         ],
//                       )
//                     : ColorChips(
//                         text: 'Not Submitted',
//                         color: SchoolDynamicColors.activeRed,
//                         textSize: 10,
//                         padding: 6,
//                       )
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () => controller.onSubmitPressed(sectionId, sec, className),
//             child: Container(
//               alignment: Alignment.center,
//               constraints: const BoxConstraints(minWidth: 110),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: SchoolSizes.sm),
//               decoration: BoxDecoration(
//                 color: isSubmitted
//                     ? SchoolDynamicColors.activeOrange
//                     : SchoolDynamicColors.activeGreen,
//                 borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusXs),
//               ),
//               child: Text(
//                 isSubmitted ? 'Change' : 'Submit',
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget _buildShimmerSectionList() {
//   return SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     child: Shimmer.fromColors(
//       baseColor: SchoolDynamicColors.backgroundColorGreyLightGrey!,
//       highlightColor: SchoolDynamicColors.backgroundColorWhiteDarkGrey!,
//       child: Column(
//         children: List.generate(
//           4, // Number of shimmering items
//           (index) {
//             return Column(
//               children: [
//                 Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: double.infinity,
//                       height: 50,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8.0), // Adjust the height as needed
//               ],
//             );
//           },
//         ),
//       ),
//     ),
//   );
// }
