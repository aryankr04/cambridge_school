import 'package:cambridge_school/app/modules/leave/leave_dashboard/leave_dashboard_controller.dart';
import 'package:get/get.dart';

class LeaveDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveDashboardController>(() => LeaveDashboardController());
  }
}