import 'package:cambridge_school/app/modules/school_management/create_school/create_school_controller.dart';
import 'package:get/get.dart';

class CreateSchoolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSchoolController>(() => CreateSchoolController());
  }
}