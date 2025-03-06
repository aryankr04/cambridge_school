// import 'package:cambridge_school/app/modules/attendance/attendence/screens/my_attendance.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// import '../../../../core/utils/constants/colors.dart';
// import '../../../../core/utils/constants/dynamic_colors.dart';
// import '../../../../core/utils/constants/sizes.dart';
// import '../../manage_school/screens/create_school_step_5.dart';
//
// class StudentAttendance0 {
//   final String date;
//   final String status; // Changed from bool? to String?
//
//   StudentAttendance0({required this.date, required this.status});
// }
//
// class AttendanceController extends GetxController {
//   // Reactive Variables
//   RxBool isLoadingAttendance = true.obs;
//
//   RxInt presentCountThisMonth = 0.obs;
//   RxInt absentCountThisMonth = 0.obs;
//   RxInt holidayCountThisMonth = 0.obs;
//   RxInt totalDaysThisMonth = 0.obs;
//   RxInt totalWorkingDaysThisMonth = 0.obs;
//
//   RxBool isPresentSelected = true.obs;
//   RxBool isAbsentSelected = false.obs;
//   RxBool isHolidaySelected = false.obs;
//
//   // Static Variables
//   final String studentId = 'S1565';
//   final String schoolId = 'SCH0000000001';
//   final String classId = 'CLA0000000001';
//
//   // Dependencies
//   final MyClassRepository schoolClassRepository = MyClassRepository();
//
//   // Data Structures
//
//   RxList<StudentAttendance0> studentAttendanceList = <StudentAttendance0>[].obs;
//   Map<String, Map<String, int>> monthlyAttendance = {};
//   Map<String, double> studentAttendancePercentages = {};
//   Map<String, int> studentRanks = {};
//   Set<String> holidayDates = {};
//   RxString currentMonth =
//       DateFormat('yyyy-MM').format(DateTime.now()).toString().obs;
//
//   // Local Counters
//   int totalPresentYear = 0;
//   int totalAbsentYear = 0;
//   int totalHolidayYear = 0;
//   int totalWorkingDaysYear = 0;
//
//   List<Map<String, dynamic>> rankingList = [];
//   double classAverageAttendancePercentage = 0;
//   double studentAverageAttendancePercentage = 0;
//   double performanceDifference = 0;
//   List<Holiday> holidays = [];
//
//   // Fetch Attendance Data
//   Future<void> fetchStudentAttendance(String classId, String studentId) async {
//     try {
//       final schoolClass = await schoolClassRepository.getMyClass(classId);
//       if (schoolClass == null) {
//         studentAttendanceList.clear();
//         return;
//       }
//       holidays = schoolClass.holidays;
//       _populateHolidayDates(schoolClass.holidays);
//       _processAttendanceData(schoolClass, studentId);
//       calculateMonthlyAttendance(studentAttendanceList);
//       _calculateAttendancePercentages(schoolClass);
//       _rankStudents();
//       generateStudentRankingList(schoolClass);
//       calculateClassAverage(studentAttendancePercentages);
//       calculatePerformanceDifference();
//
//       _countAttendanceStatuses();
//     } catch (e) {
//       studentAttendanceList.clear();
//     }
//   }
//
//   // Populate the list of holidays from the school data
//   void _populateHolidayDates(List<Holiday> holidays) {
//     holidayDates.clear();
//     for (var holiday in holidays) {
//       DateTime startDate = DateTime.parse(holiday.startDate);
//       DateTime endDate = DateTime.parse(holiday.endDate);
//
//       for (var date = startDate;
//           !date.isAfter(endDate);
//           date = date.add(const Duration(days: 1))) {
//         holidayDates.add(DateFormat('yyyy-MM-dd').format(date));
//       }
//     }
//   }
//
//   // Process attendance data for the student, adding holidays and attendance records
//   void _processAttendanceData(MyClass schoolClass, String studentId) {
//     totalPresentYear = 0;
//     totalAbsentYear = 0;
//     totalHolidayYear = 0;
//     totalWorkingDaysYear = 0;
//     studentAttendanceList.clear();
//
//     // Add all holidays from holidayDates to studentAttendanceList with status 'Holiday'
//     for (var holiday in holidayDates) {
//       studentAttendanceList
//           .add(StudentAttendance0(date: holiday, status: 'Holiday'));
//       totalHolidayYear++;
//     }
//
//     // Process attendance data for the rest of the dates
//     for (var entry in schoolClass.attendanceByDate.entries) {
//       DateTime date = entry.value.date;
//       String formattedDate = DateFormat('yyyy-MM-dd').format(date);
//
//       // Skip dates already added as holidays
//       if (holidayDates.contains(formattedDate)) continue;
//
//       String status = (entry.value.attendanceRecords[studentId] ?? false)
//           ? 'Present'
//           : 'Absent';
//
//       if (status == 'Present') totalPresentYear++;
//       if (status == 'Absent') totalAbsentYear++;
//
//       studentAttendanceList
//           .add(StudentAttendance0(date: formattedDate, status: status));
//       totalWorkingDaysYear++; // Increment total attendance days
//     }
//   }
//
//   // Calculate monthly attendance summary (present, absent, holiday)
//   void calculateMonthlyAttendance(List<StudentAttendance0> attendanceList) {
//     monthlyAttendance.clear(); // Clear previous data
//
//     for (var attendance in attendanceList) {
//       // Get the month from the attendance date
//       String attendanceMonth =
//           DateFormat('yyyy-MM').format(DateTime.parse(attendance.date));
//
//       // Initialize the map entry for the month if not already present
//       if (!monthlyAttendance.containsKey(attendanceMonth)) {
//         monthlyAttendance[attendanceMonth] = {
//           'Present': 0,
//           'Absent': 0,
//           'Holiday': 0
//         };
//       }
//
//       // Safely increment the status count for the month
//       var monthData = monthlyAttendance[attendanceMonth];
//       if (monthData != null) {
//         switch (attendance.status) {
//           case 'Present':
//             monthData['Present'] = (monthData['Present'] ?? 0) + 1;
//             break;
//           case 'Absent':
//             monthData['Absent'] = (monthData['Absent'] ?? 0) + 1;
//             break;
//           case 'Holiday':
//             monthData['Holiday'] = (monthData['Holiday'] ?? 0) + 1;
//             break;
//         }
//       }
//     }
//   }
//
//   // Calculate attendance percentages for each student
//   void _calculateAttendancePercentages(MyClass schoolClass) {
//     studentAttendancePercentages.clear();
//     for (var student in schoolClass.students) {
//       int presentCount = 0;
//       int totalDays = 0;
//
//       for (var entry in schoolClass.attendanceByDate.entries) {
//         if (entry.value.attendanceRecords.containsKey(student.id)) {
//           totalDays++;
//           if (entry.value.attendanceRecords[student.id] ?? false)
//             presentCount++;
//         }
//       }
//
//       if (totalDays > 0) {
//         studentAttendancePercentages[student.id] =
//             (presentCount / totalDays) * 100;
//       }
//     }
//   }
//
//   // Rank students based on their attendance percentage
//   void _rankStudents() {
//     var sortedStudents = studentAttendancePercentages.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
//
//     studentRanks.clear();
//     int rank = 1;
//     double? previousPercentage;
//
//     for (var i = 0; i < sortedStudents.length; i++) {
//       var student = sortedStudents[i];
//
//       if (previousPercentage == null || student.value != previousPercentage) {
//         rank = studentRanks.isEmpty ? 1 : studentRanks.values.last + 1;
//       }
//
//       studentRanks[student.key] = rank;
//       previousPercentage = student.value;
//     }
//   }
//
//   // Generate the list of student rankings
//   void generateStudentRankingList(MyClass schoolClass) {
//     rankingList.clear();
//     for (var student in schoolClass.students) {
//       int rank = studentRanks[student.id] ?? -1;
//       double percentage = studentAttendancePercentages[student.id] ?? 0.0;
//
//       rankingList.add({
//         'name': student.name,
//         'id': student.id,
//         'rank': rank,
//         'percentage': percentage.toStringAsFixed(2),
//       });
//     }
//
//     rankingList.sort((a, b) => a['rank'].compareTo(b['rank']));
//   }
//
//   // Count attendance statuses for the current month
//   void _countAttendanceStatuses() {
//     presentCountThisMonth.value = 0;
//     absentCountThisMonth.value = 0;
//     holidayCountThisMonth.value = 0;
//
//     for (var attendance in studentAttendanceList) {
//       if (attendance.date.startsWith(currentMonth.value)) {
//         switch (attendance.status) {
//           case 'Present':
//             presentCountThisMonth.value++;
//             break;
//           case 'Absent':
//             absentCountThisMonth.value++;
//             break;
//           case 'Holiday':
//             holidayCountThisMonth.value++;
//             break;
//         }
//       }
//     }
//
//     totalWorkingDaysThisMonth.value =
//         presentCountThisMonth.value + absentCountThisMonth.value;
//     _calculateTotalDays();
//   }
//
//   // Calculate total days in the current month
//   void _calculateTotalDays() {
//     DateTime firstDayOfMonth = DateTime.parse('${currentMonth.value}-01');
//     totalDaysThisMonth.value =
//         DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0).day;
//   }
//
//   int getTotalDaysInCurrentYear() {
//     int year = DateTime.now().year;
//
//     // Check if the current year is a leap year
//     bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
//
//     return isLeapYear ? 366 : 365;
//   }
//
//   // Calculate class average attendance percentage
//   void calculateClassAverage(Map<String, double> attendancePercentages) {
//     if (studentAttendancePercentages.isEmpty) {
//       classAverageAttendancePercentage = 0;
//     }
//
//     double totalPercentage = attendancePercentages.values
//         .fold(0.0, (sum, percentage) => sum + percentage);
//     classAverageAttendancePercentage =
//         totalPercentage / attendancePercentages.length;
//   }
//
//   // Calculate performance difference for the student
//   void calculatePerformanceDifference() {
//     double studentPercentage = studentAttendancePercentages[studentId] ?? 0.0;
//     performanceDifference =
//         studentPercentage - classAverageAttendancePercentage;
//   }
// }
//
// class Attendance extends StatefulWidget {
//   const Attendance({super.key});
//
//   @override
//   State<Attendance> createState() => _AttendanceState();
// }
//
// class _AttendanceState extends State<Attendance>
//     with SingleTickerProviderStateMixin {
//   final AttendanceController controller = Get.put(AttendanceController());
//
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the AnimationController with a duration.
//     controller.fetchStudentAttendance('CLA0000000001', 'S1565');
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     // Create an animation with a linear tween.
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//
//     // Start the animation.
//     _controller.forward();
//     ever(controller.currentMonth, (_) {
//       controller._countAttendanceStatuses();
//     });
//   }
//
//   RxString selectedMonthlyReportOption = 'Present'.obs;
//   RxList<String> monthlyReportOptions = <String>[].obs;
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
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(MySizes.lg),
//           child: Obx(() => Column(
//                 children: [
//                   MyAttendanceCalendar(
//                     studentAttendanceList: controller.studentAttendanceList,
//                     onMonthChanged: (currentMonth) {
//                       controller.currentMonth.value =
//                           DateFormat('yyyy-MM').format(currentMonth).toString();
//                     },
//                   ),
//                   const SizedBox(
//                     height: MySizes.spaceBtwSections,
//                   ),
//                   buildCurrentMonthReport(),
//                   const SizedBox(
//                     height: MySizes.spaceBtwSections,
//                   ),
//                   buildMonthlyReport(),
//                   const SizedBox(
//                     height: MySizes.spaceBtwSections,
//                   ),
//                   buildYearlyReport(),
//                   const SizedBox(
//                     height: MySizes.spaceBtwSections,
//                   ),
//                   buildYourAverageVsClassAverage(context),
//                   const SizedBox(
//                     height: MySizes.spaceBtwSections,
//                   ),
//                   buildRankOverview()
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
//
//   Container buildCurrentMonthReport() {
//     return Container(
//       padding: const EdgeInsets.all(MySizes.md),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         border: Border.all(width: .5, color: MyDynamicColors.borderColor),
//       ),
//       child: Column(
//         children: [
//           Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '${DateFormat('MMMM').format(DateFormat('yyyy-MM').parse(controller.currentMonth.value))} Attendance',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: MyColors.headlineTextColor,
//                 ),
//               )),
//           const SizedBox(height: MySizes.md),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               attendanceCardWithIndicator(
//                   name: 'Present',
//                   value: controller.presentCountThisMonth.value,
//                   total: controller.totalWorkingDaysThisMonth.value,
//                   color: MyDynamicColors.activeGreen),
//               attendanceCardWithIndicator(
//                   name: 'Absent',
//                   value: controller.absentCountThisMonth.value,
//                   total: controller.totalWorkingDaysThisMonth.value,
//                   color: MyDynamicColors.activeRed),
//               attendanceCardWithIndicator(
//                   name: 'Holidays',
//                   value: controller.holidayCountThisMonth.value,
//                   total: controller.totalDaysThisMonth.value,
//                   color: MyDynamicColors.activeOrange),
//             ],
//           ),
//           SizedBox(
//             height: MySizes.lg,
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: const Text(
//               "Holidays",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ...getCurrentMonthHolidays(controller.holidays, controller.currentMonth.value)
//         ],
//       ),
//     );
//   }
//   List<HolidayCard> getCurrentMonthHolidays(List<Holiday> holidays, String currentMonth) {
//     // Get the year and month from the currentMonth string (e.g., "2024-11")
//     int currentYear = int.parse(currentMonth.split('-')[0]); // Extract the year
//     int currentMonthNum = int.parse(currentMonth.split('-')[1]); // Extract the month number
//
//     // Filter holidays to only include those in the current month
//     return holidays
//         .where((holiday) {
//       DateTime startDate = DateTime.parse(holiday.startDate); // Convert String to DateTime
//       return startDate.month == currentMonthNum && startDate.year == currentYear;
//     })
//         .map((holiday) {
//       DateTime startDate = DateTime.parse(holiday.startDate);
//       DateTime endDate = DateTime.parse(holiday.endDate);
//
//       return HolidayCard(
//         name: holiday.reason,
//         startDate: startDate,
//         endDate: endDate,
//       );
//     }).toList();
//   }
//
//   Container buildMonthlyReport() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: MySizes.md),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         border: Border.all(width: .5, color: MyDynamicColors.borderColor),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Row(
//                   children: [
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Monthly Report',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: MyColors.headlineTextColor,
//                           ),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: MySizes.sm,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment
//                       .spaceBetween, // Aligns items to the start (left) of the row
//                   crossAxisAlignment: CrossAxisAlignment
//                       .center, // Aligns items vertically in the center
//                   children: [
//                     {
//                       'label': 'Present',
//                       'selected': controller.isPresentSelected,
//                     },
//                     {
//                       'label': 'Absent',
//                       'selected': controller.isAbsentSelected,
//                     },
//                     {
//                       'label': 'Holiday',
//                       'selected': controller.isHolidaySelected,
//                     },
//                   ].map((option) {
//                     RxBool isSelected = option['selected'] as RxBool;
//                     String label = option['label'] as String;
//
//                     return Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           // Toggle the selection state
//                           isSelected.value = !isSelected.value;
//                         },
//                         child: Obx(
//                           () => Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: MySizes.sm),
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: MySizes.sm,
//                               horizontal: MySizes.sm + 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isSelected.value
//                                   ? MyDynamicColors.activeBlue
//                                       .withOpacity(0.1) // Highlight selected
//                                   : MyDynamicColors
//                                       .backgroundColorGreyLightGrey,
//                               borderRadius:
//                                   BorderRadius.circular(MySizes.lg),
//                               border: Border.all(
//                                 color: isSelected.value
//                                     ? MyDynamicColors.primaryColor
//                                     : Colors.transparent,
//                                 width: isSelected.value ? 0.75 : 0,
//                               ),
//                             ),
//                             child: Text(
//                               label,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: isSelected.value
//                                     ? MyColors.activeBlue
//                                     : MyDynamicColors.subtitleTextColor,
//                                 fontWeight: isSelected.value
//                                     ? FontWeight.w500
//                                     : FontWeight.w400,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: MySizes.lg + 8,
//           ),
//           Container(
//             height: Get.width * 0.5,
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 // Extract month names (e.g., "Jan" from "Jan 2024")
//                 List<String> months =
//                     controller.monthlyAttendance.keys.map((monthKey) {
//                   return monthKey.split(' ')[0]; // Get month name (e.g., "Jan")
//                 }).toList();
//
//                 List<String> monthNames =
//                     controller.monthlyAttendance.keys.map((monthKey) {
//                   DateTime monthDate = DateTime.parse(
//                       '$monthKey-01'); // Parse the month (adding day '01' to make it valid)
//                   return DateFormat('MMM')
//                       .format(monthDate); // Format it to "Nov", "Dec"
//                 }).toList();
//                 // Generate bar data based on `monthlyAttendance`
//                 List<BarChartGroupData> barGroups = List.generate(
//                   months.length,
//                   (index) {
//                     String monthKey =
//                         controller.monthlyAttendance.keys.toList()[index];
//                     Map<String, int> attendanceData =
//                         controller.monthlyAttendance[monthKey]!;
//
//                     double presentValue =
//                         attendanceData['Present']?.toDouble() ?? 0;
//                     double absentValue =
//                         attendanceData['Absent']?.toDouble() ?? 0;
//                     double holidayValue =
//                         attendanceData['Holiday']?.toDouble() ?? 0;
//
//                     List<BarChartRodData> barRods = [];
// // Calculate width based on selected flags
//                     double rodWidth = (controller.isPresentSelected.value &&
//                             controller.isAbsentSelected.value &&
//                             controller.isHolidaySelected.value)
//                         ? 4
//                         : 8;
//                     // Conditionally add bar rods based on the booleans
//                     if (controller.isPresentSelected.value) {
//                       barRods.add(
//                         BarChartRodData(
//                           toY: presentValue * _animation.value,
//                           width: rodWidth,
//                           borderRadius: BorderRadius.circular(24),
//                           color: MyColors.activeGreen,
//                         ),
//                       );
//                     }
//
//                     if (controller.isAbsentSelected.value) {
//                       barRods.add(
//                         BarChartRodData(
//                           toY: absentValue * _animation.value,
//                           width: rodWidth,
//                           borderRadius: BorderRadius.circular(24),
//                           color: MyColors.activeRed,
//                         ),
//                       );
//                     }
//
//                     if (controller.isHolidaySelected.value) {
//                       barRods.add(
//                         BarChartRodData(
//                           toY: holidayValue * _animation.value,
//                           width: rodWidth,
//                           borderRadius: BorderRadius.circular(24),
//                           color: MyColors.activeOrange,
//                         ),
//                       );
//                     }
//
//                     return BarChartGroupData(
//                       x: index,
//                       barsSpace: 4,
//                       showingTooltipIndicators:
//                           List.generate(barRods.length, (i) => i),
//                       barRods: barRods,
//                     );
//                   },
//                 );
//
//                 return BarChart(
//                   BarChartData(
//                     maxY: 31, // Maximum Y value (31 days in a month)
//                     barGroups: barGroups,
//                     titlesData: FlTitlesData(
//                       leftTitles: const AxisTitles(
//                         sideTitles:
//                             SideTitles(showTitles: false), // Hide left titles
//                       ),
//                       rightTitles: const AxisTitles(
//                         sideTitles:
//                             SideTitles(showTitles: false), // Hide right titles
//                       ),
//                       topTitles: const AxisTitles(
//                         sideTitles:
//                             SideTitles(showTitles: false), // Hide top titles
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true, // Show bottom titles
//                           getTitlesWidget: (value, _) {
//                             if (value < 0 || value >= months.length) {
//                               return const SizedBox();
//                             }
//                             return Text(
//                               monthNames[value.toInt()],
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: MyColors.captionTextColor,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     gridData: const FlGridData(show: false), // No gridlines
//                     borderData: FlBorderData(show: false), // No border
//                     barTouchData: BarTouchData(
//                       enabled: false,
//                       touchTooltipData: BarTouchTooltipData(
//                         tooltipPadding: const EdgeInsets.all(0),
//                         getTooltipColor: (BarChartGroupData group) {
//                           return Colors.transparent; // Transparent background
//                         },
//                         tooltipMargin: 0,
//                         getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                           return BarTooltipItem(
//                             '${rod.toY.toInt()}', // Display bar value
//                             const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 10,
//                             ),
//                           );
//                         },
//                       ),
//                       handleBuiltInTouches: true,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Container buildYearlyReport() {
//     return Container(
//       padding: const EdgeInsets.all(MySizes.md),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         border: Border.all(width: .5, color: MyDynamicColors.borderColor),
//       ),
//       child: Column(
//         children: [
//           const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Yearly Report',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: MyColors.headlineTextColor,
//                 ),
//               )),
//           const SizedBox(
//             height: MySizes.md,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               attendanceCardWithIndicator(
//                   name: 'Present',
//                   value: controller.totalPresentYear,
//                   total: controller.totalWorkingDaysYear,
//                   color: MyDynamicColors.activeGreen),
//               attendanceCardWithIndicator(
//                   name: 'Absent',
//                   value: controller.totalAbsentYear,
//                   total: controller.totalWorkingDaysYear,
//                   color: MyDynamicColors.activeRed),
//               attendanceCardWithIndicator(
//                   name: 'Holidays',
//                   value: controller.totalHolidayYear,
//                   total: controller.getTotalDaysInCurrentYear(),
//                   color: MyDynamicColors.activeOrange),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container buildYourAverageVsClassAverage(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(MySizes.md),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         border: Border.all(width: .5, color: MyDynamicColors.borderColor),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Section 1: Average vs Class Average
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Your Average vs Class Average",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: MyColors.headlineTextColor,
//               ),
//             ),
//           ),
//           const SizedBox(height: MySizes.md),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildAverageBox(
//                   "Your Average",
//                   controller
//                       .studentAttendancePercentages[controller.studentId]!,
//                   Colors.green),
//               Container(
//                 margin: const EdgeInsets.only(bottom: MySizes.md),
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0 + 4),
//                 child: CircleAvatar(
//                     backgroundColor: MyColors.activeRed.withOpacity(0.1),
//                     child: Text(
//                       'VS',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontSize: 16,
//                           color: Colors.red,
//                           fontWeight: FontWeight.w600),
//                     )),
//               ),
//               // const SizedBox(
//               //   width: MySizes.md,
//               // ),
//               _buildAverageBox("Class Average",
//                   controller.classAverageAttendancePercentage, Colors.blue),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           Row(
//             children: [
//               Icon(
//                 controller.performanceDifference >= 0
//                     ? Icons.trending_up
//                     : Icons.trending_down,
//                 color: controller.performanceDifference >= 0
//                     ? Colors.green
//                     : Colors.red, // Green for positive, Red for negative
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 "Difference: ${controller.performanceDifference >= 0 ? '+${controller.performanceDifference}%' : '${controller.performanceDifference}%'} vs Class",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: controller.performanceDifference >= 0
//                       ? Colors.green
//                       : Colors.red, // Color matching the icon
//                   fontStyle: FontStyle.italic, // Added italics for emphasis
//                 ),
//               ),
//             ],
//           ),
//
//           // Progress Bar (if needed for visualization)
//         ],
//       ),
//     );
//   }
//
//   Container buildRankOverview() {
//     return Container(
//       padding: const EdgeInsets.all(MySizes.md),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//         color: MyDynamicColors.backgroundColorWhiteDarkGrey,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         border: Border.all(width: 0.5, color: MyDynamicColors.borderColor),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Section 2: Rank Header
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Rank Overview",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: MyColors.headlineTextColor,
//               ),
//             ),
//           ),
//           const SizedBox(height: MySizes.md),
//
//           // Row for student and top ranks with icons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildRankBox(
//                   "Your Rank",
//                   controller.studentRanks[controller.studentId]!,
//                   controller
//                       .studentAttendancePercentages[controller.studentId]!,
//                   Colors.orangeAccent),
//               _buildRankBox("Top Rank", 1, 75, Colors.blueAccent),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Rank Breakdown with progress bars
//           const Text(
//             "Rank Breakdown",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 10),
//           ...buildRankDistributionRows(controller.rankingList),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRankBox(String label, int rank, double percentage, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: MySizes.sm + 4, vertical: 12),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//
//       ),
//       child: Row(
//         children: [
//           // Rank Icon
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 500),
//             child: Icon(
//               rank == 1
//                   ? Icons.emoji_events
//                   : rank == 2
//                       ? Icons.emoji_events_outlined
//                       : Icons.star_border,
//               key: ValueKey<int>(rank),
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: MySizes.sm),
//
//           // Rank and Percentage Information
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "$label: $rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : rank == 3 ? 'rd' : 'th'}",
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     "${percentage.toStringAsFixed(1)}%",
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   RxBool isExpanded = false.obs;
//
//   Color _getRankColor(String rank) {
//     int rankInt = int.tryParse(rank) ?? 0;
//     if (rankInt == 1) {
//       return Colors.green; // Top rank
//     } else if (rankInt == 2) {
//       return Colors.blue; // Second rank
//     } else {
//       return Colors.red; // Lower ranks
//     }
//   }
//
//   // Function to build rank distribution rows
//   List<Widget> buildRankDistributionRows(
//       List<Map<String, dynamic>> rankingList) {
//     List<Widget> rankDistributionRows = [];
//
//     // Filter out students with rank 1 or 2 initially
//     List<Map<String, dynamic>> topRanks = rankingList.where((student) {
//       int rank = int.tryParse(student['rank'].toString()) ?? 0;
//       return rank <= 1; // Only include students with rank 1 or 2
//     }).toList();
//
//     // Limit based on 'isExpanded' (show top 2 or all students with rank 2 or higher)
//     int limit = isExpanded.value ? rankingList.length : topRanks.length;
//
//     for (var i = 0; i < limit; i++) {
//       var student = rankingList[i];
//       String name = student['name'];
//       String id = student['id'];
//       String rank = student['rank'].toString();
//       String percentage = student['percentage'];
//
//       // Set color based on rank
//       Color color = _getRankColor(rank);
//
//       // Add the row widget to the list
//       rankDistributionRows.add(
//         _buildRankDistributionRow(name, id, rank, percentage, color),
//       );
//     }
//
//     // Add the "See All" button if there are more than 2 items
//     if (rankingList.length > topRanks.length) {
//       rankDistributionRows.add(
//         Align(
//             alignment: Alignment.centerRight,
//             child: Obx(() => TextButton(
//                   onPressed: () {
//                     isExpanded.value =
//                         !isExpanded.value; // Toggle the expanded state
//                   },
//                   child: Text(isExpanded.value ? 'See Less' : 'See All'),
//                 ))),
//       );
//     }
//
//     return rankDistributionRows;
//   }
//
//   Widget _buildRankDistributionRow(
//     String name,
//     String id,
//     String rank,
//     String percentage,
//     Color color,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//         color: controller.studentId == id
//             ? color.withOpacity(0.1)
//             : Colors.transparent,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             // Profile Icon with Circle and Background Color
//             Container(
//                 padding: const EdgeInsets.all(8 + 4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: color.withOpacity(0.2), // Light background for icon
//                 ),
//                 child: Text(
//                   rank == '1'
//                       ? "1st"
//                       : rank == '2'
//                           ? "2nd"
//                           : rank == '3'
//                               ? "3rd"
//                               : rank, // Handle other ranks
//                   style: Theme.of(context)
//                       .textTheme
//                       .labelLarge
//                       ?.copyWith(color: color),
//                 )),
//             const SizedBox(
//                 width:
//                     12), // Increased width for better spacing between the icon and text
//
//             // Text Column with name and ID
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     controller.studentId == id ? 'You' : name,
//                     style: const TextStyle(
//                       fontSize:
//                           14, // Increased font size for better readability
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   // SizedBox(height: 4), // Spacing between name and ID
//                   Text(
//                     id,
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                 ],
//               ),
//             ),
//
//             // Progress Percentage Display (assuming static 78.3% for now)
//             const SizedBox(width: 12),
//             Text(
//               '${percentage}%',
//               style: const TextStyle(
//                 fontSize: 14, // Font size for percentage
//                 fontWeight: FontWeight.w600,
//                 color: MyColors
//                     .headlineTextColor, // Use the passed color for the percentage text
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper function to build average boxes
//   Widget _buildAverageBox(String label, double value, Color color) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color, width: 1),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                       fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "$value%",
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//               height: MySizes.md -
//                   4), // Add space between the text container and progress bar
//           LinearProgressIndicator(
//             value: value / 100, // Use the parameter value
//             minHeight: MySizes.sm - 2,
//             backgroundColor: color.withOpacity(0.1),
//             valueColor: AlwaysStoppedAnimation<Color>(
//                 color), // Use the same color for the progress bar
//             borderRadius:
//                 const BorderRadius.all(Radius.circular(MySizes.md)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget attendanceCardWithIndicator({
//   required String name,
//   required int value,
//   required int total,
//   required Color color,
// }) {
//   double percentage = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;
//
//   return Container(
//     padding: const EdgeInsets.symmetric(
//         vertical: MySizes.sm + 2, horizontal: MySizes.md - 2),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
//     ),
//     child: Column(
//       children: [
//         CircularPercentIndicator(
//           radius: 36,
//           animateFromLastPercent: true,
//           progressColor: color,
//           backgroundColor: color.withOpacity(0.1),
//           animation: true,
//           animationDuration: 1000,
//           circularStrokeCap: CircularStrokeCap.round,
//           lineWidth: 6,
//           percent: percentage,
//           center: CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.white,
//             child: Text(
//               '${(percentage * 100).toStringAsFixed(1)}%',
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black),
//             ),
//           ),
//         ),
//         const SizedBox(height: MySizes.sm),
//         Text(
//           '$value/$total',
//           style: const TextStyle(
//               height: 1,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: MyColors.headlineTextColor),
//         ),
//         // SizedBox(height: MySizes.sm - 6),
//         Text(
//           name,
//           style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: MyColors.subtitleTextColor),
//         ),
//       ],
//     ),
//   );
// }
//
//
// class HolidayCard extends StatelessWidget {
//   final String name; // Holiday name
//   final DateTime startDate; // Start date of the holiday
//   final DateTime endDate; // End date of the holiday
//
//   const HolidayCard({
//     Key? key,
//     required this.name,
//     required this.startDate,
//     required this.endDate,
//   }) : super(key: key);
//
//   String _formatDate(DateTime date) {
//     return DateFormat('dd MMM yyyy').format(date);
//   }
//
//   IconData getHolidayIcon(String holidayName) {
//     final lowerCaseName = holidayName.toLowerCase();
//
//     if (lowerCaseName.contains('independence')) {
//       return Icons.flag;
//     } else if (lowerCaseName.contains('christmas')) {
//       return Icons.star;
//     } else if (lowerCaseName.contains('festival')) {
//       return Icons.emoji_people;
//     } else if (lowerCaseName.contains('new year')) {
//       return Icons.cake;
//     } else if (lowerCaseName.contains('holiday')) {
//       return Icons.beach_access;
//     } else if (lowerCaseName.contains('school')) {
//       return Icons.school;
//     } else if (lowerCaseName.contains('eid')) {
//       return Icons.mosque;
//     } else if (lowerCaseName.contains('diwali')) {
//       return Icons.lightbulb;
//     } else if (lowerCaseName.contains('birthday')) {
//       return Icons.cake;
//     } else if (lowerCaseName.contains('thanksgiving')) {
//       return Icons.dinner_dining;
//     } else if (lowerCaseName.contains('labor')) {
//       return Icons.construction;
//     } else {
//       return Icons.event; // Default icon if no match is found
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 0),
//       decoration: BoxDecoration(
//         // color: Colors.grey[100], // Example color, replace with your own
//         borderRadius: BorderRadius.circular(MySizes.cardRadiusXs), // Custom radius size
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Icon for the holiday
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(MySizes.cardRadiusXs), // Rounded corners
//               color: MyColors.activeOrange.withOpacity(0.1), // Custom color
//             ),
//             padding: const EdgeInsets.all(MySizes.sm),
//             child: Icon(
//               getHolidayIcon(name),
//               size: 24,
//               color: MyColors.activeOrange, // Custom color for icon
//             ),
//           ),
//           const SizedBox(width: 16.0), // Space between icon and text
//           // Holiday details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Holiday name
//                 Text(
//                   name,
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(fontWeight: FontWeight.w500,fontSize: 15,),
//                 ),
//                 // Holiday date range
//                 Text(
//                   'From: ${_formatDate(startDate)}',
//                   style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 10),
//                 ),
//                 Text(
//                   'To: ${_formatDate(endDate)}',
//                   style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 10),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
