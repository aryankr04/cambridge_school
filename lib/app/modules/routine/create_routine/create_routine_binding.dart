
import 'package:get/get.dart';

import 'create_routine_controller.dart';

class CreateRoutineBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CreateRoutineController());
  }
}
