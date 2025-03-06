import 'package:get/get.dart';
import 'attendance_report_controller.dart';

class AttendanceReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceReportController>(() => AttendanceReportController());
  }
}