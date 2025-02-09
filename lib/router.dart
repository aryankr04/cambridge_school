

import 'package:get/get_navigation/src/routes/get_route.dart';

import 'modules/auth/login/screens/login.dart';
import 'modules/auth/register/screens/student/pending_approval_screen.dart';
import 'modules/auth/register/screens/student/student0.dart';

class AppRoutes {
  static const String initial = '/login'; // Define an initial route
  static const String login = '/login';
  static const String contactList = '/contact-list';
  static const String chat = '/chat';
  static const String home = '/home';
  static const String register = '/register';
  static const String pendingApproval = '/pending-approval';
  static const String accountInactive = '/account-inactive';

  static final routes = [
    GetPage(name: login, page: () => Login()),
    GetPage(name: register, page: () => const AddStudent()),
    GetPage(name: pendingApproval, page: () =>  PendingApprovalScreen()),
    // GetPage(name: accountInactive, page: () => const AccountInactiveScreen()),
    // GetPage(name: contactList, page: () => ContactListScreen()),
    // GetPage(name: chat, page: () => ChatScreen(contact: Get.arguments as ContactModel,)),
    // GetPage(name: home, page: () => HomeScreen()),
  ];
}