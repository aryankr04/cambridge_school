import 'package:get/get.dart';
import 'attendance_record_controller.dart';

class AttendanceRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceRecordController>(
          () => AttendanceRecordController(),
    );
  }
}