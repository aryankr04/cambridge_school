import 'package:cambridge_school/app/modules/school_management/create_school/create_school_controller.dart';
import 'package:cambridge_school/app/modules/school_management/school_list/school_list_controller.dart';
import 'package:get/get.dart';

class SchoolListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolListController>(() => SchoolListController());
  }
}