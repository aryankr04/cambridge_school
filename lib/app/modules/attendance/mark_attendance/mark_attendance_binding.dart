import 'package:cambridge_school/app/modules/attendance/mark_attendance/mark_attendance_controller.dart';
import 'package:get/get.dart';

class MarkAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarkAttendanceController>(() => MarkAttendanceController());
  }
}