// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../../utils/constants/dynamic_colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../utils/helpers/helper_functions.dart';
// import '../attendence.dart';
//
// class AttendanceCalendarController extends GetxController {
//   final AttendanceController controller = Get.put(AttendanceController());
//
//   var selectedDate = DateTime.now().obs;
//   var pageController = PageController(initialPage: 0);
//
//   RxInt absent = 0.obs;
//   RxInt present = 0.obs;
//   RxInt holidays = 0.obs;
//   RxInt working = 0.obs;
//   RxInt totalDays = 0.obs;
//
//   RxList<StudentAttendance0> monthlyAttendance = <StudentAttendance0>[].obs;
//
//   void onPageChanged(int index) async {
//     final newMonth = DateTime.now().subtract(Duration(days: 30 * index));
//     selectedDate.value = DateTime(newMonth.year, newMonth.month, 1);
//
//     // Fetch attendance for the new month
//     monthlyAttendance.value = await fetchStudentAttendanceForMonth(
//         'SEC0000000004', 'STU0000000001', newMonth.year, newMonth.month);
//     calculateAttendanceStats();
//     update();
//   }
//
//   void calculateAttendanceStats() {
//     absent.value = monthlyAttendance
//         .where((attendance) => attendance.status == 'Absent')
//         .length;
//     print(absent.value);
//     present.value = monthlyAttendance
//         .where((attendance) => attendance.status == 'Present')
//         .length;
//     holidays.value = monthlyAttendance
//         .where((attendance) => attendance.status == 'Holiday')
//         .length;
//     working.value = monthlyAttendance.length - holidays.value;
//     totalDays.value = monthlyAttendance.length;
//   }
//
//   Future<List<StudentAttendance0>> fetchStudentAttendanceForMonth(
//       String sectionId, String studentId, int year, int month) async {
//     try {
//       // Get the current date
//       final currentDate = DateTime.now();
//       final currentYear = currentDate.year;
//       final currentMonth = currentDate.month;
//       final currentDay = currentDate.day;
//
//       // Get the first and last dates of the month
//       DateTime firstDateOfMonth = DateTime(year, month, 1);
//       DateTime lastDateOfMonth = DateTime(year, month + 1, 0);
//
//       // Create a reference to the collection containing attendance data for the student
//       var attendanceCollectionReference = FirebaseFirestore.instance
//           .collection('attendance')
//           .doc(sectionId)
//           .collection('students')
//           .doc(studentId)
//           .collection('dates');
//
//       // Query for documents within the specified date range
//       var querySnapshot = await attendanceCollectionReference
//           .where(FieldPath.documentId,
//               isGreaterThanOrEqualTo:
//               SchoolHelperFunctions.getFormattedDate(firstDateOfMonth))
//           .where(FieldPath.documentId,
//               isLessThanOrEqualTo:
//               SchoolHelperFunctions.getFormattedDate(lastDateOfMonth))
//           .get();
//
//       // List to store the fetched attendance data
//       List<StudentAttendance0> monthlyAttendance = [];
//
//       // Iterate through all dates of the month
//       for (int i = 1; i <= lastDateOfMonth.day; i++) {
//         String formattedDate = SchoolHelperFunctions.formatDate(i, month, year);
//         print(formattedDate);
//
//         // Check if the date is after the current date in the current month
//         if (year == currentYear && month == currentMonth && i > currentDay) {
//           // Break the loop if the current date is reached
//           break;
//         }
//
//
//         // Check if data exists for this date
//         try {
//           var attendanceData = querySnapshot.docs.firstWhere(
//             (doc) => doc.id == formattedDate,
//           );
//
//           // If data exists, add it to the list
//           bool isPresent = attendanceData.data()['present'];
//           String status = isPresent ? 'Present' : 'Absent';
//             print('${formattedDate}: ${status}');
//
//           monthlyAttendance
//               .add(StudentAttendance0(date: formattedDate, status: status));
//         } catch (e) {
//           // If no data exists, mark it as holiday
//           monthlyAttendance
//               .add(StudentAttendance0(date: formattedDate, status: 'Holiday'));
//         }
//       }
//
//       monthlyAttendance.sort((a, b) => a.date.compareTo(b.date));
//       // for (var attendance in monthlyAttendance) {
//       //   print('${attendance.date}: ${attendance.status}');
//       // }
//
//       // Return the fetched attendance data
//       return monthlyAttendance;
//     } catch (e) {
//       print(
//           'Error fetching student attendance for $studentId for the month of $year-$month: $e');
//       // Handle the error as needed
//       return [];
//     }
//   }
//
//   Map<DateTime, String> fetchAttendanceData() {
//     final Map<DateTime, String> data = {};
//     final currentMonth = DateTime.now().month;
//     final currentYear = DateTime.now().year;
//     final random = Random();
//
//     // Define the percentage of days to be marked as holidays (e.g., 10%)
//     final holidayPercentage = 10; // Adjust as needed
//
//     for (int i = 1; i <= _daysInMonth(currentYear, currentMonth); i++) {
//       final date = DateTime(currentYear, currentMonth, i);
//       String status;
//
//       // Randomly assign status based on the percentage
//       final randomNumber = random.nextInt(100);
//       if (randomNumber < holidayPercentage) {
//         status = 'Holiday';
//       } else {
//         status = random.nextInt(2) == 0 ? 'Present' : 'Absent';
//       }
//
//       data[date] = status;
//     }
//
//     return data;
//   }
//
//   int _daysInMonth(int year, int month) {
//     return DateTime(year, month + 1, 0).day;
//   }
// }
//
// class AttendanceCalendar extends StatefulWidget {
//   final List<StudentAttendance0> monthlyAttendance;
//
//   AttendanceCalendar({Key? key, required this.monthlyAttendance})
//       : super(key: key);
//
//   @override
//   State<AttendanceCalendar> createState() => _AttendanceCalendarState();
// }
//
// class _AttendanceCalendarState extends State<AttendanceCalendar> {
//   final AttendanceCalendarController controller =
//       Get.put(AttendanceCalendarController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller.onPageChanged(0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AttendanceCalendarController>(
//       builder: (_) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 3,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//             borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusSm),
//             border: Border.all(width: .5, color: SchoolDynamicColors.borderColor),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Widget for displaying navigation buttons and current month/year.
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Button for navigating to the previous month.
//                     IconButton(
//                       icon: Icon(Icons.arrow_back_ios_rounded),
//                       onPressed: () {
//                         // Decreasing the page index to move to the previous month.
//                         controller.pageController.nextPage(
//                           duration: Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       },
//                     ),
//                     // Text displaying the current month and year.
//                     Obx(
//                       () => Text(
//                         DateFormat('MMMM yyyy')
//                             .format(controller.selectedDate.value),
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge
//                             ?.copyWith(fontSize: 18),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.arrow_forward_ios_rounded),
//                       onPressed: () {
//                         // Increasing the page index to move to the next month.
//                         controller.pageController.previousPage(
//                           duration: Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // SizedBox for adding space between header and calendar.
//               SizedBox(height: 8),
//               // Container for displaying the calendar using PageView.
//
//               Container(
//                 height: 330, // Calculate height based on rows
//                 child: PageView.builder(
//                   controller: controller.pageController,
//                   onPageChanged: controller.onPageChanged,
//                   itemCount: 12,
//                   reverse: true,
//                   itemBuilder: (context, index) {
//                     final month =
//                         DateTime.now().subtract(Duration(days: 30 * (index)));
//
//                     return _buildMonthCalendar(month.year, month.month);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   double calculateRows(int year, int month) {
//     final int daysInMonth = _daysInMonth(year, month);
//     final DateTime firstDayOfMonth = DateTime(year, month, 1);
//     final int offset = firstDayOfMonth.weekday;
//
//     // Calculate total slots (days + offset)
//     int totalSlots = daysInMonth + offset;
//
//     // Calculate number of rows needed (7 days in a week)
//     return (totalSlots / 7).ceil().toDouble(); // Round up to the next whole number and convert to double
//   }
//
//   Widget _buildMonthCalendar(int year, int month) {
//     final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     final List<Widget> dayWidgets = List.generate(
//       7,
//       (index) => Text(
//         days[index],
//         style: TextStyle(
//           color: SchoolDynamicColors.subtitleTextColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//
//     // Calculate the offset for the first day of the month
//     final firstDayOfMonth = DateTime(year, month, 1);
//     final int offset = firstDayOfMonth.weekday;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: dayWidgets,
//         ),
//         SizedBox(height: 16),
//         GridView.builder(
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             mainAxisSpacing: 20,
//             crossAxisSpacing: 20,
//           ),
//           itemCount: _daysInMonth(year, month) + offset,
//           itemBuilder: (context, index) {
//             if (index < offset) {
//               return Container(); // Placeholder for empty cells before the first day
//             }
//
//             final date = DateTime(year, month, index - offset + 1);
//             final attendance = controller.monthlyAttendance.firstWhereOrNull(
//               (attendance) =>
//                   attendance.date == DateFormat('dd-MM-yyyy').format(date),
//             );
//
//             String status = attendance?.status ?? '';
//
//             Color? color;
//             switch (status) {
//               case 'Present':
//                 color = Colors.green;
//                 break;
//               case 'Absent':
//                 color = Colors.red;
//                 break;
//               case 'Holiday':
//                 color = Colors.orange;
//                 break;
//               default:
//                 color = null;
//                 break;
//             }
//
//             return InkWell(
//               onTap: () {
//                 // Update the selected date when tapping on a day
//                 controller.selectedDate.value = date;
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   (index - offset + 1).toString(),
//                   style: TextStyle(
//                     color: status.isNotEmpty
//                         ? Colors.white
//                         : SchoolDynamicColors.subtitleTextColor,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   int _daysInMonth(int year, int month) {
//     return DateTime(year, month + 1, 0).day;
//   }
// }
