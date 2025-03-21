import 'package:get/get.dart';

import 'edit_school_details_controller.dart';

class EditSchoolDetailsBinding extends Bindings {
  final String schoolId;
  EditSchoolDetailsBinding({required this.schoolId});
  @override
  void dependencies() {
    Get.lazyPut<EditSchoolController>(() => EditSchoolController(initialSchoolId: schoolId));
  }
}