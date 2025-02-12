import 'package:cambridge_school/app/modules/user_management/bindings/create_user_binding.dart';
import 'package:get/get.dart';

import 'app/modules/auth/login/login_binding.dart';
import 'app/modules/auth/login/screens/login.dart';
import 'app/modules/user_management/screens/create_user_screen.dart';

class AppRoutes {
  static const String initial = '/create-user';
  static const String login = '/login';
  static const String register = '/register';
  static const String pendingApproval = '/pending-approval';
  static const String successScreen = '/success-screen';
  static const String createUser = '/create-user';

  static final routes = [
    GetPage(
      name: login,
      page: () => Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: createUser,
      page: () => const CreateUserScreen(),
      binding: CreateUserBinding(),
    ),
  ];
}
