import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_binding.dart';
import 'package:cambridge_school/app/modules/class_management/class_management_binding.dart';
import 'package:cambridge_school/app/modules/class_management/class_management_screen.dart';
import 'package:cambridge_school/app/modules/manage_school/screens/create_school_0.dart';
import 'package:cambridge_school/app/modules/user_management/create_user/bindings/create_user_binding.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/bindings/user_management_binding.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_management_screen.dart';
import 'package:cambridge_school/demo.dart';
import 'package:get/get.dart';

import 'app/modules/attendance/attendance_record/attendance_record_controller.dart';
import 'app/modules/attendance/attendance_record/attendance_record_screen.dart';
import 'app/modules/auth/login/login_binding.dart';
import 'app/modules/auth/login/screens/login_screen.dart';
import 'app/modules/on_boarding/on_boarding_screen.dart';
import 'app/modules/on_boarding/onboarding_binding.dart';
import 'app/modules/user_management/create_user/screens/create_user_screen.dart';

class AppRoutes {
  static const String initial = '/demo';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String createUser = '/create-user';
  static const String userManagement = '/user-management';
  static const String classManagement = '/class-management';
  static const String schoolManagement = '/school-management';
  static const String markAttendance = '/mark-attendance';
  static const String attendanceRecord = '/attendance-record';

  static const String pendingApproval = '/pending-approval';
  static const String successScreen = '/success-screen';

  static final routes = [
    GetPage(
      name: initial,
      page: () => const Demo(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
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
    GetPage(
      name: userManagement,
      page: () => const UserManagementScreen(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: schoolManagement,
      page: () => const CreateSchool0(),
    ),
    GetPage(
      name: classManagement,
      page: () => const ClassManagementScreen(),
      binding: ClassManagementBinding(),
    ),
    GetPage(
      name: attendanceRecord,
      page: () => const AttendanceRecordScreen(),
      binding: AttendanceRecordBinding(),
    ),
  ];
}
