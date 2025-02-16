// user_management_binding.dart
import 'package:get/get.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/controllers/user_management_controller.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}






