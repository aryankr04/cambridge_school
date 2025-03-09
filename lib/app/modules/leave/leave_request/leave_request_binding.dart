import 'package:cambridge_school/app/modules/leave/leave_dashboard/leave_dashboard_controller.dart';
import 'package:cambridge_school/app/modules/leave/leave_request/leave_request_controller.dart';
import 'package:get/get.dart';

class LeaveRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveRequestController>(() => LeaveRequestController());
  }
}