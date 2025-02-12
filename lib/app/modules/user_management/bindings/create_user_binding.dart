import 'package:cambridge_school/app/modules/user_management/controllers/create_user_controller.dart';
import 'package:get/get.dart';

class CreateUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateUserController>(() => CreateUserController());
  }
}
