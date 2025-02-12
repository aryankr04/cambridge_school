import 'package:cambridge_school/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:get/get.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}
