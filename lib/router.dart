import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_binding.dart';
import 'package:cambridge_school/app/modules/attendance/attendance_report/attendance_binding.dart';
import 'package:cambridge_school/app/modules/attendance/attendance_report/attendance_report_screen.dart';
import 'package:cambridge_school/app/modules/attendance/mark_attendance/mark_attendance_screen.dart';
import 'package:cambridge_school/app/modules/class_management/class_management_binding.dart';
import 'package:cambridge_school/app/modules/class_management/class_management_screen.dart';
import 'package:cambridge_school/app/modules/leave/apply_leave/apply_leave_binding.dart';
import 'package:cambridge_school/app/modules/leave/apply_leave/apply_leave_screen.dart';
import 'package:cambridge_school/app/modules/leave/leave_dashboard/leave_dashboard_binding.dart';
import 'package:cambridge_school/app/modules/leave/leave_dashboard/leave_dashboard_screen.dart';
import 'package:cambridge_school/app/modules/leave/leave_request/leave_request_binding.dart';
import 'package:cambridge_school/app/modules/leave/leave_request/leave_request_screen.dart';
import 'package:cambridge_school/app/modules/school_management/create_school/create_school_screen.dart';
import 'package:cambridge_school/app/modules/routine/create_routine/create_routine_binding.dart';
import 'package:cambridge_school/app/modules/routine/create_routine/create_routine_screen.dart';
import 'package:cambridge_school/app/modules/school_management/edit_school/edit_school_details_screen.dart';
import 'package:cambridge_school/app/modules/school_management/manage_school/manage_school_binding.dart';
import 'package:cambridge_school/app/modules/school_management/manage_school/manage_school_screen.dart';
import 'package:cambridge_school/app/modules/school_management/school_list/school_list_binding.dart';
import 'package:cambridge_school/app/modules/school_management/school_list/school_list_screen.dart';
import 'package:cambridge_school/app/modules/user_management/create_user/bindings/create_user_binding.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/bindings/user_management_binding.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_management_screen.dart';
import 'package:get/get.dart';
import 'app/modules/attendance/attendance_record/attendance_record_screen.dart';
import 'app/modules/attendance/mark_attendance/mark_attendance_binding.dart';
import 'app/modules/auth/login/login_binding.dart';
import 'app/modules/auth/login/screens/login_screen.dart';
import 'app/modules/notice/create_notice/create_notice_binding.dart';
import 'app/modules/notice/create_notice/create_notice_screen.dart';
import 'app/modules/notice/notice/notice_binding.dart';
import 'app/modules/notice/notice/notice_screen.dart';
import 'app/modules/on_boarding/on_boarding_screen.dart';
import 'app/modules/on_boarding/onboarding_binding.dart';
import 'app/modules/school_management/create_school/create_school_binding.dart';
import 'app/modules/school_management/edit_school/edit_school_details_binding.dart';
import 'app/modules/user_management/create_user/screens/create_user_screen.dart';

class AppRoutes {
  //----------------------------------------------------------------------------
  // Route Names (Constants)

  /// The initial route of the application.
  static const String initialRoute = '/onboarding';

  /// Route for the Onboarding screen.
  static const String onboardingRoute = '/onboarding';

  /// Route for the Login screen.
  static const String loginRoute = '/login';

  /// Route for the Create User screen.
  static const String createUserRoute = '/create-user';

  /// Route for the User Management screen.
  static const String userManagementRoute = '/user-management';

  /// Route for the Class Management screen.
  static const String classManagementRoute = '/class-management';

  /// Route for the School Management screen.
  static const String createSchoolRoute = '/create-school';

  /// Route for the Mark Attendance screen.
  static const String markAttendanceRoute = '/mark-attendance';

  /// Route for the Attendance Record screen.
  static const String attendanceRecordRoute = '/attendance-record';

  /// Route for the Attendance Report screen.
  static const String attendanceReportRoute = '/attendance-report';

  /// Route for the Pending Approval screen (currently unused).
  static const String pendingApprovalRoute = '/pending-approval';

  /// Route for the Success screen (currently unused).
  static const String successScreenRoute = '/success-screen';

  /// Route for the Create Notice screen.
  static const String createNoticeRoute = '/create-notice';

  /// Route for the Notice screen.
  static const String noticeScreenRoute = '/notice';

  /// Route for the Apply Leave screen.
  static const String applyLeaveRoute = '/apply-leave';

  /// Route for the Leave Dashboard screen.
  static const String leaveDashboardRoute = '/leave-dashboard';

  /// Route for the Leave Leave Request screen.
  static const String leaveRequestRoute = '/leave-request';

  /// Route for the Create Routine screen.
  static const String createRoutineRoute = '/create-routine';
  static const String createRoutineRoute0 = '/create-routine0';
  static const String manageSchoolRoute = '/manage-school';
  static const String schoolListRoute = '/school-list';
  static const String editSchoolRoute = '/edit-school';

  //----------------------------------------------------------------------------
  // Route Definitions (Using GetX GetPage)

  static final routes = [
    GetPage(
      name: onboardingRoute,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: loginRoute,
      page: () => Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: createUserRoute,
      page: () => const CreateUserScreen(),
      binding: CreateUserBinding(),
    ),
    GetPage(
      name: userManagementRoute,
      page: () => const UserManagementScreen(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: createSchoolRoute,
      page: () => CreateSchoolScreen(),
      binding: CreateSchoolBinding(),
    ),
    GetPage(
      name: classManagementRoute,
      page: () => const ClassManagementScreen(),
      binding: ClassManagementBinding(),
    ),
    GetPage(
      name: attendanceRecordRoute,
      page: () => const AttendanceRecordScreen(),
      binding: AttendanceRecordBinding(),
    ),
    GetPage(
      name: markAttendanceRoute,
      page: () => const MarkAttendanceScreen(),
      binding: MarkAttendanceBinding(),
    ),
    GetPage(
      name: attendanceReportRoute,
      page: () => AttendanceReportScreen(),
      binding: AttendanceReportBinding(),
    ),
    GetPage(
      name: createNoticeRoute,
      page: () => const CreateNoticeScreen(),
      binding: CreateNoticeBinding(),
    ),
    GetPage(
      name: noticeScreenRoute,
      page: () => NoticeScreen(),
      binding: NoticeBinding(),
    ),
    GetPage(
      name: applyLeaveRoute,
      page: () => const ApplyLeaveScreen(),
      binding: ApplyLeaveBinding(),
    ),
    GetPage(
      name: leaveDashboardRoute,
      page: () => const LeaveDashboardScreen(),
      binding: LeaveDashboardBinding(),
    ),
    GetPage(
      name: leaveRequestRoute,
      page: () => LeaveRequestScreen(),
      binding: LeaveRequestBinding(),
    ),
    GetPage(
      name: createRoutineRoute,
      page: () => const CreateRoutineScreen(schoolId: 'SCH00001'),
      binding: CreateRoutineBinding(),
    ),
    GetPage(
      name: schoolListRoute,
      page: () =>   const SchoolListScreen(),
      binding: SchoolListBinding(),
    ),
    GetPage(
      name: manageSchoolRoute,
      page: () =>   const ManageSchoolScreen(),
      binding: ManageSchoolBinding(),
    ),
    GetPage(
      name: editSchoolRoute,
      page: () => EditSchoolDetailsScreen(schoolId: Get.parameters['schoolId'] ?? ''),
      binding: EditSchoolDetailsBinding(schoolId: Get.parameters['schoolId'] ?? ''),
    ),

  ];
}
