import 'package:cambridge_school/app/modules/leave/apply_leave/apply_leave_controller.dart';
import 'package:get/get.dart';

class ApplyLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplyLeaveController>(() => ApplyLeaveController());
  }
}