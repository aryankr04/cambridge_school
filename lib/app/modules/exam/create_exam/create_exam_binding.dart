// Filename: management/admin/class_management/class_management_binding.dart

import 'package:cambridge_school/app/modules/exam/create_exam/create_exam_controller.dart';
import 'package:get/get.dart';


class CreateExamBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CreateExamController());
  }
}
