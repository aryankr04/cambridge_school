import 'package:get/get.dart';

class StudentAttendance {
  final String studentId;
  final String name;
  final String roll;
  final RxBool isPresent; // Change this line

  StudentAttendance({
    required this.studentId,
    required this.name,
    required this.roll,
    required bool initialIsPresent,
  }) : isPresent = RxBool(initialIsPresent);
}
