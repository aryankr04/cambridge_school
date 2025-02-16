// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:vibration/vibration.dart';
//
// import '../../../../../data/repositories/school_class_repository.dart';
// import '../../../../../utils/helpers/helper_functions.dart';
// import '../../../../manage_school/models/school_class.dart';
// import '../models/student_attendance.dart';
//
// class SubmitAttendanceController extends GetxController {
//   RxInt totalPresentStudents = 0.obs;
//   RxInt totalAbsentStudents = 0.obs;
//   RxInt totalStudents = 0.obs;
//
//   RxBool isPresentAll = false.obs;
//   final SchoolClassRepository schoolClassRepository = SchoolClassRepository();
//   SchoolClass? schoolClass;
//   RxList<StudentAttendance> studentAttendanceList = <StudentAttendance>[].obs;
//   RxBool isLoadingAttendance = false.obs;
//
//   // Add today's attendance based on studentAttendanceList
//   Future<void> addTodayAttendanceToClass(
//       SchoolClass schoolClass, RxList<StudentAttendance> studentAttendanceList,
//       String teacherId, String teacherName) async {
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     Map<String, bool> attendanceRecords = {
//       for (var studentAttendance in studentAttendanceList)
//         studentAttendance.studentId: studentAttendance.isPresent.value,
//     };
//
//     AttendanceByDate attendanceForToday = AttendanceByDate(
//       date: DateTime.now(),
//       teacherId: teacherId,
//       teacherName: teacherName,
//       attendanceRecords: attendanceRecords,
//     );
//
//     schoolClass.attendanceByDate[today] = attendanceForToday;
//
//     try {
//       await schoolClassRepository.updateSchoolClass(schoolClass);
//       print("Today's attendance added to Firestore.");
//
//       // Print today's attendance for debugging
//       var attendanceForTodayFromClass = schoolClass.attendanceByDate[today];
//       attendanceForTodayFromClass?.attendanceRecords.forEach((studentId, isPresent) {
//         print("Student ID: $studentId, Present: $isPresent");
//       });
//     } catch (e) {
//       print('Error adding attendance to Firestore: $e');
//     }
//   }
//
//   bool hasAttendanceForToday(SchoolClass schoolClass) {
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     return schoolClass.attendanceByDate.containsKey(today);
//   }
//
//   // Fetch the class and today's attendance if available
//   Future<void> fetchClass(String classId) async {
//     try {
//       schoolClass = await schoolClassRepository.getSchoolClass(classId);
//
//       if (schoolClass == null) {
//         print('Error: schoolClass is null');
//         return;
//       }
//       print('Error: not null');
//
//       studentAttendanceList.clear();
//       String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//       if (!schoolClass!.attendanceByDate.containsKey(today)) {
//         // Initialize all students as absent if no attendance exists
//         for (int index = 0; index < schoolClass!.students.length; index++) {
//           final student = schoolClass!.students[index];
//           studentAttendanceList.add(StudentAttendance(
//             studentId: student.id,
//             name: student.name,
//             roll: (index + 1).toString(),
//             initialIsPresent: false,
//           ));
//         }
//       } else {
//         // Copy existing attendance data for today
//         var attendanceForToday = schoolClass!.attendanceByDate[today];
//         if (attendanceForToday != null) {
//           for (int index = 0; index < schoolClass!.students.length; index++) {
//             final student = schoolClass!.students[index];
//             studentAttendanceList.add(StudentAttendance(
//               studentId: student.id,
//               name: student.name,
//               roll: (index + 1).toString(),
//               initialIsPresent: attendanceForToday.attendanceRecords[student.id] ?? false,
//             ));
//           }
//         }
//       }
//
//       countTotalStudents();
//       countPresentStudents();
//       countAbsentStudents();
//     } catch (e) {
//       print('Error fetching class: $e');
//     }
//   }
//
//   // Count the number of present students
//   void countPresentStudents() {
//     totalPresentStudents.value = studentAttendanceList.where((student) => student.isPresent.value).length;
//     update();
//   }
//
//   // Count the number of absent students
//   void countAbsentStudents() {
//     totalAbsentStudents.value = studentAttendanceList.where((student) => !student.isPresent.value).length;
//     update();
//   }
//
//   // Count the total number of students
//   void countTotalStudents() {
//     totalStudents.value = studentAttendanceList.length;
//     update();
//   }
//
//   // Check if all students are present
//   bool areAllStudentsPresent() {
//     return studentAttendanceList.every((student) => student.isPresent.value);
//   }
//
//   // Check if all students are absent
//   bool areAllStudentsAbsent() {
//     return studentAttendanceList.every((student) => !student.isPresent.value);
//   }
//
//   // Toggle the attendance status of a specific student
//   void toggleAttendanceForStudent(String studentId) {
//     var studentIndex = studentAttendanceList.indexWhere((student) => student.studentId == studentId);
//     if (studentIndex != -1) {
//       studentAttendanceList[studentIndex].isPresent.value = !studentAttendanceList[studentIndex].isPresent.value;
//       update();
//       Vibration.vibrate(duration: 100);
//     }
//   }
//
//   // Toggle the attendance status for all students
//   void toggleAttendanceForAll(bool markPresent) {
//     for (var student in studentAttendanceList) {
//       student.isPresent.value = markPresent;
//     }
//     Vibration.vibrate(duration: 100);
//     update();
//   }
// }
