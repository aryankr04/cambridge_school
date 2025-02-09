// Filename: management/admin/class_management/class_management_binding.dart

import 'package:get/get.dart';

import 'class_management_controller.dart';

class ClassManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ClassManagementController());
  }
}
